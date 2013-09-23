---
layout: post
title: HTML+JS版 Apollo アプリを作ってみる
lang: ja
date: 2007-03-22 23:26:52
toc:
- /apollo/tutorial/html-js.html
- /apollo/tutorial/as_apollo.html
---
Apollo 開発の方法を丁寧に説明していく予定です。第１回目は HTML+JavaScript で Apollo アプリを作ってみます。

そこそこ実用的な例、ということでシンプルな RSS リーダーを作ることにします。Apollo での通信にはドメインの制約がない、という利点を体感することもできます。動作イメージはこんな感じです。

<center><img src="rss-simple2.jpg" width="400" height="200" alt="rss-simple動作イメージ"></center>

開発環境のインストールがまだの方は、<a href="http://www.saturn.dti.ne.jp/~npaka/flash/apollo10/index.html">Adobe Apolloメモ</a> や <a href="http://zapanet.info/blog/item/953">はじめてのApolloプログラミング</a> を参考にして準備しておいてください（手抜き）。


HTML と JavaScript の作成
=========================

まずは HTML を準備します。`rss-simple.html` として保存します。味気ないですが、あえてシンプルにしてます。

```xml
<html>
<head>
<title>Simple RSS</title>
<script src="rss-simple.js"></script>
</head>

<body>
  <form>
    <input name="url" type="text" value="http://b.hatena.ne.jp/hotentry?mode=rss">
    <input type="submit" value="OPEN">
  </form>

  <div id="output"></div>
</body>
</html>
```

次に、`rss-simple.js` を作成します。こちらも JavaScript が分かる人なら説明は不要なぐらいシンプルなソースにしたつもりです。`<form>` の `submit` イベントをハンドリングして、指定された URL を `XmlHttpRequest` で取得し、HTML で出力しています。Apollo アプリといっても、ネットワーク通信を行うだけなら、通常の JavaScript と同じように書くことができます。

```javascript
var form;
var xmlhttp = new XMLHttpRequest();

// イベント登録
window.onload = function(){
  form = document.getElementsByTagName("form")[0];
  form.addEventListener("submit", onsubmit, false);
}

// フォームの送信時に呼ばれる
function onsubmit(event){
  // イベントの伝播をキャンセル
  event.preventDefault();
  event.stopPropagation();

  // テキストボックスの中身を取得
  var url = form.url.value;

  // Ajax でリクエスト
  xmlhttp.open("GET", url, true);
  xmlhttp.onreadystatechange = rssload;
  xmlhttp.send(null)
}

// Ajax イベント
function rssload(){
  if(xmlhttp.readyState!=4) return;
  var output = document.getElementById("output");

  // エラー処理
  if(xmlhttp.status != 200
   || xmlhttp.responseXML == null){
    output.innerHTML = "error";
    return;
  }

  // RSS をパースして HTML を作成
  var html = "<ol>";
  var items = xmlhttp.responseXML.getElementsByTagName("item");
  for(var i = 0; i < items.length; i++){
    try{
      var title = items[i].getElementsByTagName("title")[0].firstChild.nodeValue;
      html += '<li>' + escapeHTML(title) + '</li>';
    }
    catch(e){}
  }
  html += '</ol>';

  // 書き出し
  output.innerHTML = html;
}

// XSS 防止
function escapeHTML(str) {
  return str.replace(/&/g, "&amp;").replace(/"/g, "&quot;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}
```

さて、HTML と JavaScript がそろいました。この２つのファイルをアップロードすれば同じドメインの RSS 限定の RSS リーダーとしては動きます。（IE では JavaScript エラーになりますが...）


ADF の準備
==========

Apollo アプリとして実行するには ADF (Apollo Descriptor File) を作ります。`rss-simple-app.xml` として保存してください。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<application appId="com.nitoyon.tech.rss-simple" version="0.1" xmlns="http://ns.adobe.com/apollo/application/1.0.M3">
  <properties>
    <name>Simple RSS Reader</name>
    <publisher>nitoyon</publisher>
    <description/>
    <copyright/>
  </properties>
  <rootContent systemChrome="standard" visible="true">rss-simple.html</rootContent>
</application>
```

おまじないがいろいろ書いてありますが、「`application` の `appId` 属性」は必ず設定しましょう。同じ `appId` のアプリケーションは同時起動できないので、他の ADF からコピーしてくると無駄に悩んでしまうかもしれません。独自のものをちゃんと設定しましょう。

「`rootContent` の中身」も重要です。どのファイルを Apollo アプリとして使うのかを指定します。先ほど作った `rss-simple.html` を設定しています。

動かすために必要なタグは以上ですが、いちおう他のタグについても説明しておきます。

`property` タグの中には作者情報を入力します。`C:\Documents and Settings\username\Program Files\[publisher]\[name]` にインストールされるので、アプリケーションを配布するなら真面目に設定しておきましょう。

`icon` タグを指定しているサンプルも多いですが、手順が複雑になるので略します。配布するときに必要になったら嫌でも調べますよね。


ためしに実行
============

さてさて、前置きが長くなりましたが、これで準備完了です。コマンドラインから次のように入力してみてください。

```console
$ adl rss-simple-app.xml
```

単純ですね。ウインドウが表示されれば成功です。

<center><img src="rss-simple1.jpg" width="400" height="200" alt="rss-simple起動"></center>

ボタンを押すと RSS を取りに行って一覧を出力します。ドメインの制約なしに、`XmlHttpRequest` でアクセスできるのが確認できます。

<center><img src="rss-simple2.jpg" width="400" height="204" alt="rss-simple取得"></center>


表示できない場合は次の順でトラブルシューティングしてみてください。

1. adl が見つからない、認識されない
  * adl にパスが通っているか
  * 通っていない場合は、フルパスで入力してみる → adl は解凍したフォルダの bin の中にあります
2. ADF が正しいか見直す
  * rootContent の中身が正しいか (次のようなエラーが表示されます：This application cannot be run; an error occurred loading the root content file: xxxxx)
  * rootContent の visible 属性は true になっているか
  * 同じ appId の Apollo アプリが既に起動していないか


パッケージング
==============

adl コマンドは SDK についていたものなので、このまま配布しても Apollo ランタイムをインストールしている人には使ってもらえません。他の人に使ってもらうためにはパッケージングする必要があります。

パッケージングするには `adt` コマンドを使います。

```console
$ adt -package [AIRファイル名] [ADF] [パッケージに含めるファイルやフォルダ]
```

今回はこうなります。

```console
$ adt -package rss-simple.air rss-simple-app.xml rss-simple.html rss-simple.js
```

`rss-simple.js` を忘れないようにしましょう。パッケージ化、といっても実際はランタイムが解釈できる形式で zip ファイルに固めているだけです。パッケージに含めるファイルやフォルダを最後に列挙する理由はこの辺にあります。


`rss-simple.air` が出力されるので、アップロードしたら世界中の人にインストールしてもらえるかもしれません。

* ソースコードのダウンロード：<a href="rss-simple-source.zip">rss-simple-source.zip</a>


セキュリティ上の注意 (2007.3.24 2:00追記)
=========================================

Apollo α1 では、Apollo アプリ中で開いた HTML はローカルファイルに対するアクセス権を持ちます。そのため、**パッケージ外部の HTML へのリンクを作成することはセキュリティ上、大変危険です**。

本ページに掲載していました初期のサンプルにも同様の問題がありました。万が一インストールされた方がいらっしゃいましたら、直ちにアンインストールしていただくようお願いいたします。不十分な理解に基づきサンプルを作成したことをお詫びいたします。ご迷惑をおかけいたしました。

Apollo α１は開発者向けのプレビュー版であり、セキュリティ上の問題は後回しにされている印象があります。そのため、実行する前にソースコードを確認する、自分でコンパイルした Apollo アプリしか実行しない、といった自衛の策をとることをお薦めいたします。


まとめ
======

いかがだったでしょうか。Ajax の知識だけでアプリケーションを作れるのが分かっていただけたでしょうか。

サンプルアプリの見た目はかっこ悪いですが、HTML や CSS の知識があれば、いくらでもかっこよくできますね。JavaScript の知識があれば、機能をどんどん追加していけます。

ただ、Apollo がα版のためか、ブラウザへのペーストや日本語入力ができないなど、不十分な点はいろいろあります。このあたりは正式リリースまでには解決すると信じましょう。

次回予告
========

<a href="as_apollo.html">ActionScript 版 Apollo アプリを作ってみる</a>、をお届けします。
