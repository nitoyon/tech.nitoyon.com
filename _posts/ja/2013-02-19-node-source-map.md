---
layout: post
title: Node.js＋CoffeeScript でソースマップを使ってデバッグを楽にする方法
tags: JavaScript Node.js
lang: ja
seealso:
  - 2013-01-29-jquery-source-map
  - 2008-12-11-jquery-fast-css
  - 2011-03-24-jQuery-extend-mania
  - 2008-11-21-jquery-array
  - 2008-01-15-jquery-event
---
以前、{% post_link 2013-01-29-jquery-source-map %} を書いたけど、Node.js でソースマップする方法を紹介する。

何がうれしいかというと、Node.js で CoffeeScript や TypeScript、JSX なんかを使ったときに、例外に含まれるスタックトレースに変換前の位置を表示できる。

やり方は簡単。[source-map-support](https://github.com/evanw/node-source-map-support/) というモジュールを `require()` するだけ。


ためしに使ってみた
==================

GitHub に動かし方が書いてあるので、その通りにやってみる。

こんな感じの `demo.coffee` があったとする。

```coffeescript
require 'source-map-support'
foo = ->
  bar = -> throw new Error 'this is a demo'
  bar()
foo()
```

`npm install source-map-support` で source-map-support モジュールをインストールしておく。

生の CoffeeScript がソースマップに対応してないので、CoffeeScriptRedux を使って JavaScript に変換する。

```bash
$ CoffeeScriptRedux/bin/coffee --js -i demo.coffee > demo.js
$ echo '//@ sourceMappingURL=demo.js.map' >> demo.js
$ CoffeeScriptRedux/bin/coffee --source-map -i demo.coffee > demo.js.map
```

あとは普通に実行すれば、スタックトレースには coffee ファイルの位置が出てくる。

```bash
$ node demo.js

demo.coffee:4
  bar = -> throw new Error 'this is a demo'
                  ^
Error: this is a demo
    at bar (demo.coffee:4:19)
    at foo (demo.coffee:5:3)
    at Object.<anonymous> (demo.coffee:6:3)
    at Object.<anonymous> (demo.coffee:6:6)
    at Module._compile (module.js:449:26)
                 :
```

`bar (demo.coffee:4:19)` のところにご注目。

本当だったら、ここがコンパイル後の demo.js 上の位置になってるはずなんだけど、source-map-support モジュールのおかげで、コンパイル前の位置が表示されている。

ここでは示してないけど、`Error` を `catch` したときの `error.stack` も coffee ファイルの場所になる。

CoffeeScript だけじゃなく、TypeScript や JSX もソースマップには対応しているし、圧縮やファイル結合したきにもソースマップさえ吐いておけば、このように変換前の位置情報を出力してくれるようになるので、便利便利である。


仕組み
======

動作原理が気になったので [source-map-support.js](https://github.com/evanw/node-source-map-support/blob/master/source-map-support.js) のソースをざっと読んでみた。

一番の肝は `Error.prepareStackTrace()` を定義して、スタックトレースを書き換えているところ。どうやら V8 エンジンの [Stack Trace API](http://code.google.com/p/v8/wiki/JavaScriptStackTraceApi) というものがあるようだ。

また、未処理の例外のときに例外が発生した位置のソースを表示するために、`process.on('uncaughtException', ...)` でがんばって処理している。

ソースマップの解析には [Mozilla の source-map モジュール](https://github.com/mozilla/source-map) を使っているようだ。


まとめ
======

Node.js でもソースマップが使えるよ。

(参考記事) [Node.js Source Map Support for Better Compiled JavaScript Debugging - Badass JavaScript](http://badassjs.com/post/42588937391/node-js-source-map-support-for-better-compiled)
