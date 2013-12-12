---
layout: post
title: タッチ操作に対応した画像ビューワーをJavaScriptで作るならD3.jsが便利
lang: ja
tags: JavaScript iPhone
seealso:
- 2013-10-24-d3js
- 2009-04-09-kmeans-visualise
- 2013-10-29-d3js-svg-line
- 2013-02-15-viewport
- 2013-04-23-chrome-responsive-debug
- 2010-01-26-dijkstra-aster-visualize
---
スマホやタブレットで写真を表示していると、ピンチでズームしたり、ドラッグで移動したりができて便利なので、あれを Web 上で実現してみたくなった。

最近のブラウザーでは `touchstart` や `touchmove` イベントでタッチ情報を取れたり、イベントの `touches` でマルチタッチを扱えたりするので、実現するための基盤はそろっている。

適当なライブラリーがあるかと思って探してみたが、意外と苦労してしまった。


Hammer.js が使えない
====================

タッチを扱うためのライブラリーとしては [Hammer.js](http://eightmedia.github.io/hammer.js/) がメジャーらしい。スワイプ・ピンチ・ドラッグなど、各種イベントにも対応していて、これを使えば一発解決してくれそうだ。

ところが、画像ビューワーを作るには不向きだった。困ったのは次の 2 点。

  * ピンチやドラッグは個別には動くが、組み合わせたときに「表示位置」と「倍率」の関係を自前で計算する必要がある
  * 人差し指でドラッグしながら親指を追加してピンチすると、ピンチイベントは来るもののスケールがいい加減 (ドラッグ開始位置を基準に算出している気配)

いちおう公式のサンプルに [pinchzoom.html](http://eightmedia.github.io/hammer.js/examples/pinchzoom.html) というものはあるんだけど、動かしてみると分かる通り、毎回、移動の初期位置は初期化される。

コードも読んでみたが、複雑なものを作るには少し不向きである予感がした。


D3.js の d3.behavior.zoom で万事解決！
======================================

自前で実装するにしても難しそうだし、しばらく途方に暮れていたのだけど、[D3.js] の [Zoomable Geography](http://bl.ocks.org/mbostock/2374239) のサンプルを見たら、見事に希望の動作を実現していた。

ドラッグ中にピンチしてもきれいに動いている。マウスのドラッグやホイールにも対応してたり、ダブルクリック・ダブルタップでの拡大もしてくれる。Nexus 7 と Windows 8 + Google Chrome で動作することを確認した。すばらしい。

しかもサンプルのコードが超絶短い。どうやら、D3.js の [`d3.behavior.zoom()`](https://github.com/mbostock/d3/wiki/Zoom-Behavior) がタッチ操作を全部面倒みてくれるようだ。


画像ファイルでやってみた
------------------------

そこで、試しに自分も作ってみた。本家のサンプルは SVG だけども、こっちのサンプルは単なる画像を CSS3 の 2D Transform で動かしている。

<iframe src="zoom_test.html" style="border: .2em solid #999" width="100%" height="300"></iframe>

↑をピンチで拡大縮小、ドラッグで移動できるよ。


まとめ
======

[D3.js] がタッチ操作に対応してるのは、たぶんビジュアライズ結果を拡大・移動したいからだろう。他にも同じようなことを実現するライブラリーはありそうなのだが、意外と見つからなかったので記事にしておく。

D3.js については {% post_link 2013-10-24-d3js %} もご覧あれ。そうそう、このエントリーは [d3.js Advent Calendar](http://www.adventar.org/calendars/117) の 13 日目の記事だったりもする。

ソースは以下に (40行)。2D Transform では `transform-origin` の設定が必要なところで少しはまった。

```html
<!DOCTYPE html>
<meta charset="utf-8">
<style>
html,body {
	margin: 0;
	width: 100%;
	height: 100%;
	overflow: hidden;
	background: white;
}
</style>
<body>
<script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
<script>
var zoom = d3.behavior.zoom()
	.scale(1)
	.scaleExtent([.1, 10])
	.on("zoom", zoomed);

var svg = d3.select("body")
	.call(zoom);

function zoomed() {
	var t = "translate(" + d3.event.translate[0] + 'px,' + d3.event.translate[1] +"px) " +
		"scale(" + d3.event.scale + ',' + d3.event.scale + ")";
	d3.select("img")
		.style("transform-origin", "0 0")
		.style("-moz-transform-origin", "0 0")
		.style("-webkit-transform-origin", "0 0")
		.style("-o-transform-origin", "0 0")
		.style("-ms-transform-origin", "0 0")
		.style("transform", t)
		.style("-moz-transform", t)
		.style("-webkit-transform", t)
		.style("-o-transform", t)
		.style("-ms-transform", t);
}
</script>
<img src="/images/logo-blog.png">
</body>
```

[D3.js]: http://d3js.org/