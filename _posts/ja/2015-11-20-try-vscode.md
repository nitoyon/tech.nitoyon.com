---
layout: post
title: Visual Studio Code は JavaScript 開発が超絶便利になる可能性を秘めている！
tags: [JavaScript, Node.js] 
lang: ja
thumbnail: https://farm6.staticflickr.com/5728/22827535010_88b8d59654_o_d.png
seealso:
- ja/2015-11-18-death-of-oo
- ja/2014-07-18-data-binding
- ja/2014-06-30-vue-js-hook
- ja/2013-06-27-node-yield
- ja/2013-02-27-livereloadx
- ja/2013-02-19-node-source-map
---
期待のオープンソース IDE、[Visual Studio Code](https://code.visualstudio.com/) を試してみたら衝撃を受けた。

拡張を入れなくても、デフォルトで JavaScript の「自動 Lint」「Grunt、Gulp 連携」「デバッグ」が動いた。なんだかすごく便利そうな予感。

Windows 環境で起動してみたらこんな画面だった。

{% image https://farm6.staticflickr.com/5728/22827535010_6c3f9d80da_z_d.jpg, 640, 491 %}

なんか黒いが、色は好みにカスタマイズできるし、プリセットからも選べる。

フォルダーを開くことから始まる
==============================

Visual Studio Code にはプロジェクトの概念はない。

[File] > [Open Folder] からフォルダーを開けばよい。

ためしに、過去に作った Node.js 製の [livereloadx](https://github.com/nitoyon/livereloadx) のフォルダーを開いてみた。

{% image https://farm1.staticflickr.com/684/22525086774_635323dd04.jpg, 500, 372 %}

左側にツリーが表示されている。プロジェクト内のファイルを開くにはツリー上でクリックしてもいいし、`Ctrl+P` を押せば、ファイル名でインクリメンタル検索できる (上の図では `fi` と入力しているので、`filter.js` や `config.js` が引っかかってる)。

ファイル内の文字列で検索するには、左の虫眼鏡を押すか、`Ctrl+Shift+F` から。


自動 Lint
=========

左下の警告マークのところに 4 と出てるのでクリックしてみると、`Buffer` とか `__dirname` が見つからないといわれた。

{% image https://farm6.staticflickr.com/5661/22755770339_70279498fa.jpg, 439, 286 %}

警告をクリックして、電球マークをクリックすると、「`node.d.ts` をダウンロードする」というオプションがでてきた。

{% image https://farm6.staticflickr.com/5724/22729696698_2a9cd7fd7f.jpg, 419, 106 %}

`d.ts` は TypeScript の型定義ファイル。これの Node.js 用を自動的に落とせるようだ。

落とすと警告は減った。が・・・本当に対処したほうがいいやつが出てきた・・・。

{% image https://farm1.staticflickr.com/703/22827902400_6bcc58719d.jpg, 500, 231 %}


Git 連携！
==========

コードを修正すると、左側の Git マークのところに数字が！

Git マークを押すと、最後のコミットから変更されたファイルが出てくる。`git status` の GUI 版みたいな感じ。

{% image https://farm1.staticflickr.com/762/23159649771_89618bc4da.jpg, 500, 357 %}

ファイルを選択すると差分が分かるし、＋マークを押すと `git add` するし、矢印を押すと変更を破棄できる。上の部分にメッセージを書くとコミットできる。

Git フレンドリー！


Grunt, Gulp 連携
================

`Ctrl+Shift+T` を押すと、何も設定してないのに単体テストが走った!!

{% image https://farm6.staticflickr.com/5671/22729591857_d052424b76.jpg, 500, 391 %}

右側に単体テストの結果が表示されている。

理由は `Gruntfile.js` に `test` というタスクが登録してあるから。Visual Studio Code さんは、Grunt や Gulp、Jake のタスクを自動的に解釈してくれているのだ。

他にも `build` というタスクがあれば、`Ctrl+Shift+B` でビルドが走るらしい。カッコイイ。

もちろん、それ以外のタスクも開始できる。

`F1` から `Run Task` を入力すると、実行できるタスクの一覧が出てくる。ためしに、`watch` タスクを選択すると、IDE 内において「編集したら、Lint して単体テスト、結果を表示」というフローが実現できた。カッコイイ。

{% image https://farm1.staticflickr.com/741/22828175870_7aa3f707a3.jpg, 500, 391 %}

デバッグ!!!
===========

コードの適当なところに `F9` でブレークポイントを設定して、`F5` でデバッグを開始してみる。

{% image https://farm1.staticflickr.com/772/22827919780_706feaecf0.jpg, 458, 123 %}

「Node.js と Mono のどっちをデバッグする？」と聞かれた。[拡張](https://marketplace.visualstudio.com/vscode/Debuggers)を入れたら他の言語もデバッグできるらしい。

ここでは Node.js を選ぶ。

`.vscode/launch.json` が開くので、ここで何をデバッグするか設定する。

{% image https://farm1.staticflickr.com/581/22729605137_caeedb1cca.jpg, 500, 316 %}

`program` のところで開始する JS ファイルを指定してみた。

再度、F5 でデバッグを始める。

{% image https://farm1.staticflickr.com/768/23134119082_5caca8673f.jpg, 500, 357 %}

ブレークポイントで止まった。

左上の Variables にはローカル変数やクロージャー内の変数の値が出てくる。左下にはスタックトレースがある。

`F10` でステップオーバー、`F11` でステップイン、`Shift+F11` でステップアウトできるのは Visual Studio と同じ。


他にも機能はたくさん
====================

まだまだ確認しきれていないが、機能はたくさんあるようだ。

* TypeScript なら変数名の変更やシンボル名での検索にも対応してるらしい。
* コードスニペットは、特定の文字を入力して、Tab を押したら定型文を挿入してくれるので便利そう。
* CSS (Sass, Less) にも対応してる。Lint するし、`Ctrl+Shift+O` でシンボルに飛べる。
* この記事の Markdown を Visual Studio Code で書いているが、`Ctrl+V` でプレビューできる。

言語ごとに何ができるかは、[ドキュメント](https://code.visualstudio.com/docs/languages/overview) の LANGUAGES の中をみると一通り書いてある。

エディターとしての機能はまだ確認しきれていない。Windows なら日本語は問題なく通る。折り返しできない (?) のが、今この記事を書いていて不便に感じる。動作はサクサクしている。


雑感
====

ここまでの機能がデフォルトで有効になっている、というのはなかなかの衝撃であった。

ほめちぎりすぎたので、最後に悪いところも書いておく。

現状の Visual Studio Code は、メインメニューやコンテキストメニューが状況に応じて変化しない。便利な機能を使うためには、ショートカットキーを覚えるのが前提になっている。ドキュメントを読まないと何ができるのか見当つかないし、ショートカットを覚えるコストも高い。

[公式のドキュメント](https://code.visualstudio.com/docs/)はよくできているので、一通り読めば分かるんだけど、言語ごとに使える機能に違いがあるので、そのあたりもややこしい。
	
自分は Visual Studio を普段使いしてるので、慣れてるショートカットキーがそのまま使えて、手触りはとてもよかった。
