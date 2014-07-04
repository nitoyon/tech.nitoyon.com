---
layout: post
title: Vue.js が data に渡した値を激しく書き換える件について
tags: JavaScript
lang: ja
seealso:
- ja/2013-06-27-node-yield
- ja/2013-02-27-livereloadx
- ja/2013-02-19-node-source-map
- ja/2011-03-24-jQuery-extend-mania
- ja/2008-12-11-jquery-fast-css
thumbnail: https://farm3.staticflickr.com/2939/14348935187_2df7c5bf1c_o.png
---
最近、JavaScript の MV* フレームワークの中で [Vue.js] が少しずつ注目を浴びてきているようであります。

* [5分でわかるVue.jsと、jQueryで頑張ってはいけない理由 | 株式会社インフィニットループ技術ブログ](http://www.infiniteloop.co.jp/blog/2014/06/5min_vuejs/)
* [Vue.jsから手軽に始めるJavaScriptフレームワーク - Qiita](http://qiita.com/icoxfog417/items/49f7301be502bc2ad897)
* [軽量でパワフルなデータバインディングMVVM, vue.jsで遊んでみた - mizchi's blog](http://mizchi.hatenablog.com/entry/2014/02/13/153742)

そんなわけで、自分も Vue.js (v0.10.5) を触ってみたのですが、`data` で渡した値を激しく書き換えるところに面食らったので記事にしておきます。


自作クラスのオブジェクトを Vue.js に渡すと壊される
==================================================

何らかのビジネスロジックを持ったモデルを作って、それを Vue.js のデータバインディングで HTML に反映しようすると破綻します。

簡単な例として、よくある `Animal` クラスを作ったとしましょう。

```javascript
function Animal(name) {
  this.name = name;
};
Animal.prototype.say = function() {
  console.log(this.name);
};

var dog = new Animal('dog');
dog.bark(); // I'm a dog
```

まぁ、当然動きます。

では、`dog` をデータバインディングで HTML に表示してみます。

{%raw%}
```html
<body>
<p>{{animal.name}}</p>
<script src="vue.js"></script>
<script>
function Animal(name) {
  this.name = name;
};
Animal.prototype.bark = function() {
  console.log("I'm a " + this.name);
};

var dog = new Animal('dog');
dog.bark(); // I'm a dog

new Vue({
  el: "body",
  data: { animal: dog }
});
</script>
</body>
```

期待通り、`{{animal.name}}` の部分が `dog` になります。
{%endraw%}

JavaScript コンソールにて、`dog.name = "dog!!!"` とすると、HTML は `dog!!!` に書き換わります。ちゃんと動いてるようにみえますね。

しかし・・・JavaScript コンソールで `dog.bark()` と入力すると・・・。

{% image https://farm4.staticflickr.com/3912/14348658487_b188ef6abc_o.png, 477, 195 %}

さっきまで動いていたコードが動かなくなりました・・・。恐怖！


激しく書き換えられた犬と書き換えられる前の猫
--------------------------------------------

Vue.js では、data に渡した値を書き換えます。激しく書き換えます。

ためしに、dog を表示してみます。

{% image https://farm4.staticflickr.com/3901/14348658407_745e69d963_o.png, 411, 149 %}

ははは。プロトタイプ (`__proto__`) が別のオブジェクトになってしまっていますよ。`bark()` がなくてエラーになるのも無理はありません。

ちなみに、普通にインスタンス化した猫はこうなってますよ。当たり前だけども、`bark()` あります。

{% image https://farm4.staticflickr.com/3842/14533637664_2e67ac0ca8_o.png, 410, 104 %}

[Vue.js] さんは、`new Vue()` の `data` に渡した値を書き換えてしまうのです。恐ろしい子！


なぜにあなたは書き換える？
--------------------------

Vue.js は `data` に変更が加わったことを検知するために、data の値を書き換えているようです。

たとえば、`dog.name` というキーは ECMAScript 5 のプロパティーに置き換えられます。`get name` と `set name` が定義されてますね。

{% image https://farm4.staticflickr.com/3901/14348658407_745e69d963_o.png, 411, 149 %}

このようにすることで、`dog.name` が書き換えられた瞬間に `set name` が呼ばれるので、Vue.js はデータの書き換えを検知するわけでございます。

じゃ、なんで prototype まで置き換えるのか。

[Displaying a List - vue.js](http://vuejs.org/guide/list.html) によると、ECMAScript 5 ではキーの追加・削除は検知できないので、`$add` と `$delete` を使ってくれ、ということのようです (ざっくりと日本語訳してみた)。

> In ECMAScript 5 there is no way to detect when a new property is added to an Object, or when a property is deleted from an Object. To counter for that, observed objects will be augmented with two methods: $add(key, value) and $delete(key). These methods can be used to add / delete properties from observed objects while triggering the desired View updates.
>> ECMAScript 5 では、Object に対するプロパティーの追加や削除を検出する方法がないんだぜ。だから、監視対象の Object には $add(key, value) と $delete(key) の 2 つのメソッドを追加するんだよ。このメソッドを使ってプロパティーを追加・削除すると、View への反映をトリガーできるんだぜ。

`$add` と `$delete` を追加するのには、そういう理由があったわけですね。

さて、自作のクラスを渡せないのは明らかにバグっぽいので修正したいところではあります。

(追記) よくよく公式ドキュメントの [Instantiation Options - vue.js](http://vuejs.org/api/instantiation-options.html#data) を読んでみると

> The object must be JSON-compliant (no circular references)
>> `data` に渡すオブジェクトは JSON の仕様に従っていて、循環参照してないものにしてね

とあるので、自作クラスのオブジェクトを渡せないのは仕方ないようです。


Array も激しく書き換える
========================

Vue.js が激しく書き換えるのは Object だけではありません。配列も猛烈に書き換えます。

そのことは、ドキュメントの [Displaying a List - vue.js](http://vuejs.org/guide/list.html) からも伝わってきます (先ほどと同じくざっくりと日本語訳してる)。

> Under the hood, Vue.js intercepts an observed Array's mutating methods (`push()`, `pop()`, `shift()`, `unshift()`, `splice()`, `sort()` and `reverse()`) so they will also trigger View updates.
>
> You should avoid directly setting elements of a data-bound Array with indices, because those changes will not be picked up by Vue.js. Instead, use the agumented `$set()` method.
>
>> 内部的に、Vue.js は Array の状態を変更するメソッド (`push()`, `pop()`, `shift()`, `unshift()`, `splice()`, `sort()` and `reverse()`) の呼び出しを監視して、View が更新されるように処理をしてるんだぜ。
>>
>> インデックスを指定しての値を変更すると Vue.js が検知できないのでやめてほしいよ。その代り、`$set() メソッドってのを用意したから、こっちを使ってほしいんだぜ。

まぁ、こんな感じで、扱うには少し工夫が必要であります。


data に渡した Object が console.log() で見にくい問題の対処方法
==============================================================

`data` に渡した値を `console.log()` すると getter, setter の山になるわけで、値がどうなっているかを確認しにくいですね。

これをなんとかするには `JSON.stringify` を使う回避方法が [Instantiation Options - vue.js](http://vuejs.org/api/instantiation-options.html#data) にて示されております。

```javascript
var vm = new Vue({
  el: "body",
  data: {
    animal: { name: "foo" }
  }
});

console.log(JSON.stringify(vm.$data));
// {"animal":{"name":"foo"}} 
```


やや面倒だし、巨大なデータを渡したときは見つけるのが大変そうであります。そんなときは、さらに `JSON.parse()` で Object に変換すればよい。

面倒だから、Object に復元する関数でも作っておくとよいでしょう。

```javascript
function deepCopy(o) {
  return JSON.parse(JSON.stringify(o));
}

console.log(deepCopy(vm.$data));
```


Object.observe() に期待
=======================

こんな面倒なことになっているのも、Vue.js が ECMAScript 5 の世界で頑張っているからです。

ECMAScript 6 の `Object.observe()` が使える世界になれば、Object や Array の置き換えも不要になるし、Vue.js の設計もシンプルになることでしょう。

[Vue.js] の [ロードマップ](https://github.com/yyx990803/vue/issues/78) には 0.11 で `Object.observe()` が使えるなら使うようにする、と書いてあります。


まとめ
======

* [Vue.js] はオブジェクトの監視を行うために、Object のキーをプロパティーに置き換えたり、`Array.push()` を置き換えたりする
* この努力は ECMAScript 5 の限界ゆえ
* ECMAScript 6 で `Object.observe()` がやってきたら、[Vue.js] の実装もシンプルになるし、もっと楽な API になる

[Vue.js]: http://vuejs.org/