---
layout: post
title: text-hatena.js 公開
lang: ja
date: 2005-12-01 00:00:00
---
CPAN で公開されている [Text::Hatena] を JavaScript に移植してみました。


はじめに
========

このライブラリは [Text::Hatena] を JavaScript に移植したものです。

完全に JavaScript だけで書かれているので、ブラウザだけで「はてな記法」を HTML に変換できます。リアルタイムに変換できます。すごさを実感していただくために、[はてな記法ワープロ] のデモを公開しています。

ダウンロード
============

最新版は GitHub の GitHub [nitoyon/text-hatena.js](https://github.com/nitoyon/text-hatena.js) から入手できます。

※以下は古いバージョンでの情報です。

公開日        |バージョン|Text::Hatenaのバージョン|補足
--------------|----------|------------------------|-------------------
2005年11月30日|0.2       |0.05                    |pタグ停止記法に対応。<br>誤字修正（ds14050さんありがとうございます）。<br>0.05対応。
2005年11月21日|0.1       |0.04                    |pタグをとめる "><...><" は実装できていません

* 本家 Text::Hatena で HTML::Parser を用いている部分は実装できていません。
  * URL の自動リンクや HTML のエスケープなどは実装できていません。
  * Cookie を利用するようなサイトに text-hatena.js を利用するのはお勧めできません。
* ライセンスは Text::Hatena と同等とします。


技術的なアレコレ
================

Perl と JavaScript って意外と似てるよね、というところから出発しました。特に、Text::Hatena のソースコードはそのまま JavaScript に置き換えられるぐらいに洗練されたコードです。例えば、Hatena.pm の一部に次のようなソースがあるのですが

```perl
sub parse {
    my $self = shift;
    my $text = shift or return;
    $self->{context} = Text::Hatena::Context->new(
        text => $text,
        baseuri => $self->{baseuri},
        permalink => $self->{permalink},
        invalidnode => $self->{invalidnode},
        sectionanchor => $self->{sectionanchor},
    );
    my $node = Text::Hatena::BodyNode->new(
        context => $self->{context},
        ilevel => $self->{ilevel},
    );
    $node->parse;
}
```

これを JavaScript に移植すると次のようになりました。

```javascript
parse : function(text){
    this.self.context = new Hatena_Context({
        text : text || "",
        baseuri : this.self.baseuri,
        permalink : this.self.permalink,
        invalidnode : this.self.invalidnode,
        sectionanchor : this.self.sectionanchor
    });
    var node = new Hatena_BodyNode();
    node._new({
        context : this.self.context,
        ilevel : this.self.ilevel
    });
    node.parse();
}, 
```

ほとんど一緒ですよね。JavaScript と Perl で正規表現がそのまま流用できるのもうれしいところです。

Perl ソースを次のような正規表現で変換してやれば、ほとんど移植も終わったようなものです。

* `/\$self->{([^}]+)}/this.self["$1"]/g`
* `/my \$/var /g`
* `/=>/:/g`
* `/\$|\@//g`

もちろん、全てがそう単純にはいきません。特に、Hatena::Text の注釈の処理はかなり厄介でした。


[Text::Hatena]: http://search.cpan.org/dist/Text-Hatena/
[はてな記法ワープロ]: http://tech.nitoyon.com/javascript/application/texthatena/wordpro/
