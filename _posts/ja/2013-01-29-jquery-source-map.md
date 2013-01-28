---
layout: post
title: jQuery 1.9 のソースマップ対応で圧縮版でもデバッグが簡単になった話
tags: jQuery
lang: ja
seealso:
  - 2008-12-11-jquery-fast-css
  - 2011-03-24-jQuery-extend-mania
  - 2008-11-21-jquery-array
  - 2008-01-15-jquery-event
---
jQuery 1.9 がリリースされました。1.9 の新機能の中ではあまり注目されていませんが、**ソースマップに対応**したのが地味に便利そうです。

というのも、圧縮版の jquery.min.js を使っていると

  * 何か問題が起きたときにスタックトレースを眺めても jQuery の部分が意味不明
  * デバッガーで jQuery のソースにステップインしても意味不明

といった理由で、開発中には非圧縮の jquery.js を使うことが多かったわけです。

それが、1.9 からはソースマップに対応したので**圧縮版のままでのデバッグが簡単**になってます。


超簡単な使い方
==============

ソースマップに対応したブラウザーは現時点では Google Chrome のみなので、Google Chrome の手順を説明します。

(Firefox はソースマップへの対応を[計画中](https://bugzilla.mozilla.org/show_bug.cgi?id=771597)らしい)


事前準備を忘れずに
------------------

Google Chrome で [デベロッパー ツール] を開きます。

{% image http://farm9.staticflickr.com/8466/8423335379_7fdbcbf661.jpg, 627, 569 %}

右下の設定ボタンを押して、[Enable source maps] をチェックします。

下準備はこれだけ。簡単ですね！


早速使ってみよう
----------------

本家の [jquery.com](http://jquery.com/) は早速 1.9.0 の圧縮版を使っていました。ということで、ここで実験してみます。

まず、http://jquery.com/ に行って、[デベロッパー ツール] を開いてみます。

 [Sources] タブから `main.js` を選択して、最初の `on()` 関数のコールバックにブレークポイントを仕込んでみます。

{% image http://farm9.staticflickr.com/8225/8423335179_d4bc25f945.jpg, 727, 382 %}

サイトの下のほうにある「CDN」の右側が `.cdn input` なので、ここをクリックすると…

{% image http://farm9.staticflickr.com/8368/8423335345_e11a941f99.jpg, 734, 352 %}

はい、ブレークしますね。ここで注目すべきは右側の [Call Stack]。よく見ると…

  * (anonymous function) main.js:7
  * st.event.dispatch jquery.js:3045
  * st.event.add.y.handle jquery.js:2721

jQuery の関数名と、行数が書いてありますね。**jquery.min.js しかロードしてないページなのに、jquery.js の情報が表示**されています！

ためしに `st.event.dispatch jquery.js:3045` をダブルクリックすると…

{% image http://farm9.staticflickr.com/8469/8423335301_af26ed3b0e.jpg, 730, 375 %}

jquery.js がロードされて、該当する場所を表示できました。圧縮前の jquery.js なので、当然、コメントも残っています。

これはすごい！

jQuery 1.9 では jquery.min.js を利用しててもデバッグでは困らないのです。

ところで、これ、どういう仕組みで動いてるか気になりませんか？　気になる人は続きをお読みください。


ソースマップとは何ぞや
======================

jQuery 1.9 からの jquery.min.js には、最後の行に次のようなコメントがあります。

```javascript
/*! jQuery v1.9.0 (省略) */(function(e,t){/* 省略 */})(window);
//@ sourceMappingURL=jquery.min.map
```

`@ sourceMappingURL=jquery.min.map` に注目。ソースマップの URL が書いてあります。Google Chrome はこの部分を見て、ソースマップを読み込んでいたわけですね。

となると、気になるのが `jquery.min.map` の中身。Google CDN には jquery.min.js と同じディレクトリーに <a href="http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.map">`jquery.min.map`</a> が設置してあります。

整形して表示してみるとこうなります。

```javascript
{
    "version": 3,
    "file": "jquery.min.js",
    "sources": ["jquery.js"],
    "names": ["window","undefined","isArraylike", /* 省略 */],
    "mappings": "CAaA,SAAWA,EAAQC,GACnB,(省略)"
}
```

`jquery.js` と書いてありますね。これを見て Google Chrome は `jquery.js` に行き着いたようです。`sources` が複数指定できることから、ソースマップは、複数のソースを結合して圧縮した場合にも対応できそうなフォーマットだと推測できます。

問題は `mappings` なのですが、これは「圧縮後の○列目の文字は、ソース△△の××行目の××列目にありますよ」という情報を BASE64 VLQ で圧縮したものだそうです。

詳しくは [Introduction to JavaScript Source Maps - HTML5 Rocks](http://www.html5rocks.com/en/tutorials/developertools/sourcemaps/) に書いてあるので、さらに興味がある人は参照してみてください。


CDN を使わない場合
==================

いい忘れていましたが、Google CDN を使わないで自分のサーバーで jquery.min.js をホスティングする場合は、少し追加の手順が必要になります。

jquery.min.js をアップロードする場所に jquery.min.map と jquery.js を置くだけです。簡単ですね。

`jquery.min.map` は jquery の公式サイトでは公開されてないけど、

  * http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.map

に置いてあるので、1.9.0 以降のバージョンがリリースされても URL の 1.9.0 の部分を置き換えれば取得できそうです。


ソースマップを活用しよう
========================

さて、便利便利なソースマップなので、自分のプロジェクトでも活用してみたいですよね。

ソースマップは JavaScript の圧縮はもちろん、**CoffeeScript/HaXe/TypeScript/JSX** などの JavaScript を生成する言語でも出力できるようです。

さらに、CSS 生成で有名な **SASS/LESS** でも活用できるようです。

夢が広がったので、ソースマップの出力方法を調べてみました。


JavaScript の圧縮
-----------------

jQuery が利用している圧縮ツールは [UglifyJS](https://github.com/mishoo/UglifyJS2) です。コマンドライン引数に `--source-map` を指定すると、ソースマップを吐けるようです。

もう１つの主流な圧縮ツール [Closure compiler](https://developers.google.com/closure/compiler/) では `--create_source_map ./foo.min.map --source_map_format=V3` と指定する模様。


JavaScript を生成する色々
-------------------------

ぐぐって調べて引っかかった結果をまとめておく。

  * CoffeeScript: `coffee` コマンドに `--source-map` をつけるだけ。
  * HaXe: `haxe` コマンドに `--debug` をつけるだけ。
  * TypeScript: `tcs` コマンドに `-sourcemap` をつけるだけ。
  * JSX: `--enable-source-map` らしい。


SASS/LESS
---------

JavaScript よりも、もう少し複雑そう。詳しくはリンク先を。

  * SASS: [Bricss - Using Sass source maps in WebKit Inspector](http://bricss.net/post/33788072565/using-sass-source-maps-in-webkit-inspector)
  * LESS: [Debug LESS with Chrome Developer Tools - Rob Dodson talks internets](http://robdodson.me/blog/2012/12/28/debug-less-with-chrome-developer-tools/)

リンク先を見る限り、`@media -sass-debug-info` という独自の情報を出力して、それを Google Chrome 側で解釈する模様。


まとめ
======

ソースマップがあれば、圧縮したソースでの開発も怖くない！　え？　Google Chrome 以外のブラウザーで困ったら？　そのときは今まで通り・・・。
