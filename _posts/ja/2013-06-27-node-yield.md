---
layout: post
title: Node.js 0.12 では yield が使えるのでコールバック地獄にサヨナラできる話
tags: Node.js JavaScript
lang: ja
seealso:
- ja/2013-02-27-livereloadx
- ja/2013-02-19-node-source-map
- ja/2011-09-29-async-await-in-js
- ja/2011-03-24-jQuery-extend-mania
- ja/2008-12-11-jquery-fast-css
---
Node.js の次のメジャーバージョン 0.12 で `yield` が使えるようになります。

そのおかげで、JavaScript のコールバック地獄に光が差し込むのです。ああ、さようなら、コールバック地獄。


7 年ごしで実現した yield
========================

2006 年、Firefox 2 のリリースと同時に `yield` は JavaScript 界に[登場](https://developer.mozilla.org/ja/docs/Web/JavaScript/New_in_JavaScript/1.7)しました。随分と前の話ですね。

登場した当時は JavaScript 界隈でけっこう話題になっていました。

* [JavaScript 1.7 の yield が凄すぎる件について - IT戦記](http://d.hatena.ne.jp/amachang/20060805/1154743229)
* [Latest topics > JavaScript 1.7のyield文ってなんじゃらほ - outsider reflex](http://piro.sakura.ne.jp/latest/blosxom/webtech/javascript/2006-08-07_yield.htm)
* [JavaScript 1.7 の新機能: Days on the Moon](http://nanto.asablo.jp/blog/2006/08/12/481381)

登場したときにはインパクト大きかったものの、結局 Firefox でしか使えない `yield` さんは忘れ去られていたわけです。

それがここにきて、[ECMAScript 6 に yield が入る](http://wiki.ecmascript.org/doku.php?id=harmony:generators)ことが決定して、V8 に実装されました。となれば、V8 を使ってる Node.js でも自動的に利用できるようになった、という流れであります。

7 年の月日を経て、日の目を見たわけで胸が熱くなります。何はともあれ、Node.js の次のバージョンに `yield` がやってくるのであります。ヤァヤァヤァ。


さようなら！ コールバック地獄
=============================

ということで、Node.js の話です。

脱出する前に、皆さんに地獄を見てもらいましょう。


これが地獄絵図だ！
------------------

サンプルとして、簡単なスクリプトを書いてみました。

```js
var fs = require('fs');

// カレント ディレクトリーのファイル一覧を取得する
fs.readdir('.', function(err, files) {
    // 先頭のファイルの中身を読み取る
    fs.readFile(files[0], 'utf-8', function(err, data) {
        // 読み取った結果を出力する
        console.log(data);
    });
});
```

ああ、美しきコールバック地獄。たった 3 つの処理をするだけなのに、コールバックが 2 つもあるわけです。

といっても、Node.js には `fs.readdirSync()` や `fs.readFileSync()` といった同期処理をする関数も用意されておりますが、コールバック地獄を再現するために、あえて非同期版を使っております。


Deferred にすがりつく
---------------------

こういうコールバック地獄から逃げるための今までの定石は Deferred だったわけです。jQuery にも実装されてるアレです。

Node.js で Deferred といえば [Q](https://github.com/kriskowal/q) が有名らしいので、Q を使って書き直してみました。

```js
var fs = require('fs');
var Q = require('q.js');

Q.nfcall(fs.readdir, '.')
.then(function(files) {
    return Q.nfcall(fs.readFile, files[0], 'utf-8');
})
.then(function(data) {
    console.log(data);
})
.done();
```

確かにコールバックの階層は押さえられたのですが、かえって読みにくくなったようにも感じます。Deferred をマスターしてしまえば極楽なのかもしれませんが、Deferred は学習コストがそこそこ高いと思うわけです。

また、コードもいまいちすっきりしません。`then()` でコールバックを繋げるために deferred を返しているのが、何とも読みにくい構造になっています。

Deferred にすがりつくと、一見、幸せになりそうなんだけど、数ヶ月後にソースを読んだときに、ただのコールバック地獄よりも一層深い奈落の底に叩き落される恐れすらあるわけです。


yield の恩恵を体験する
----------------------

で、`yield` です。

生で `yield` を扱うのは面倒なので、ライブラリーの力を借りましょう。

Node.js 界で数々の著名モジュールを作ってる TJ Holowaychuk (visionmedia) さんが、さっそく `yield` を活用するための [co] というモジュールを作ってるので使わせてもらいます。

こうなるんだぜ。

```js
var co = require('co');
var fs = require('fs');

co(function *() {
  var files = yield co.wrap(fs.readdir)('.');
  var data = yield co.wrap(fs.readFile)(files[0], 'utf-8');
  console.log(data);
});
```

同期処理っぽく書いていますが、実はコールバック地獄版と同じ処理になっています。

それぞれの処理で失敗したときには例外が飛ぶので、エラー処理もばっちりです。

ああ、幸せですね。夢が広がりんぐです。いままで面倒だった非同期処理がとっても気楽に書けるのであります。C# の `await` みたいなことができます。

あ、いちおう細かな点について触れときます。

* 上のソースを実行するには、[Node.js の Nightlies builds](http://jenkins.nodejs.org/html/nightlies.html) から v0.11 のバイナリーを拾ってきて、`node --harmony-generators foo.js` として実行する必要がある。
* co の最新のソース ([co@5bd0169](https://github.com/visionmedia/co/commit/5bd0169604e82c8f9900ad7b6edf95a5cb23df53)) は 48 行目の `gen.send(res);` でエラーになるので、`gen.next(res);` に書き換える必要がある。


yield について簡単に説明するよ
==============================

いちおう `yield` が何か、という話を簡単に触れておきます。詳しくは [harmony:generators [ES Wiki]](http://wiki.ecmascript.org/doku.php?id=harmony:generators) を見てください。

シンプルな例を書いてみました。

```js
function* N() {
    console.log("start");
    yield 1;
    console.log("after 1");
    yield 2;
    console.log("after 2");
    return 3;
}
```

まず、`yield` を使う関数は `function` ではなく `function*` で宣言します。(Firefox の先行実装と少し違います)

で、この関数を呼んでみます。

```js
var g = N();
console.log(g);
// {}
```

`function*` な関数を呼んでも、関数の処理は始まりません。変わりに関数の処理を開始させるためのジェネレーターが返ってきます。

では、ジェネレーターを使ってみましょう。ジェネレーターの `next()` を呼ぶと、関数の処理を開始できます。

```js
console.log(g.next());
// start
// { value: 1, done: false }
```

`yield` は `return` みたいなもので戻り値を返します。ここでは、戻り値の `1` が `value` として返ってきています。

`yield` と `return` の違い、それは、`yield` は続きから処理を再開できるところにあります。そう、`g.next()` を呼べばね。

```js
console.log(g.next());
// after 1
// { value: 2, done: false }
```

`after 1` から処理が再開して、`2` を返して、再び、関数は中断しました。もう一度 `g.next()` を呼んでみます。

```js
console.log(g.next());
// after 2
// { value: 3, done: true }
```

`return` で関数が終わったので、`done` が `true` になりました。(この戻り値も Firefox の先行実装と異なります)

こんな感じで、`yield` を使えば、関数の処理を途中で中断しておくことができます。で、上の co を使ったサンプルを見たら・・・なんとなく実現できそうな気がしてきましたか？


まとめ
======

* ECMAScript 6 に `yield` が入った → V8 に実装 → Node.js 0.12 で使える
* `yield` を使えばコールバック地獄から脱出できる。
* この記事では [co] を紹介したけど、便利ライブラリーはまだまだ登場しそう。

[co]: (https://github.com/visionmedia/co/)