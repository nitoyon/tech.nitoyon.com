---
layout: post
title: Windows で Jekyll 1.3 を動かすまでの手順
lang: ja
tags: Jekyll Windows
thumbnail: http://farm4.staticflickr.com/3741/10839091955_4415c94104_o.png
seealso:
- ja/2012-09-20-moved-completed
- ja/2013-06-25-jekyll-grunt
- ja/2013-04-17-jekyll-pluralize
- ja/2012-12-25-jekyll-0-12-0
- ja/2012-10-15-static-site-js-css-cache
---
[Jekyll] を Windows で動かそうとすると、いくつか難関がある。今回、自分の環境を新しく作り直したキッカケがあったので、導入までの手順をメモしておく。

自分の環境は Windows 8 Pro x64。各種ツールのバージョンは次の通り。

  * Jekyll 1.3.0
  * Ruby 2.0.0 p247
  * DevKit 4.7.2-20130224-1432
  * Python 2.7.6
  * Pygentize 1.6

基本的には [Running Jekyll on Windows &#8211; Madhur Ahuja](http://www.madhur.co.in/blog/2011/09/01/runningjekyllwindows.html) の手順に近いけど、Pygments の導入手順などは少し違っているのと、日本語独自の問題についても書いている。


1. Ruby 環境を整備する
======================

[RubyInstaller for Windows](http://rubyinstaller.org/downloads/) から One-Click Ruby のインストーラーと Development Kit を導入する。

Development Kit はネイティブな gem の導入に必要。

今回導入したのは次のバージョン。

  * Ruby 2.0.0-p247 (rubyinstaller-2.0.0-p247-x64.exe)
  * DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe

Ruby インストーラーの実行
-------------------------

まず、Ruby のインストーラーを導入する。デフォルトで `C:\Ruby200-x64` にインストールされる。

環境変数の `PATH` に `C:\Ruby200-x64\bin` を追加しておこう。


DevKit の導入
-------------

`DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe` を実行すると、展開先を聞かれる。ここでは `C:\RubyDevKit` を選択した。

次に設定する。コマンドプロンプトで `dk.rb` の `init` と `initialize` を実行する。

```
c:\RubyDevKit>ruby dk.rb init
[INFO] found RubyInstaller v2.0.0 at C:/Ruby200-x64

Initialization complete! Please review and modify the auto-generated
'config.yml' file to ensure it contains the root directories to all
of the installed Rubies you want enhanced by the DevKit.

c:\RubyDevKit>ruby dk.rb install
[INFO] Updating convenience notice gem override for 'C:/Ruby200-x64'
[INFO] Installing 'C:/Ruby200-x64/lib/ruby/site_ruby/devkit.rb'
```

ここまでで Ruby のセットアップは完了。


2. Jekyll を導入する
====================

コマンドプロンプトから `gem install jekyll` を実行する。

次の gem が導入される。

  * classifier-1.3.3
  * colorator-0.1
  * commander-4.1.5
  * fast-stemmer-1.0.2
  * ffi-1.9.3-x64-mingw32
  * highline-1.6.20
  * **jekyll-1.3.0**
  * liquid-2.5.4
  * listen-1.3.1
  * maruku-0.6.1
  * posix-spawn-0.3.6
  * pygments.rb-0.5.4
  * rake-0.9.6
  * rb-fsevent-0.9.3
  * rb-inotify-0.9.2
  * rb-kqueue-0.2.0
  * rdoc-4.0.0
  * redcarpet-2.3.0
  * safe_yaml-0.9.7
  * syntax-1.0.0
  * test-unit-2.0.0.0
  * yajl-ruby-1.1.0


pygments.rb のダウングレード
----------------------------

悲しいことに、`pygments.rb` の 0.5.1 以降は Windows では動作しない。([pygments.rb #90](https://github.com/tmm1/pygments.rb/pull/90) で Pull Request が出ているが、執筆時点でマージされていない)

そのため、導入された `pygments.rb` をアンインストールして、0.5.0 を入れなおしておく。「Jekyll が依存してる」と文句いわれるけど、気にせずに作業しちゃう。

```
> gem uninstall pygments.rb --version ">0.5.0"
> gem install pygments.rb --version "=0.5.0"
```

UTF-8 対策
----------

HTML や記事に日本語が含まれると、Jekyll の実行時に次のようなエラーが出る。

```
Liquid Exception: invalid byte sequence in Windows-31J in post.md/#excerpt
error: invalid byte sequence in Windows-31J. Use --trace to view backtrace
```

Windows Ruby にありがちな FAQ で、ググると色々出てくる。

`set LANG=ja_JP.UTF-8` するとよい、と書いてある記事もあったが Ruby 2.0 では効かないらしい。

Ruby 2.0 では環境変数の `RUBYOPT` を `-EUTF-8` にしておけば解決した (参考: [WindowsでEncoding.default_externalをUTF-8にするには - すがブロ](http://sugamasao.hatenablog.com/entry/2013/08/24/224521))。

環境変数をいじるのが面倒なら、`C:\Ruby200-x64\bin\jekyll.bat` の 2 行目あたりに `set RUBYOPT=-EUTF-8` と書いてもいい。

もしくは、`C:\Ruby200-x64\lib\ruby\gems\2.0.0\gems\jekyll-1.3.0\bin\jekyll` の冒頭 2 行目に

```ruby
Encoding.default_external = "utf-8"
```

を追加して回避してもよいだろう。(改行コードが LF のみなので、メモ帳では追加できない点に注意)


3. Pygments を導入する
======================

コードのハイライトを行うためには Pygments を導入する。

Python 2.7
----------

[Download Python](http://www.python.org/download/) から 2.7 をダウンロードする。今回導入したのは Python 2.7.6 Windows X86-64 Installer (`python-2.7.6.amd64.msi`)。

インストーラーを実行してデフォルトの設定でインストールする。インストール先は `C:\Python27` となる。

環境変数の `PATH` に `C:\Python27` と `C:\Python27\Scripts` を追加しておく (`Scripts` フォルダーはこのあと自動で作成される)。


easy_install
------------

次に、[setuptools](https://pypi.python.org/pypi/setuptools#windows) から [`ez_setup.py`](https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py) をダウンロードする。

`ez_setup.py` を実行する。

```
> python easy_install.py
   :
Installing easy_install-script.py script to C:\Python27\Scripts
Installing easy_install.exe script to C:\Python27\Scripts
Installing easy_install-2.7-script.py script to C:\Python27\Scripts
Installing easy_install-2.7.exe script to C:\Python27\Scripts

Installed c:\python27\lib\site-packages\setuptools-1.3.2-py2.7.egg
Processing dependencies for setuptools==1.3.2
Finished processing dependencies for setuptools==1.3.2
```

Pygments
--------

いよいよ Pygments をインストール！

`easy_install pygments` を実行すればよい。

```
> easy_install pygments
   :
Adding Pygments 1.6 to easy-install.pth file
Installing pygmentize-script.py script to C:\Python27\Scripts
Installing pygmentize.exe script to C:\Python27\Scripts

Installed c:\python27\lib\site-packages\pygments-1.6-py2.7.egg
Processing dependencies for pygments
Finished processing dependencies for pygments
```


4. Jekyll が動くか確認する！
===========================

ここまでくれば導入は完了したはず。動作するかテストしてみよう。

```
>jekyll new jekyll-test
New jekyll site installed in path/to/jekyll-test.

>cd jekyll-test

>jekyll serve
Configuration file: path/to/test-site/_config.yml
            Source: path/to/test-site
       Destination: path/to/test-site/_site
      Generating... done.
    Server address: http://0.0.0.0:4000
  Server running... press ctrl-c to stop.
```

http://localhost:4000/ を開いて結果が出力されていれば成功。

お疲れ様。


[Jekyll]: http://jekyllrb.com/
