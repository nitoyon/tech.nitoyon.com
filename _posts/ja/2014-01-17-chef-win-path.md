---
layout: post
title: Windows で Chef するときに PATH で混乱しないように専用のコンソールを作った
tags: Windows
lang: ja
thumbnail: http://farm6.staticflickr.com/5527/11980775965_db01e8d319_o.png
---
話題の [Chef](http://www.getchef.com/) をいまさら試したくなって、手元の Windows 環境に環境を作ってみた。

http://www.getchef.com/chef/install/ からインストーラーをダウンロードしてインストールした。Cygwin を使うと[無駄にはまる](http://dqn.sakusakutto.jp/2013/12/berkshelf_chef_gem_ruby.html)し、ぐぐるといっぱい出てくる「gem から入れる手順」は公式サイトでは見つからなくなっている。

すべてデフォルトでインストールすると、`C:\opscode\chef` にファイルがいっぱい展開されていた。


PATH に追加される 2 つのフォルダー
==================================

インストーラーから Chef を入れると、`PATH` に

  * `C:\opscode\chef\bin`
  * `C:\opscode\chef\embedded\bin`

の 2 つが追加される。

`C:\opscode\chef\bin` には Chef 関係のプログラム (`chef-solo`, `knife` など...) が入っている。

一方、`C:\opscode\chef\embedded\bin` には UNIX 関係のプログラム (`ruby.exe`, `perl.exe`, `ls.exe`, `cat.exe` など...) が入っている。


ピンチ！　既存の Ruby 環境と競合！！
====================================

全部入りでありがたいんだけど、`ruby.exe` や `perl.exe` にパスが通ってしまうのが気持ち悪い。

自分の環境では、Chef のやつ以外にも Ruby を `C:\Ruby200-x64\bin` にインストールしていて、そっちにも `PATH` が通った状態になっている。

この状態で、`gem install knife-solo` すると、先にインストールしたほうの Ruby の gem が動く。自分の場合は Chef が後だったので、`C:\Ruby200-x64\bin` のほうの gem が動いた。その結果、`C:\Ruby64` の下に knife-solo が入って、おかしな状態になった。

この環境では、Chef 側の何らかのコマンドが `C:\opscode\chef\embedded\bin\ruby.exe` を実行するつもりで `ruby` を実行したとしても、`C:\Ruby200-x64\bin\ruby.exe` が実行されてしまうわけで、変なバグに困らされる確率が高そうだ。

何かと嫌な予感がするので、対策することにした。


解決法: Chef 用のコンソールを作る
=================================

Visual Studio を入れたら「開発者コンソール」がスタート メニューに入るし、Git for Windows でも MS-DOS から隔離された Git Bash で作業をする。

同じように、Chef にも専用のコマンド プロンプトを用意することにした。

ということで作ってみた。手順は 2 段階。


1. バッチファイルを作る
-----------------------

こちらがそのバッチファイル。これを `C:\opscode\chefenv.bat` といった名前で保存しておく。


```bat
@ECHO OFF

SET PATH=c:\opscode\chef\bin;c:\opscode\chef\embedded\bin
SET PATH=%PATH%;c:\windows\system32;c:\windows

title Chef Env
chef-solo -v
```


2. ショートカットを作る
-----------------------

このファイルへのショートカットを作る。

[リンク先] は `C:\Windows\System32\cmd.exe /K C:\opscode\chefenv.bat` に設定する (`/K` は「バッチを実行して、ウインドウを閉じない」という意味)。

[作業フォルダー] は Chef レポジトリーのパスか、マイドキュメントのパスにでもしておくとよいだろう。

ショートカットのファイル名は何でもよいけど、「Chefコマンド プロンプト」とでもしておいてスタートメニューに登録するなり、デスクトップに置くなり、ランチャーに登録するなりしておくとよいだろう。


使い方
======

ショートカットを叩くと、`PATH` が限定された状態でコマンドプロンプトが立ち上がってくれる。

{% image http://farm6.staticflickr.com/5527/11980775965_c14b1872a6.jpg, 677, 493 %}

`chef-solo` も `knife` も実行できる。めでたし。

ついでに、システム全体の `PATH` から `c:\opscode` 以下の 2 つを削っておくと、コマンドプロンプトを使ったときの混乱も起きなくなって幸せ。

ぜひお試しください。
