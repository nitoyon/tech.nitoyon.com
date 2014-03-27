---
layout: post
title: Git for Windows でレポジトリー上の CR LF を LF に変換する手順
tags: Git Windows
lang: ja
thumbnail: http://farm4.staticflickr.com/3792/9191502091_5f4e156b87_o.jpg
seealso:
- ja/2014-03-07-fancy-git-bash
- ja/2013-07-23-git-patch
- ja/2013-07-02-git-dir-diff
- ja/2013-01-11-github-clone-http
- ja/2013-03-29-git-new-workdir
---
Git for Windows では改行コードが「レポジトリー上は LF」「ワーキング ディレクトリーは CR LF」となるように、git config の `core.autocrlf` が `true` となる状態でインストールされる (インストーラーでデフォルトの [Checkout Windows-style, commit Unix-style line endings] を選択した場合)。

Windows 以外の文化圏の人は CR LF を見ると CR がゴミに見えるので、妥当な設定だろう。

標準設定の `autocrlf` が `true` のときに、レポジトリー上に CR LF なファイルが紛れ込んでいないか調べたり、紛れ込んだ CR LF を LF に変換したかったのだけど、この手順が少しややこしかったので記事にまとめておく。

(`autocrlf` を `false` にして clone したらすぐに分かる…という話なんだけど、大きなレポジトリーを clone しなおすのはストレスフルなので、その場で確認する手順を調べてみた)

※ Git for Windows は 1.9 と 1.8.4 で検証した


レポジトリー上に CR LF のファイルがあるか調べたい
=================================================

レポジトリー上のファイルの改行コードは LF で統一しているつもりなのに、CR LF のファイルが混ざりこんでたら悲しい。

`autocrlf` が `true` な状態で、レポジトリー上に CR LF のファイルが入ってないか調べるには次のようにする。

```console
$ git grep --cached -I $'\r'
```

オプションの補足:

 * `--cached` を指定しないと、ワーキング ディレクトリー上のファイルから CR を探してしまう。つまり、`core.autocrlf` が `true` な状態では、すべての改行がヒットしてしまう。
 * `-I` でバイナリー ファイルを無視している。

実行例
------

https://gist.github.com/nitoyon/9808563 に CRLF と LF のファイルの 2 つがあるレポジトリーを用意してみた。

`core.autocrlf` が `true` な状態で clone すると、両方のファイルが CRLF でチェックアウトされる。

この状態で上記のコマンドを実行してみると、CR LF のほうだけが引っかかる。

```console
$ git grep --cached -I $'\r'
crlf-test.txt:End of Line Character Test^M
crlf-test.txt:^M
crlf-test.txt:Which do you like CR LF or LF?^M
crlf-test.txt:^M
crlf-test.txt:This file uses "CR LF"!!!!^M
crlf-test.txt:^M
crlf-test.txt:Clone me!^M
```

めでたし。


レポジトリー上の CR LF を LF に変換したい
=========================================

万が一、レポジトリー上に CR LF を発見したら、LF に統一しよう。

こちらも `core.autocrlf` が `true` になっている状態からの手順を示しておく。


1. 一時的に `core.autocrlf` を `false` に設定する。

    ```console
    $ git config core.autocrlf false
    ```

2. LF でチェックアウトするために、ワーク ディレクトリーのファイルを全部削除してから、チェックアウトする (一度削除しないと反映されないことがあった!!)。

    ```console
    $ rm -rf .
    $ git checkout .
    ```

4. CR LF になっているファイルを何らかのエディターで LF に変換する。

5. コミットする。

    ```console
    $ git add . && git commit
    ```

6. `autocrlf` の設定を戻す。

    ```console
    $ git config core.autocrlf true
    ```

実行例
------

再び、https://gist.github.com/nitoyon/9808563 で試してみる。

作業完了後の diff はこんな感じになる。

```diff
$ git diff HEAD~
diff --git a/crlf-test.txt b/crlf-test.txt
index ad9608a..85a3c62 100644
--- a/crlf-test.txt
+++ b/crlf-test.txt
@@ -1,7 +1,7 @@
-End of Line Character Test
-
-Which do you like CR LF or LF?
-
-This file uses "CR LF"!!!!
-
-Clone me!
+End of Line Character Test
+
+Which do you like CR LF or LF?
+
+This file uses "CR LF"!!!!
+
+Clone me!
```

違いが分かりにくい diff が表示されていて悲しい。git の diff では CR があると `^M` として警告してくれるはずなんだけど、`^M` が表示されるのは `+` から始まる行だけのようだ。今回のような「CR LF が LF になった」ケースでは CR があるのは `-` の行なので `^M` は表示してくれない…。

`--ignore-space-at-eol` を指定して行末スペースの変更を無視したら、diff が消え去るので、うまくいっていると信じる。

```console
$ git diff --ignore-space-at-eol HEAD~
```

`git grep` でも CR を見つけられなくなるので、うまくいっていると信じる。

```console
$ git grep --cached -I $'\r'
```

まとめ
======

Windows はつらいよ。
