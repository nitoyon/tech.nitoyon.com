---
layout: post
title: "-webkit-text-size-adjust: none を絶対に設定してはいけない理由"
tags: CSS
lang: ja
thumbnail: http://farm9.staticflickr.com/8515/8467619207_9625a87b57_o.jpg
seealso:
  - 2012-03-13-newdesign2012
  - 2008-12-11-jquery-fast-css
  - 2009-02-26-hatebu2-css
  - 2007-01-25-p1
---
PC 版の Google Chrome や Safari で見たときにユーザビリティーが落ちるから。

以上。


で終わってしまうと記事にならないので、ちゃんと説明しておく。


そもそも -webkit-text-size-adjust とは何か
==========================================

iPhone や Android のブラウザーは、縦向き (Portrate mode) と横向き (Landscape mode) の文字サイズを自動調整する機能がある。

これを制御するのが CSS の `-webkit-text-size-adjust` である。


文字サイズ自動調整の具体例
--------------------------

次のような HTML をスマートフォンで表示してみる。

```html
<!DOCTYPE html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=0">
</head>
<body background="layout_grid.png">
<img src="/images/logo-ja.png">
<p>色んな素材がごった煮になった様子をお椀で表現しています。
湯気が<strong>「てっく」</strong>に見えるのが隠し味になっています。
「てっく煮」の右肩の「+4」 を「と、よん」と読むことで、
ドメイン名の tech.nitoyon.com と等しくなります。</p>
</body>
```

スマホ対応であることを主張するために viewport のおまじないを `<meta>` タグに書いている。それ以外はありきたりな単純な HTMLである。

このページを iPhone 3GS (iOS 5.1.1) で表示するとこうなった ([デモ ページ](./adjust.html))。

{% image http://farm9.staticflickr.com/8088/8467618983_5e6b9d2307.jpg, 900, 550 %}

横向きにしたときに画像のサイズはそのままで、**文字のサイズだけが大きくなっている**。

おそらく 1 行あたりの文字数が増えすぎると読みにくくなるから、という配慮なんだろうけど、余計なお世話なのでオフにしたくなる。


自動調整をオフにしたい
----------------------

この自動調整をしているのが `-webkit-text-size-adjust` プロパティー。

デフォルト値は `auto` になっていて、`100%` や `none` にすると自動調整をオフにできる。

```css
body {
  -webkit-text-size-adjust: 100%;
}
```

さきほどの例でも、文字のサイズが変わらなくなった ([デモ ページ](./no-adjust.html))。

{% image http://farm9.staticflickr.com/8515/8471101882_a792b39c70.jpg, 900, 550 %}


none を設定してはいけない
-------------------------

ここで重要なのが、`-webkit-text-size-adjust` は **`none` に設定すると副作用があるので `100%` を設定すべき**という点だ。

検索してみると層々たるサイトで「`none` に設定しましょう」という記述があるんだけど、危険なので注意が必要だ。

危険な情報を載せているサイトの一例:

  * [[CSS]スマフォ対応サイトのためにMedia Queriesをしっかり身につけるチュートリアル | コリス](http://coliss.com/articles/build-websites/operation/css/css-tutorial-media-queries-by-webdesignerwall.html)
  * [iPhone向けWebアプリを作ろう（4/4） － ＠IT](http://www.atmarkit.co.jp/fsmart/articles/iphone/04.html)
  * [-webkit-text-size-adjust｜プロパティ｜CSS HappyLife ZERO](http://zero.css-happylife.com/property/-webkit-text-size-adjust.shtml)
  * [CSS3 Media Queries を使って、Webサイトをスマートフォンに対応させるときの注意書き - Webデザインレシピ](http://webdesignrecipes.com/web-design-for-mobile-with-css3-media-queries/)


none が絶対にダメな理由
=======================

`-webkit-text-size-adjust: none` を指定してしまうと PC 版の Google Chrome や Safari でページの拡大/縮小機能に支障がでる。

たとえば、[ITmedia](http://www.itmedia.co.jp/) には `none` が指定されてしまっているので悪い例として取り上げさせてもらう。Google Chrome (バージョン 24) にて 100% と 200% で ITmedia のトップページを表示するとこうなる。

{% image http://farm9.staticflickr.com/8515/8467619207_37643f6d2a.jpg, 788, 480 %}

画像や文字の位置は拡大されているのに**文字が拡大されていない**。目が悪い人や高解像度ディスプレイを使っている人にとっては、読みやすくするために拡大しても文字が小さいままなので、たいそう不便である。

ためしに、Google Chrome の開発者コンソールで `<body>` タグの `-webkit-text-size-adjust` プロパティーを `none` から `100%` に書き換えてみると、期待した通りの表示になる。

{% image http://farm9.staticflickr.com/8515/8468714646_3fc95ee0ff.jpg, 788, 480 %}

これが、`none` がダメで、`100%` を推奨している理由である。

昨今のレスポンシブ Web デザインの流行もあり、PC 向けサイトに `-webkit-text-size-adjust` が指定されることも増えてきた。もし、`none` を指定しちゃうと、目が悪い人や高解像度ディスプレイを使っている人がページを拡大できなくなっちゃう。これは重大なアクセシビリティーの欠陥である。


none で拡大されないのは WebKit のバグ
-------------------------------------

Mozilla の資料 [text-size-adjust - CSS | MDN](https://developer.mozilla.org/en-US/docs/CSS/text-size-adjust) には、この挙動は WebKit のバグだと書いてある (日本語訳は私によるもの)。

> WebKit ベースの PC 版ブラウザーにはバグがある。`-webkit-text-size-adjust` に `none` を設定していると、PC 版の Chrome や Safari は、このプロパティーを無視すべきなのに、ページの拡大/縮小を妨害する動作をする。
>> There is a bug in Webkit-based desktop browsers. If `-webkit-text-size-adjust` is explicitely set to `none`, Webkit-based desktop browsers, like Chrome or Safari, instead of ignoring the property, will prevent the user to zoom in or out the Web page.

このバグは WebKit Bugzilla に [Bug 56543 - CSS property "-webkit-text-size-adjust" means different things in Safari and iOS](https://bugs.webkit.org/show_bug.cgi?id=56543) として バグ登録されている。パッチも提供されている。

しかし、現在のところ解決には至っていない。


このバグへの対処方法
====================

理想
----

WebKit のバグが修正されるのが一番いい。


現実
----

しかし、修正される気配はないし、たとえ修正されたとしても、一定期間は古いブラウザーを使う人がいる。

だから、繰り返しになるが、現時点では

```css
body {
  -webkit-text-size-adjust: none;
}
```

ではなく

```css
body {
  -webkit-text-size-adjust: 100%;
}
```

を設定すべきだ。

スマホ専用サイトであれば `-webkit-text-size-adjust: none` を設定しても困る人はいないのだけど、別の人がコピペで PC サイトに流用する可能性もあるだろうから、`-webkit-text-size-adjust: 100%` を習慣づけておいて損はないだろう。


利用者側の対策
--------------

さきほど、ITmedia の例を紹介したが、よく使うサイトでこの CSS が指定されていると不便だ。

たとえば、はてなブックマークの新しいトップページは、公開当初、`none` を指定していた。普段から拡大して表示していた自分は困ってしまったのだが、中の人が [タイムリーな記事](http://kudakurage.hatenadiary.com/entry/2013/02/08/135725) で `none` を推奨していたので、「`100%` にすべきだよ」とコメントしてみた。すると、数時間後には、はてなブックマークの CSS も治っていた。すばやい対応でありがたい。

とはいえ、サイトごとにいちいち連絡するのも面倒なので、ユーザースタイルシートを書くなり、対策用のブラウザー拡張を入れるなりするのが現実的だろう。自分の場合は Google Chrome に [Webkit-Text-Size-Adjust Remover](https://chrome.google.com/webstore/detail/webkit-text-size-adjust-r/jgfjnnljbpgajihjcajeiabjomhmjhec) を入れたら快適になった。ITmedia も快適に拡大できるようになった。


３行でまとめる
==============

長くなったが、強引に３行でまとめる。

  * WebKit はこのバグを治してほしい。
  * 対処療法にはなるけど `-webkit-text-size-adjust: none` はダメ。`100%` と書け。
  * バグを回避するための [Webkit-Text-Size-Adjust Remover](https://chrome.google.com/webstore/detail/webkit-text-size-adjust-r/jgfjnnljbpgajihjcajeiabjomhmjhec) のような拡張もあるので、拡大できないサイトがあって困ってるなら入れるとよい。
