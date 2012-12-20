---
layout: post
title: text-hatena.js を GitHub に移動した
tags: JavaScript
lang: ja
---
2005 年ごろに作成して放置していた [text-hatena.js](http://tech.nitoyon.com/javascript/application/texthatena/download.html) について、twitter で

{% tweet https://twitter.com/teramako/status/280642151715594240 %}

というツッコミを受けたので GitHub で公開してみました。

  * [nitoyon / text-hatena.js - GitHub](https://github.com/nitoyon/text-hatena.js)

いま text-hatena.js のコードを読み返すと、グローバルな名前空間を汚染してたり、Object.extend() を定義してたりと、いろいろ酷い。

当時は今に比べると JavaScript の知識も浅かったが、浅いなりに prototype.js のコードを読んだり、真似したりして勉強していたことを思い出した。


2005 年の話
===========

text-hatena.js を公開した 2005 年といえば Web 2.0 だとか Ajax という言葉がバズっていて、ちょうどはてなブックマークが登場したあたりでもあった。

はてなブックマークは今よりも遥かに技術者寄りで、ホットエントリーには 2ch まとめや NAVER まとめの姿はなく、Ajax や JavaScript の話であふれていた。それらの記事を目を輝かせながら読み漁っていた。

自分もホットエントリーの仲間に入りたくて作ったものの 1 つが text-hatena.js だった。

公開当時にそこそこ話題になったのもうれしかったが、その後に層々たる人がプレゼン資料やブラウザー拡張に活用してくれたのがうれしかった。もしかしたら、自分が作ったものの中で、一番、人の役に立ってるのかもしれない。


2012 年の話
===========

せっかく GitHub に公開するのだから、ついでに 2012 年っぽく書き直してみることにした。

実践したのは次の 3 つ。

  * QUnit で単体試験を定義
  * 無名関数でグローバル変数を汚さないようにしつつ、node.js でも動くように
  * Grunt でファイルを監視して lint & QUnit

特に Grunt を組み込んだことで、ファイルを変更するたびに自動で lint して単体試験が走るのが便利だ。設定を少し変えれば、コード結合や minify もできちゃう。可能性を感じる。

考えてみると、jQuery や node.js は 2005 年当時は存在すらしていなかった。Google Chrome はもちろん Firebug もなかった。

prototype.js が全盛の時代にちまちまブラウザーで動作試験していたコードが、7 年のときを経て、現代の技術を活用して効率的に開発できるようになったわけで、隔世の感で胸が熱くなる。
