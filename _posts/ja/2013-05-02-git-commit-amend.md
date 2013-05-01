---
layout: post
title: git commit --amend を省力化する方法
tags:
  - Git
lang: ja
seealso:
  - 2013-04-05-sourcetree
  - 2013-03-29-git-new-workdir
  - 2013-01-11-github-clone-http
  - 2012-04-12-msysgit-utf8-2
  - 2012-02-21-msysgit-utf8
---
Git で最後のコミットを修正するときには `git commit --amend` を使うんだけども、いままでは

  1. `git add .`
  2. `git commit --amend`
  3. エディターが立ち上がって、前回のコミット メッセージが表示される
  4. エディターを終了させる

としていた。

この作業は何度も繰り返すと面倒だったので、man を調べてみると `--no-edit` なるステキなオプションを発見した。

--no-edit を使う
================

`--no-edit` を指定すると、上の手順はこうなる。

  1. `git add .`
  2. `git commit --amend --no-edit`


コミット メッセージはそのままに、コミットの中身だけを書き換えられる。エディターが立ち上がらないので楽チン。


-a でさらに省力化
=================

さらに `git add .` も省力化できて

```
git commit -a --amend --no-edit
```

とすればよい。

**コマンド一発**になった。超楽チン。

注意点は次の 2 つ。

  * 新しいファイルを追加したときは明示的に add する必要がある。`git add .` と `git commit -a` ではステージするファイルが違うので注意。
  * コミットしたくない変更がワーキング ディレクトリーに残ってる状態では使えない。`git stash` するなどでよけておくべし。
