---
layout: post
title: Object.observe の死 (ECMAScript の提案取り下げ、V8 からも削除予定)
tags: JavaScript
lang: ja
seealso:
- ja/2014-07-18-data-binding
- ja/2014-06-30-vue-js-hook
- ja/2013-06-27-node-yield
- ja/2013-02-27-livereloadx
- ja/2013-02-19-node-source-map
---
1年前の記事 {% post_link 2014-07-18-data-binding %} では、`Object.observe()` について次のように説明した。

* JavaScript オブジェクトが変更されたときにコールバックを呼んでくれる API
* データバインディングの実装が簡単になる
* Google Chrome には実装済み
* ECMAScript 7 に提案中
* 提案が通れば MV* フレームワークの実装がシンプルになってハッピー

将来を期待されていた `Object.observe()` であったが、2015 年 11 月頭、ES Discuss メーリングリストへの [An update on Object.observe](https://esdiscuss.org/topic/an-update-on-object-observe) という投稿で、ECMAScript からの提案が取り下げられて、V8 エンジンからも年内に削除される予定であることが表明された。

Object.observe() に何があったのか
=================================

メーリングリストへの投稿をざっくりと訳してみた。

> 3年前、Rafael Weinstein、Erik Arvidsson、私 (Adam Klein) で、データバインディングを実現するための API を設計し始めた。V8 上のブランチでプロトタイプを作成したあと、V8 チームに正式版を開発することを認めてもらった。さらに、Object.observe (以下、"O.o" と表記) を ES7 標準に提案しつつ、Polymer チームと協力して O.o を使ってデータバインディングを実装した。
>
> 3年後、世界は大きく変わった。Ember や Angular といったフレームワークは O.o に興味を示したものの、既存のモデルを O.o のモデルに発展させるのは難しかった。Polymer は 1.0 をリリースするにあたりゼロから書き直されたが、そこでは O.o は使われなかった。さらに、React のような、データバインディングでミュータブルなものを避けようとする処理モデルが人気を博している。
>
> 関係者との議論の末、Object.observe の提案を TC39 (現在、ES 仕様策定のステージ 2) から取り下げることにした。また、今年の終わりまでには V8 でのサポートを終了したいと考えている ([chromestatus.com](https://www.chromestatus.com/metrics/feature/popularity) によると、Chrome がアクセスしたページのうち 0.0169% でしか O.o は利用されていない)。
>
> O.o を使っていた開発者は、[object-observe](https://github.com/MaxArt2501/object-observe) のような polyfill や [observe-js](https://github.com/polymer/observe-js) のようなラッパーライブラリーを使うことを検討してほしい。

`Object.observe()` は他のフレームワークで使われることもなかったし、Polymer でも使われなくなってしまったので、ECMAScript への提案を取り下げる、ということのようだ。

Polymer 1.0 のデータバインディング実現方法
==========================================

Polymer が `Object.observe()` を使わなくなった理由については、Polymer の開発にも関わっている Brian Chin さんから [スレッド](https://esdiscuss.org/topic/an-update-on-object-observe) 内に次のような[コメントがでている](https://esdiscuss.org/topic/an-update-on-object-observe#content-4)。

> O.o はプロパティーを変更したあと、非同期でコールバックが呼ばれるのがイケてなかった。Polymer 1.0 ではプロパティーを変更したら、すぐに変更が UI に反映されるので、利用者にも分かりやすくなっている。

モデルを書きかえた瞬間に、UI に反映されるようにしたかった、というのがメインの理由のようだ。

「じゃ、Polymer は `Object.observe()` の代わりに何を使ってるの？」という質問に対しては、次のような[回答](https://esdiscuss.org/topic/an-update-on-object-observe#content-2)が出ている。

> getter/setter を定義して、DOM イベントで伝搬させてるよ。詳しくは polymer-project.org を見てね。たとえば [ここ](https://www.polymer-project.org/1.0/docs/devguide/properties.html#change-callbacks) とか [ここ](https://www.polymer-project.org/1.0/docs/devguide/data-binding.html#change-notification-protocol) だよ

ざっと上記のページを見た感じでは、次のような感じでデータバインディングに使うプロパティーを宣言しておくらしい。

```javascript
  Polymer({
    is: 'custom-element',
    properties: {
      someProp: {
        type: String,
        notify: true
      }
    }
  });
```

スレッドには、他にも「ブラウザーでは使われないかもしれないけど、Node.js のエコシステムには大きな影響があるかもしれないから、そんなに急に削除しないでくれ」と Node.js の中の人が書き込んでいたり、「Firefox の [Object.watch()](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Object/watch) はデバッガーで使われてるからすぐに削除されることはないはず」といった書き込みがあったりして興味深い。


まとめ
======

`Object.observe()` は ECMAScript 7 に入ることはなくなったので、他のブラウザーに 実装される可能性はなくなったし、Google Chrome でも近い将来、使えなくなるだろう。