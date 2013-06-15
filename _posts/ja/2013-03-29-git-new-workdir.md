---
layout: post
title: Git で複数ブランチを同時に扱いたいなら git-new-workdir が便利
tags: Git
lang: ja
seealso:
  - 2012-09-20-moved-completed
  - 2013-01-11-github-clone-http
  - 2012-04-12-msysgit-utf8-2
  - 2012-02-21-msysgit-utf8
  - 2012-12-25-jekyll-0-12-0
---
Git で管理してるレポジトリーで、いくつかのブランチを別々の場所にチェックアウトしたいことがある。

たとえば

  * GUI なツールでブランチ間の比較したい
  * 同時に実行して比較しつつテストしたい
  * ブランチ間でファイルをコピーしたい
  * ドキュメントの生成結果を別ブランチで管理したい

といったときに、必要になる。

ブランチの個数だけ clone しちゃえば用は足りそうなんだけど、でかいレポジトリーだったら時間もディスク容量ももったいない。


git-new-workdir を使うべきでしょう！
====================================

先日、「git-new-workdir を使えばワーキング ディレクトリーを複数を作れて便利」と書いてあるブログを読んだ。

  * [git-new-workdir が便利 - #生存戦略 、それは - subtech](http://subtech.g.hatena.ne.jp/secondlife/20121207/1354854068)

`git-new-workdir` の usage を見てたら、別ブランチのワーキング ディレクトリー作成にも対応しているらしい！

```
git-new-workdir <repository> <new_workdir> [<branch>]
```

これは活用しない手はない。


git-new-workdir はこんなに便利
------------------------------

`master` ブランチで作業しているとして、`develop` ブランチの中身も展開したいと思ったとする。

```
git-new-workdir . ../foo-develop develop
```

これだけで `../foo-develop` に `develop` ブランチの中身を展開してくれる。

展開の処理に工夫があって、ワーキングディレクトリーとステージ (インデックス) は独立なんだけど、コミット履歴などはシンボリックリンクで共有されている。

だから、ワーキング ディレクトリーの中身を比較できるのはもちろん、別々の場所で編集してコミットしてもよい。片方でコミットした内容は、もう片方で `git log` すれば表示できる。

`git push` すれば `master` と `develop` の両方の変更を一気に push できる。別々に clone していたらありえない。

もちろん、`git fetch` も、どちらか一方で実行すれば、もう片方も最新の状態になってる。

いろいろ便利でハッピー！


ドキュメントを別ブランチで管理するような場合にも使える
------------------------------------------------------

GitHub Pages を使うときにはありがちなんだけど、ドキュメントの生成結果を別ブランチにコミットする。このブログでは、Jekyll でサイト生成した結果を別ブランチにコミットしている (詳しくは {% post_link 2012-09-20-moved-completed %} 参照)。

このようなケースには、サブモジュールを使うテクニックが知られている。

  * [Doxygen を github-pages にあげるのをお気楽にやる方法 - tokuhirom's blog.](http://blog.64p.org/entry/20100310/1268189518)
  * [github のプロジェクトにSphinxドキュメントを良さげな感じにおきたい 其の二 - Study08.net 対シンバシ殲滅用人型機動兵器](http://tell-k.hatenablog.com/entry/2012/01/20/020531)
  * [GitHub 上に ページを作成する | Tanablog](http://blog.kaihatsubu.com/?p=1836)

このテクニックは一見便利そうなんだけども、使っているうちに不便なところが目に付いてきた・・・。

  * 同じレポジトリーを 2 回 clone するので非効率的。
  * 2 つの作業ディレクトリーのそれぞれで push, pull しなきゃいけない。
  * ドキュメントのディレクトリーでコミットするたびに、submodule が更新された状態になる。それを放置してると、`submodule init` した人が古い状態のツリーを参照してしまうので、定期的にコミットして、サブモジュールの指す先を更新する必要がある。

サブモジュールはそもそも別の Git レポジトリーを管理するために設計されたものだし、同じレポジトリーをサブモジュールとして持つのはいろいろ弊害あるように思う。

で、サブモジュールに困っていたところで、`git-new-workdir` を使ってみたら便利だった。

開発用ブランチが `master` で、ドキュメントのブランチが `gh-pages` だとして、gh-pages ディレクトリーに `gh-pages` ブランチの中身をチェックアウトする。

```
git-new-workdir . gh-pages gh-pages
```

これで、Git レポジトリー直下の gh-pages ディレクトリーに `gh-pages` ブランチがチェックアウトされた。間違ってディレクトリーの中身をコミットしないように `.gitignore` に gh-pages を入れておくと安全だろう。

あとは個別のディレクトリーで編集してコミットしていく。先ほどの例と同じく、片方でコミットした内容は、もう片方の作業ディレクトリーで `git log` すれば反映されるし、`git push` すれば一気にリモートに反映される。

便利便利である。


git-new-workdir の導入方法
==========================

git-new-workdir は git-core の contrib に入っている。詳しくは [git-new-workdir が便利 - #生存戦略 、それは - subtech](http://subtech.g.hatena.ne.jp/secondlife/20121207/1354854068) を参照。

ただ、Windows で Git for Windows (msysGit) を使ってる場合は、そのまま持ってきても動かないので、次のようにした。

  1. [git/contrib/workdir/git-new-workdir-win at master - dansmith65/git](https://github.com/dansmith65/git/blob/master/contrib/workdir/git-new-workdir-win) から git-new-workdir-win を拾ってくる。
  2. `C:\Program Files (x86)\Git\libexec\git-core` に `git-new-workdir` としてコピーする。(x86 環境なら `Program Files (x86)` を `Program Files` に読み替えるべし)

これでおしまい。ただし、mklink.exe を使う関係で、UAC 有効にしてる環境では、bash を管理者として実行しておかないと、権限が足りなくてエラーになるので注意すべし。


まとめ
======

`git-new-workdir` で便利な Git 生活を！
