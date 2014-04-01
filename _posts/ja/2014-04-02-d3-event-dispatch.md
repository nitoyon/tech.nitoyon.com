---
layout: post
title: D3.js で自作クラスにイベント発行機能を追加する
tags: JavaScript
lang: ja
thumbnail: http://farm4.staticflickr.com/3767/10434503954_f41fb09ca6_o.jpg
seealso:
- ja/2013-11-07-k-means
- 2013-10-29-d3js-svg-line
- 2013-10-24-d3js
- 2013-06-27-node-yield
- 2013-02-15-viewport
---
D3.js を使っていると、自作クラスのイベント発行も D3.js を使いたくなる。そんなときには [`d3.dispatch`](https://github.com/mbostock/d3/wiki/Internals#d3_dispatch) を使うとよい。


使う側の実装
============

イメージしやすいように、最初に使う側のコードを示しておく。

```javascript
var myButton = new MyButton(d3.select("button"));
myButton.on("myclick", function(e) {
  alert(e.name); // MyEvent
  console.log(this, e); // MyButton, { name: "MyEvent", MouseEvent }
});
```

こんな感じで、自作の `MyButton` クラスで `myclick` イベントを発行したい。


MyButton の実装
===============

では、さっそく `MyButton` の実装。最初はコンストラクターから。

```javascript
function MyButton(selector) {
  // ボタンがクリックされたときに onClick を呼ぶ
  selector.on('click', this.onClick.bind(this));

  // myclick イベントを発行する dispatcher を作成
  this.dispatcher = d3.dispatch("myclick");
}
```

`d3.dispatch` の引数に「発行したいイベント名」を渡して、dispatcher オブジェクトを取得している。複数のイベントを出す場合は `d3.dispatch("event1", "event2");` のようにする。

dispatcher オブジェクトには次の 2 種類のメソッドが定義される。

  * イベントを発行するためのメソッド (イベント名と同じ名前)
  * イベントを監視するための `on(type, listener)`


イベント発行処理
----------------

イベントの発行処理からみていこう。

```javascript
MyButton.prototype.onClick = function() {
  this.dispatcher.myclick.call(this, {
    name: "MyEvent",
    event: d3.event
  });
};
```

ボタンがクリックされたときに `myclick` イベントを発行している。今回は `myclick` イベントと名付けたので、`dispatcher.myclick()` を実行すれば、`myclick` イベントが発火する。引数はそのままリスナーに渡される。

`Function.call()` を使っているのは、リスナー側で `this` が `dispatcher` ではなく `MyButton` にしたいから。


on の実装
---------

次に `MyButton.prototype.on()` の実装。こちらは、単純に `dispatcher.on()` に中継している。

```javascript
MyButton.prototype.on = function() {
  return this.dispatcher.on.apply(this.dispatcher, arguments);
};
```

単純に中継しているだけなので、もっと簡略化して書けそうである。そう、[`d3.rebind`](https://github.com/mbostock/d3/wiki/Internals#d3_rebind) を使えばね。

```javascript
function MyButton(selector) {
  selector.on('click', this.onClick.bind(this));
  this.dispatcher = d3.dispatch("myclick");

  // !!! ここが追加 !!!
  d3.rebind(this, this.dispatcher, "on");
}
```

コンストラクターに 1 行追加したおかげで、`MyButton.prototype.on()` が不要になった。コードは短くなったが、`d3.rebind()` の学習コストが増えたので微妙なところではある。

ちなみに、`d3.rebind()` は 11 行の短い関数。上で手で書いたのとだいたい同じ動作になるのが分かるはず。

```javascript
d3.rebind = function(target, source) {
  var i = 1, n = arguments.length, method;
  while (++i < n) target[method = arguments[i]] = d3_rebind(target, source, source[method]);
  return target;
};
function d3_rebind(target, source, method) {
  return function() {
    var value = method.apply(source, arguments);
    return value === source ? target : value;
  };
}
```

これで目的は完遂。めでたし。

完成後の全体のソースコードを貼っておく。

```html
<!DOCTYPE html>
<meta charset="utf-8">
<script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
<body>
<button>click me</button>

<script>
function MyButton(selector) {
  selector.on('click', this.onClick.bind(this));
  this.dispatcher = d3.dispatch("myclick");
  d3.rebind(this, this.dispatcher, "on");
}

MyButton.prototype.onClick = function() {
  this.dispatcher.myclick.call(this, {
    name: "MyEvent",
    event: d3.event
  });
};

var myButton = new MyButton(d3.select("button"));
myButton.on("myclick", function(e) {
  alert(e.name); // MyEvent
  console.log(this, e); // MyButton, { name: "MyEvent", MouseEvent }
});
</script>
</body>
```



複数イベント登録の罠
====================

D3.js のイベントで厄介な点は、1 つのイベント名に複数のイベントを登録できないところ。新しいイベントを登録したら、古いほうは消される…。DOM イベントと同じ感覚でいると混乱してしまう。

これを回避するには `myclick.foo` や `myclick.bar` のように optional namespace をつけてイベント登録する必要がある。くわしくは [`selection.on`](https://github.com/mbostock/d3/wiki/Selections#on) を参照あれ。
