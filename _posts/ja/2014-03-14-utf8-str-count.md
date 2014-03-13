---
layout: post
title: 全角半角混在の文章で 1 行に半角何文字分あるか調べる方法
tags: Ruby Python Perl JavaScript
lang: ja
---
「ソースコードは 1 行あたり 80 文字以内」とか「コミットログは横幅 72 文字以内」とか、文字数に関するルールはいろいろある。

ルールを徹底するには機械的に判定したい。と思って、簡単なスクリプトを書こうとした瞬間、意外と「1 行あたりの文字数」をカウントするのが難しいことに気付いた。

たとえば、「あA」は「全角 1 文字＋半角 1 文字」なので半角 3 文字分としてカウントしたい。

しかし、UTF-8 の世界では「あA」の文字長は 2 だし、バイト数は 4 (あ=0xE38182、a=0x41) である。

EUC-JP や Shift-JIS の時代なら、単純に「あA」は 3 バイトなので「半角 3 つ分」とすぐ分かったのだけども… (逆に文字長を調べるのが面倒だった)。

はて、どうするか？　というのがこの記事でいいたいこと。


East Asian Width を見よ
=======================

いろいろとググった結果、Unicode の [East Asian Width] を参照するとよいらしい。

[East Asian Width] で [EastAsianWidth.txt](http://www.unicode.org/Public/UCD/latest/ucd/EastAsianWidth.txt) という資料が紹介されている。この資料では、全ての文字の横幅が 6 つのカテゴリーに分類されている。

そのカテゴリーが次の 6 つ。

分類 | 意味                     | 例
-----+--------------------------+-------------------------------
F    | East Asian Fullwidth     | Ａ (全角の A)
H    | East Asian Halfwidth     | ｱ (半角のア)
Na   | East Asian Narrow        | A (半角の A)
W    | East Asian Wide          | ア (全角のア)
A    | East Asian Ambiguous     | ○☆※ (一部の記号)、Д (ロシア語)
N    | Neutral (Not East Asian) | À

たとえば、「あ」なら `3042;W # HIRAGANA LETTER A` と書いてある。カテゴリーは `W` なので、全角 （＝半角 2 文字分) だと分かる。

ということで、`F`・`W` は全角 (＝ 2 文字分)、`H`・`Na`・`N` は半角 (＝ 1 文字) として扱えばよいわけだ。


Ambiguous をどうするか問題
--------------------------

で、`A` (East Asian Ambiguous) の扱いが難しい。

例にあるような ○☆※ などの記号を見ると全角として扱いたくなる。しかし、`A` にはロシア語も含まれている。

`A` を一律に全角として扱うと、「1 行に 80 文字以上書いたら警告出すシステム」を作ると、「80 文字超えてないのに警告出るんだけどなにこれ？」とロシアの人に怒られてしまうかもしれない。

具体例をみてみよう。ロシア語でヘンタイをあらわす「Хентай」をいくつかの環境で表示してみた。

{% image http://farm8.staticflickr.com/7394/13131518004_f517a03418_o.png, 680, 212 %}

Cent OS のコンソールでは半角になっているが、MS ゴシックなら全角になる。プロポーショナルなメイリオでは、だいたい半角で表示している。

悩ましい・・・！

とりあえず、Ambiguous は 1 文字として扱うのが安全そうだ。ある環境で 80 文字以上に見えていても、別の環境では 80 文字以内に見えている…ということは十分に起こりうるのだ…！


いろんな言語で判別したいよ
==========================

さて、一次情報と判定方法が分かったところで、いろんなスクリプト言語で実装するにはどうしたらいいだろう。`"East Asian Width" 言語名` で検索したら、それなりに情報が出てくる。


Python
------

一番簡単だったのが Python さん。標準モジュールの `unicodedata` に [`unicodedata.east_asian_width(unichr)`](http://docs.python.org/2/library/unicodedata.html#unicodedata.east_asian_width) なるメソッドがあった。

```python
>>> import unicodedata
>>> unicodedata.east_asian_width(u'あ')
'W'
>>> unicodedata.east_asian_width(u'※')
'A'
```


PHP
---

伝家の宝刀 mb うんたらの関数群の中に、期待通り [`mb_strwidth()`](http://www.php.net/manual/en/function.mb-strwidth.php) がいた。

```php
echo mb_strwidth("あ"); // 2
echo mb_strwidth("※"); // 1
```

Ambiguous は `1` を返すようだ。


Ruby
----

標準ではムリだけど、[`unicode-display_width`](https://github.com/janlelis/unicode-display_width) なるモジュールが gem にあった。

```ruby
require 'unicode/display_width'
"○".display_width #=> 1
'一'.display_width #=> 2
```

現時点では Ambiguous は全部 `1` を返しているよ、ということが TODO のところに書いてある。


JavaScript
----------

こちらも標準ではムリだけど、[`eastasianwidth`](https://github.com/komagata/eastasianwidth) なるモジュールが npm にあがっている。

```javascript
var eaw = require('eastasianwidth');
console.log(eaw.eastAsianWidth('￦')) // 'F'
console.log(eaw.eastAsianWidth('｡')) // 'H'
console.log(eaw.eastAsianWidth('뀀')) // 'W'

console.log(eaw.length('あいうえお')) // 10
```

ソースコードを読んだところ、Ambiguous は `2` を返している。


Perl
----

CPAN にある [`Unicode::EastAsianWidth`](http://search.cpan.org/~audreyt/Unicode-EastAsianWidth-1.33/lib/Unicode/EastAsianWidth.pm) を使えば、次のようにできるらしい。

```perl
use Unicode::EastAsianWidth;

$_ = chr(0x2588); # FULL BLOCK, an ambiguous-width character

/\p{InEastAsianAmbiguous}/; # true
/\p{InFullwidth}/;          # false
```

長さやカテゴリーが返ってこない分、少し面倒そう。


まとめ
======

3 行でまとめちゃう。

* UTF-8 では半角何文字分で表示されるのかを調べるのは少し面倒になった。
* しかも、環境によって何文字分で表示するかは違うので、完全に調べきるのはあきらめたほうがよい。
* 一次情報は [East Asian Width] にあるが、各種スクリプト言語には便利なライブラリーを使えばよい。

[East Asian Width]: http://www.unicode.org/reports/tr11/