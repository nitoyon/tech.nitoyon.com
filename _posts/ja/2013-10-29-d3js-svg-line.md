---
layout: post
title: D3.js の d3.svg.line() を試してみた
tags: JavaScript
lang: ja
thumbnail: http://farm4.staticflickr.com/3767/10434503954_f41fb09ca6_o.jpg
seealso:
- 2013-10-24-d3js
- 2013-06-27-node-yield
- 2013-02-15-viewport
- 2010-01-26-dijkstra-aster-visualize
- 2009-04-09-kmeans-visualise
---
１つ前の記事 {% post_link 2013-10-24-d3js %} のサンプルコードではシンプルにするために、座標計算の処理を泥臭く書いていた。

たとえば

```javascript
  circles.enter()
    .attr('cx', function(d, i) { return i * 280 / n + 10; })
```
のような座標を計算する関数が何箇所かに散らばっていた。

これ、`d3.svg.line()` を使ったらまとめられるし、便利な `interpolate` の機能も使えるよ、というのが今回のお話。

d3.svg.line() の使い方
======================

たとえば

```javascript
var line = d3.svg.line()
  .x(function(d, i) { return i; })
  .y(function(d, i) { return d * d; });
```

としておくことにする。`line.x()` とすると `function(d, i) { return i; }` を返してくれるので、関数を再利用してコードが読みやすくなる。`line.y()` も同様。

さらに、`line([5,2,4])` のようにして配列を渡すと `"M0,25L1,4L2,16"` を返す。これは `(1, 5*5)`、`(2, 2*2)`, `(3, 4*4)` を結んだ線を表す SVG である。

ま、これだけならちょっと便利かなぁ、というぐらいだけども、`line.interpolate("cardinal")` を実行しておくと、`line([5,2,4])` は `"M0,25Q0.7999999999999999,4.9,1,4Q1.2,3.1,2,16"` を返す。

これは、座標を曲線で結んだ SVG をあらわす。うまいこと計算してくれている。


今回のサンプル
==============

というわけで、前回のサンプルを少し改善しつつ、各種の `interpolate` を試せるようにしたものを置いておく。

<div>
<svg id="sample" width="300" height="300"
  style="background: white; border: .3em solid #ccc;"></svg>
</div>
<script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
<button onclick="random()">random</button>
<button onclick="push()">push</button>
<button onclick="pop()">pop</button>
<select id="line-interpolate">
  <option>linear</option>
  <option>linear-closed</option>
  <option>step</option>
  <option>step-before</option>
  <option>step-after</option>
  <option>basis</option>
  <option>basis-open</option>
  <option>basis-closed</option>
  <option>bundle</option>
  <option selected>cardinal</option>
  <option>cardinal-open</option>
  <option>cardinal-closed</option>
  <option>monotone</option>
</select>
<script src="d3js-svg-line.js" charset="utf-8"></script>

使い方
------

* 初期状態では 10 個の要素を持った配列を表示している。
* 横軸が配列のインデックス、縦軸が要素の値 (0～1) をあらわす。
* [random] ボタンを押すと、配列の中身がランダムな値で置き換わる。
* [push] ボタンを押すと、配列の末尾に要素を追加する。
* [pop] ボタンを押すと、配列の末尾から要素を取り除く。
* 選択欄で `interpolate` の値を変更できる。

ボタンを押すと、アニメーションつきで見た目が変更するのを確認していただけるだろうか (SVG をサポートしてる必要があるので、モダンではないブラウザーでは表示できない)。


HTML のソース
-------------

```html
<div>
<svg id="sample" width="300" height="300"
  style="background: white; border: .3em solid #ccc;"></svg>
</div>
<script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
<button onclick="random()">random</button>
<button onclick="push()">push</button>
<button onclick="pop()">pop</button>
<select id="line-interpolate">
  <option>linear</option>
  <option>linear-closed</option>
  <option>step</option>
  <option>step-before</option>
  <option>step-after</option>
  <option>basis</option>
  <option>basis-open</option>
  <option>basis-closed</option>
  <option>bundle</option>
  <option>cardinal</option>
  <option>cardinal-open</option>
  <option>cardinal-closed</option>
  <option>monotone</option>
</select>
<script src="d3js-svg-line.js" charset="utf-8"></script>

```

d3js-svg-line.js のソース
-------------------------

```javascript
var svg = d3.select("svg#sample")
  .attr('width', 300).attr('height', 300)
  .style('display', 'block');
var polyline = svg.append('path')
  .attr('stroke', 'red')
  .attr('stroke-width', '1')
  .attr('fill', 'transparent');

var values = [];
for (var i = 0; i < 10; i++) {
  values.push(Math.random());
}
d3.select('#line-interpolate').on('change', update);

function update() {
  var n = values.length;

  var s = d3.select('#line-interpolate')[0][0];
  var interpolate = s.options[s.selectedIndex].value;

  var line = d3.svg.line()
    .x(function(d, i) { return (i + 1) * 300 / (n + 1); })
    .y(function(d, i) { return d * 280 + 10; })
    .interpolate(interpolate);

  var circles = svg.selectAll('circle').data(values);
  circles.enter()
    .append('circle')
    .attr('cx', line.x()).attr('cy', 0).attr('r', 0);
  circles.exit()
    .transition()
    .duration(300)
    .attr('cy', 0).attr('r', 0)
    .remove();
  circles
    .attr('fill', 'red')
    .transition()
    .duration(300)
    .attr('cx', line.x())
    .attr('cy', line.y())
    .attr('r', 6);
  polyline
    .transition()
    .duration(300)
    .attr('d', line(values));
}

function random() {
  var n = values.length;
  for (var i = 0; i < n; i++) {
    values[i] = Math.random();
  }
  update();
}

function push() {
  values.push(Math.random());
  update();
}

function pop() {
  values.pop();
  update();
}

update();
```
