---
layout: post
title: ファイル編集したら即ブラウザー再読込させる LiveReloadX を作った
tags: JavaScript release LiveReloadX Node.js
lang: ja
alternate:
  lang: en_US
  url: /en/blog/2013/02/27/livereloadx/
thumbnail: http://farm9.staticflickr.com/8243/8510507292_4af6b77d5f_o.png
seealso:
  - 2013-02-19-node-source-map
  - 2012-09-20-moved-completed
  - 2012-04-20-uncopyable
  - 2012-03-06-inexpensive-moving
  - 2009-04-15-hokkaido
  - 2007-09-14-how-to-install-rascut
---
{% image http://farm9.staticflickr.com/8100/8509399251_7056f91a11.jpg, 620, 365 %}

Web 開発してると、ソースを編集して、ブラウザーをリロードして、という作業の繰り返しになりがちだ。ソースを編集したら、自動でブラウザーをリロードしてくれるような夢のツールがあれば便利そうだ。

この分野では [CodeKit](http://incident57.com/codekit/) や [LiveReload](http://livereload.com/) などが有名なんだけど、もれなく有料だったり GUI だったりする。そこで、[LiveReload](http://livereload.com/) のオープンソースな部分を参考にしつつ、コマンドラインで使える [LiveReloadX](http://nitoyon.github.com/livereloadx/) というものを作ってみた。

特長はこんなところ。

  * Node.js を使ってるので Windows/Mac/Linux 問わずに動かせる
  * 開発環境のブラウザーだけでなくスマートフォンのブラウザーもリロードできる
  * 無料


インストール方法
================

インストールは超簡単！

1. [Node.js](http://nodejs.org/) をインストールする。
2. コマンドラインで `npm install -g livereloadx` を実行する。


動作原理
========

{% image http://farm9.staticflickr.com/8099/8509399561_17e6288376.jpg, 750, 239 %}

インストールしたら `livereloadx` コマンドが動くようになる。ただ、それだけではブラウザーはリロードしてくれないので、ちょいと動作原理を説明しておく。

  1. コマンドラインで `livereloadx path/to/dir` を実行すると、LiveReloadX が開始して、次のような処理をする。
     * フォルダー `path/to/dir` の監視を開始する。
     * ポート `35729` で Web サーバーとして動き始める。この Web サーバーは `livereload.js` を公開しつつ、WebSocket サーバーとしても動く。
  2. ブラウザーで `livereload.js` を読み込むと、LiveReloadX サーバーに WebSocket で接続しにいく。
  3. `path/to/dir` 配下のファイルを更新したら、LiveReloadX サーバーはブラウザーに WebSocket で通知を出す。通知を受け取ったブラウザーは再読込する。

ということで、ブラウザーに `livereload.js` を読み込ませる方法が重要になってくる。


livereload.js の読み込ませ方
============================

4 通りあるので、好きなやつを選ぶことになる。

   * 手動で追加する
   * ブラウザー拡張をインストールする (PC 版 Safari・Chrome・Firefox のみ).
   * static モードで実行する
   * proxy モードで実行する

前半の 2 つは LiveReload で提供されてる手段で、後半の 2 つはオリジナルだ。


手動で追加する
--------------

{% image http://farm9.staticflickr.com/8506/8509400159_435002302f.jpg, 400, 203 %}

既存の HTML ファイルに次の `<script>` タグ (JavaScript スニペット) を追加する。それだけ。

```html
<script>document.write('<script src="http://' + (location.host || 'localhost').split(':')[0] +
':35729/livereload.js?snipver=2"></' + 'script>')</script>
```

静的な HTML ファイルで開発してる場合とか、動的 HTML だけどテンプレートを編集するだけで済む場合は、この手順が楽だろう。


ブラウザー拡張をインストールする
--------------------------------

{% image http://farm9.staticflickr.com/8252/8509400245_25dbf28c7f.jpg, 400, 208 %}

ソースはいじりたくないよ、という場合は [How do I install and use the browser extensions? – LiveReload Help & Support](http://feedback.livereload.com/knowledgebase/articles/86242-how-do-i-install-and-use-the-browser-extensions-) からブラウザー拡張を導入するとよい。ただし、対応するブラウザーは PC 版 Safari・Chrome・Firefox のみに限られる。

拡張の LiveReload ツールバーのボタンを押すと、`livereload.js` が表示中のページに動的に挿入されるようになる。


static モードで実行する
-----------------------

{% image http://farm9.staticflickr.com/8240/8509400365_6086b6644a.jpg, 700, 218 %}

静的なサイトのときには、これが便利かもしれない。`-s` か `--static` オプションつきで実行する。

```bash
livereloadx -s [-p 35729] [path/to/dir]
```

static モードでは**静的 Web サーバー**として動作する。

たとえば、`http://localhost:35729/foo/` にアクセスすると `path/to/dir/foo/index.html` からファイルを読み取って返してくれる。ついでに、`<script>` タグを自動で挿入して、ブラウザーが `livereload.js` を読み込むようにしてくれる。


proxy モードで実行する
----------------------

{% image http://farm9.staticflickr.com/8089/8510508898_7c8e065387.jpg, 700, 218 %}

HTML をいじりたくないし、ブラウザー拡張も入れたくないし、静的サイトでもないときは、この方法が便利だろう。`-y http://example.com/` か `--proxy http://example.com/` オプションをつけて実行する。

```
$ livereloadx -y http://example.com/ [-p 35729] [-l] [path/to/dir]
```

proxy モードでは**リバース プロキシー**として動作する。

たとえば、`http://localhost:35729/foo/` にアクセスすると、裏側で `http://example.com/foo/` からデータを取ってきてクライアントに返す。ついでに、`<script>` タグを自動で挿入して、ブラウザーが `livereload.js` を読み込むようにしてくれる。

さらに、`-l` か `--prefer-local` フラグをつけて起動すると、最初にローカルのファイルがあるか確認して、あればそっちを返すようになる。稼働中の本番環境のうち、一部の JavaScript とか CSS だけを手元に持ってきて編集しながら検証できて便利だ。


まとめ
======

LiveReloadX を紹介した。Node.js の勉強がてら作っていたのだけど、なかなか便利なツールになったのではないかと思う。

ソースは [nitoyon/livereloadx - GitHub](https://github.com/nitoyon/livereloadx)  にあるので、Star や Pull Request してもらえると、とてもうれしい。
