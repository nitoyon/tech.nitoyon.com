---
layout: post
title: IEerBug － IE6 用デバッグ コンソール
date: 2006-08-28 00:00:01 +0900
lang: ja
alternate:
  lang: en_US
  url: /javascript/application/ieerbug/index_en.html
---
**IEerBug** は Internet Explorer 6.0 と FireFox 1.5 で動く JavaScript 用のデバッグ コンソールです。

[FireBug](https://addons.mozilla.org/firefox/1843/) と同じ `console.log()`、`console.debug()` などの関数が使えるようになるため、FireFox と IE の両方でデバッグする場合に便利です。コンソールに出力したオブジェクトを、DOM インスペクタを利用して解析することも可能です。


使い方
======

1. <a href="ieerbug-0-2.zip">ieerbug.zip</a> をダウンロードし、中身をアプリケーションのディレクトリに配置します。IEerBug 用のディレクトリを作成して、その中に配置しても問題ありません。

2. HTML の中で次のようにして `ieerbug.js` を読み込みます。

   ```html
   <script src="ieerbug.js"></script>
   ```

3. JavaScript のソースの中で、コンソール出力用のコードを記述します。たとえば、次のように書くと

   ```javascript
   console.debug("test");
   console.debug("value is : %d %s", i, s);
   console.debug("debug object : %o", {x : 3, y : 2});
   console.info(document);
   console.assert(a);
   ```
   次のように出力されます。

   <img src="screen1.gif" width="403" height="188">

   `[object Object]` をクリックすると、オブジェクトの中身が表示されます。

   <img src="screen2.gif" width="409" height="193">

   `document` をクリックしても同じように document オブジェクトの中身を覗くことができます。

   <img src="screen3.gif" width="409" height="193">


主な特徴
========

* [FireBug のログ出力用関数](http://joehewitt.com/software/firebug/docs.php) を利用できます。
* HTML には IFRAME ノードを１つ作成するだけで、元の HTML ファイルや CSS を汚しません。
* JavaScript のグローバル ネームスペースには IEerBug、console という２つの関数しか作成しません。
* IEerBug を利用するためにライブラリは必要ありませんし、どんな JavaScript のライブラリとも共存できます。
* Internet Explorer 6.0 および Mozilla FireFox 1.5 で動きます。


Demo
====

[こちらをどうぞ](./demo/)。


ダウンロード
============

公開      |バージョン
----------|----------
2006-09-30|<a href="ieerbug-0-2.zip">ieerbug-0-2.zip</a>
2006-08-28|<a href="ieerbug-0-1.zip">ieerbug-0-1.zip</a>

IEerBug のライセンスは Mozilla Public License Version 1.1 とします。

これは FireBug が MPL であり、IEerBug のほとんどのソースは FireBug を参照しているためです。この場を借りて、FireBug の作者である <a href="http://www.joehewitt.com/">Joe Hewitt</a> 氏に感謝を申し上げます。


ドキュメント
============

IEerbBug の読み込み時、次のようなパラメータを与えることで、IEerBug の設定を行うことができます。

```html
<script src="ieerbug.js?x=50&y=200"></script>
```

パラメータは次のようなものがあります。

name|value|default value
----|-----|-------------
showJSErrors|IEerBug のコンソールに JavaScript のエラーを表示するかを決定します。|true
stopJSErrors|`true` に設定すると、ブラウザ デフォルトのエラーダイアログは表示されなくなります。|true
x|IEerBug のウインドウが表示される場所です。|50
y|同上。|200
width|IEerBug のウインドウの横幅です。|500
height|IEerBug のウインドウの縦幅です。|250
debug|デフォルトでは、IEerBug は console オブジェクトが定義されている場合は機能しません。これは、FireBug がインストールされているときには IEerBug が動作しないようにするためです。<br>`debug` が `true` の場合は、FireBug がインストールされていたとしても、IEerBug は必ず起動します。console オブジェクトは上書きされるため、コンソール出力は FireBug ではなく IEerBug に行われます。|false


FAQ
===

* Opera や Safari では動くの？
  * すいません、対応していません。誰か対応させてくれたら嬉しいです。
* FireBug にある Source View や Debugger の機能はサポートされますか？
  * Source View は将来的にサポートされるかもしれません。Debugger は技術的に不可能かと思われます。
* Ajax Request Spy 機能はサポートされますか?
  * ActiveXObject 関数を上書きすれば技術的には可能だと思います。


更新履歴
========

* 0.2 (2006/9/30)
  * window オブジェクトを出力できていなかったのを修正
  * IE のメモリリークに対処
