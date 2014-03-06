---
layout: post
title: ConEmu 突っ込んだら Git for Windows の Git Bash がカッコよくなった
tags: Windows Git
lang: ja
thumbnail: http://farm8.staticflickr.com/7428/12971385585_16c5ed8db4_o.png
seealso:
- ja/2013-07-23-git-patch
- ja/2013-07-02-git-dir-diff
- ja/2013-03-29-git-new-workdir
- ja/2013-01-11-github-clone-http
- ja/2012-04-12-msysgit-utf8-2
---
Git for Windows の Git Bash の配色がイマイチだなーと思ってググってたら、[Console2] だとか [ConEmu] を使うと楽にできるっぽいことが、Stack Overflow とか英語のブログで見つかった。

そこで、[ConEmu] を試してみたら色々と幸せになった ([Console2] はそのままでは日本語が使えなかった。解決方法はあるらしいけど…)。

左が Git Bash、右が ConEmu さん。

{% image http://farm8.staticflickr.com/7428/12971385585_16c5ed8db4_o.png, 600, 503 %}

アンチエイリアス効いてるし、色もオサレ。


起動から色を設定するまで
========================

[ConEmu] を起動すると、初回は設定の保存場所などを確認される。お好みで答えて [OK] を押すと、タブ化した MS-DOS プロンプトみたいなのが立ち上がってくる。

[Win] + [N] を押すと新しいタブを開始できる。

{% image http://farm3.staticflickr.com/2146/12971527963_69fbb4b171.jpg, 656, 478 %}

上のキャプチャーのように、どんな環境のタブを開始するかをメニューで聞いてきている (`{cmd}` やら `{cmd (Admin)}` やら `{PowerShell}` やら `{Git bash}` やら `{Putty}` やら…。システムにインストールされてるものを自動で検知して、立ち上げられるようになっているようだ)。

`{Git Bash}` を選ぶと、Git Bash が新しいタブに出てくる。

この時点ではデフォルトの配色なんだけど、タブの部分を右クリックしたら、いろんなカラースキーマを試せるようになっているのが手軽だ。

{% image http://farm3.staticflickr.com/2416/12971385475_b32ca52128.jpg, 681, 674 %}

`<Terminal.app>` (MacOS 風) とか、`<xterm>` (X Window) とかあるけど、世間的には `Solarized` が人気っぽいので、`<Solarized (Luke Maciak)>` を選んだ。

色が気に入ったら、全体設定の [Features] > [Colors] からデフォルトのカラースキーマを選んでおくと、次回からはその色で表示してくれるようになる。


多すぎる設定項目
================

設定パネルをみたら、気力を失うぐらいの設定項目がある。

{% image http://farm8.staticflickr.com/7364/12971527793_387e9b4495.jpg, 644, 476 %}

ショートカットキーにからしか使えない機能も多数あるようで、上下左右分割とかもできるっぽい。プラグインとかマクロとかもあるご様子…。

とりあえずは、タブの使い勝手が気になったので、[Features] > [Tabs] から [Lazy tab switch] と [Recent mode] をオフにしておいた。

あと、ちょっとキーコンフィグをいじって、標準的な Windows っぽいやつに置き換えてみたりした。


エディター起動中の Duplicate root が便利
========================================

ちょっと使っていて便利だなー、と思ったのは、タブの右クリック メニューにある [Duplicate root...]。カレントディレクトリをそのまま引き継いで、新しいタブで Git Bash を起動してくれる。

何がうれしいかというと、コミットとか `rebase -i` でエディターが立ち上がっているときに、log とか diff とか見たくなることはそれなりにあると思う。こんなときにも、[Duplicate root...] して、新しい GitBash 上で確認できる。いままでは、別の Git Bash を立ち上げるとか、一時的なコミットログを書くとかしてたので、便利になった。


まとめ
======

* ConEmu 便利だよ。
* タブ化して、色とかフォントがキレイになるだけでもメリットある。
* 他にも便利な機能はいっぱいありそう。


[Console2]: http://sourceforge.net/projects/console/
[ConEmu]: https://code.google.com/p/conemu-maximus5/