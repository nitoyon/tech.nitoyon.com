---
layout: post
title: Node.js の fs.watch() と fs.watchFile() の違い
tags: Node.js
lang: ja
alternate:
  lang: en_US
  url: /en/blog/2013/10/02/node-watch-impl/
seealso:
- ja/2013-06-27-node-yield
- ja/2013-06-25-jekyll-grunt
- ja/2013-04-17-jekyll-pluralize
- ja/2013-02-19-node-source-map
---
Node.js のファイル監視の API には `fs.watch()` と `fs.watchFile()` の 2 つがある。

微妙に機能がかぶっているし、使い分けが分かりにくかったので調べてみた。


公式情報を見る
==============

まずは公式の[ドキュメント (v0.8.0)](http://nodejs.org/docs/v0.8.0/api/fs.html#fs_fs_watchfile_filename_options_listener)を見てみた。

> ## fs.watchFile(filename, [options], listener)
>
> Stability: 2 - Unstable.  Use fs.watch instead, if available.
>
> Watch for changes on `filename`.
>
> ## fs.watch(filename, [options], [listener])
>
> Stability: 2 - Unstable.  Not available on all platforms.
>
> Watch for changes on `filename`, where `filename` is either a file or a directory.

と書いてある。

つまり

* `fs.watch()` の利用を推奨している
* `fs.watch()` は全てのプラットフォームで使えるわけではない
* `fs.watch()` はファイルとディレクトリを監視できるが、`fs.watchFile()` はファイルしか監視できない

ことが分かる。


歴史的見地から調べる
====================

次に、過去をさかのぼるために [ChangeLog](https://github.com/joyent/node/blob/master/ChangeLog) を見てみた。

* `fs.watchFile()` は v0.1.18 で `process.watchFile()` として登場した古い API
* `fs.watch()` は v0.5.9 で実装された新しい API

だと分かった。

しかし、これ以上の公式の情報が見つからなかったため、全体像が見えない。


ソースコードを見る
==================

困ったらソースコードを見ろ、と昔の偉い人も言っている。いざ、コード リーディング！

fs.watch()
----------

まずは、`fs.watch()` の実装をみてみよう。(ソースコードは執筆時点で最新の [v0.10.19] を利用する)

[`lib/fs.js`] → [`src/fs_event_wrap.cc`] の順にたどっていくと、`uv_fs_event_init()` 関数が本丸だと分かった。

`uv` で始まる関数は libuv で定義されたもの。libuv は Node.js のプラットフォーム間の差を吸収するためのライブラリらしく、IO やスレッド、タイマーなどの処理が実装されているようだ。

では、`uv_fs_event_init()` の実装を見てみる。`deps/uv/src` の下を grep してみると

* unix\aix.c
* unix\cygwin.c
* unix\kqueue.c
* unix\linux-inotify.c
* unix\sunos.c
* win\fs-event.c

が引っかかった。プラットフォームごとに実装が異なっているようだ。

ざっと読んでみると、

プラットフォーム | 実装方法
-----------------|---------------------------------
Linux            | inotify を利用
MacOS、*BSD      | kqueue を利用
Windows          | `ReadDirectoryChangesW()` を利用
Solaris          | Event Ports を利用
AIX              | (未対応)
Cygwin           | (未対応)

となっていた。

つまり、**fs.watch() はネイティブの監視処理を利用して、変更があったら OS から通知してもらっている**ことが分かった。


fs.watchFile()
--------------

一方の `fs.watchFile()` を見てみる。Node.js には古くから実装されているが、現在では利用が推奨されていないほうの関数である。

[`lib/fs.js`] → [`src/node_stat_watcher.cc`] の順にたどっていくと、`uv_fs_poll_start()` 関数が本丸だと分かった。

あとは、`uv_fs_poll_start()` の流れをつかめばおしまい。[`deps/uv/src/fs-poll.c`] を見てみよう。なんとなくポーリングをしていそうな名前である。

```c
int uv_fs_poll_start(uv_fs_poll_t* handle,
                     uv_fs_poll_cb cb,
                     const char* path,
                     unsigned int interval) {
  // 初期化処理は省略

  if (uv_fs_stat(loop, &ctx->fs_req, ctx->path, poll_cb))
    abort();
```

肝は `uv_fs_stat()` の呼び出し。この関数は、Node.js で言うところの `fs.stat()` 相当の処理だろう。ファイルの更新日時の取得を依頼して、取得が完了したら、`poll_cb()` が呼ばれる。

その [`poll_cb()`] を見てみよう。

```c
static void poll_cb(uv_fs_t* req) {
  // 異常処理とか、前回と違ってたらイベント発行する処理とか

  /* Reschedule timer, subtract the delay from doing the stat(). */
  interval = ctx->interval;
  interval -= (uv_now(ctx->loop) - ctx->start_time) % interval;

  if (uv_timer_start(&ctx->timer_handle, timer_cb, interval, 0))
    abort();
}

```

実行結果の解析が終わったら、`interval` 後に `timer_cb()` が呼ばれるようにタイマーを開始している。

`timer_cb()` では、再度 `uv_fs_stat()` を実行している。つまり、定期的に `fs.stat()` を実行している。


つまり、**fs.watchFile() は定期的に fs.stat() をポーリングで実行して、変更されたらイベントを発行している** ことが分かった。非常に原始的な実装になっている。


まとめ
======

`fs.watch()`:

  * 新しい API、利用が推奨されている
  * push 型 (OS の監視機能を利用しているので、待機中に CPU を消費しない)
  * 一部のプラットフォーム (AIX、Cygwin) では利用できない

`fs.watchFile()`:

  * 古い API、あまり使ってほしくなさそう
  * poll 型 (定期的に stat を実行する)
  * どのプラットフォームでも動く


[v0.10.19]: https://github.com/joyent/node/tree/v0.10.19
[`lib/fs.js`]: https://github.com/joyent/node/blob/v0.10.19/lib/fs.js
[`src/fs_event_wrap.cc`]: https://github.com/joyent/node/blob/v0.10.19/src/fs_event_wrap.cc#L102
[`src/node_stat_watcher.cc`]: https://github.com/joyent/node/blob/v0.10.19/src/node_stat_watcher.cc#L112
[`deps/uv/src/fs-poll.c`]: https://github.com/joyent/node/blob/v0.10.19/deps/uv/src/fs-poll.c#L56
[`poll_cb()`]: https://github.com/joyent/node/blob/v0.10.19/deps/uv/src/fs-poll.c#L139
