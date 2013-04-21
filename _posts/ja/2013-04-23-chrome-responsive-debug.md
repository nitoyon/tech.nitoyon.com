---
layout: post
title: Google Chrome で超手軽にスマホ向けデザインを確認する方法
tags:
  - CSS
  - Chrome Developer Tool
lang: ja
thumbnail: http://farm9.staticflickr.com/8114/8672493580_228a11eae0_o.png
seealso:
  - 2013-02-15-viewport
  - 2013-02-14-text-size-adjust
  - 2013-01-29-jquery-source-map
  - 2012-04-20-uncopyable
---
最近、**Google Chrome のデベロッパー ツールにスマートフォンでの表示を確認する機能がある**ことを知りました。

いままでは、レスポンシブデザイン Web デザインをするときに、ちまちまとブラウザーのサイズを変えたり、Web サービス ([Responsive Design Testing](http://mattkersley.com/responsive/) とか [Responsive Web Design Test Tool](http://designmodo.com/responsive-test/) とか) を使っていたのですが、こちらの手順のほうがお手軽なので紹介します。


設定は超簡単！！
================

Google Chrome のデベロッパー ツールを開いて、右下の歯車のアイコンをクリックします。

左側から [Overrides] を選んで、[User Agent] と [Device metrics] にチェックを入れます。

{% image http://farm9.staticflickr.com/8260/8672447614_28f45f8d1d.jpg, 729, 432 %}

これだけです！


ためしに Yahoo! を表示してみよう
--------------------------------

[User Agent] で [iPhone -- iOS 4] を選んでから Yahoo! のトップページを開いてみると・・・。

{% image http://farm9.staticflickr.com/8114/8672493580_8246647f79.jpg, 536, 511 %}

m.yahoo.co.jp にリダイレクトされて、iPhone 4 のサイズで表示されました。

解像度指定の右にあるボタンを押すと「縦横切り替え」ができます。リロード不要です！

{% image http://farm9.staticflickr.com/8379/8672493572_927d7e0e0e.jpg, 752, 775 %}

横方向になると、画面の構成が少し変わりましたね。

今度は [iPad -- iOS 5] にしてみます。リロードしてみると・・・。

{% image http://farm9.staticflickr.com/8397/8671392997_2fc220a0eb.jpg, 1107, 834 %}

はい、PC 版にリダイレクトされて、iPad のサイズで表示できました。

User Agent も切り替えてくれるので、レスポンシブ Web デザインに対応したサイトだけでなく、User Agent で表示を切り替えているサイトも確認できますね。


登録されているスマートフォン一覧
--------------------------------

Google Chrome 26 に登録されているスマートフォンは次のもの。

  * iPhone -- iOS 5
  * iPhone -- iOS 4
  * iPad -- iOS 5
  * iPad -- iOS 4
  * Android 2.3 -- Nexus S
  * Android 4.0.2 -- Galaxy Nexus
  * BlackBerry -- PlayBook 2.1
  * BlackBerry -- 9900
  * BlackBerry -- BB10
  * MeeGo -- Nokia N9

試したい機種が登録されていなくても心配後無用。User Agent や解像度は手入力も可能です。


気になるところ
--------------

注意しなきゃいけないのは、**スマートフォンの表示を完全にエミュレートできるわけではない**、ということです。PC 版ブラウザーでUserAgent と表示サイズを変更しているだけだと割り切りましょう。

まず、viewport の設定が無視されます。そのため、viewport の設定によっては実際のスマートフォンでの表示と異なります。

たとえば、Yahoo! のモバイル版では viewport に `device-width` が設定してあるので、iPhone 4 では横幅 `320px` 相当で描画されるべきです。しかし、実際には `640px` 相当で描画してしまってます。実際の iPhone の表示に近づけるためには、サイズを `320px` に変更しなきゃいけません。

他にも、[Fit in window] をチェックすると、ブラウザーの領域内に収まるように表示してくれて便利なのですが、iPad の設定で Yahoo! のトップページを開くと横スクロールバーが表示されて変でした。[Fit in window] のチェックを外すと表示されないので、ズーム関係の処理と CSS の何かの指定がバッティングしてるのかもしれません。

ということで、最終確認は必ず実機でやるべきです。それでも、この機能を活用すれば、開発効率はかなり改善するはずです！


まとめ
======

Google Chrome に統合されているので、とてもお手軽に試せることが分かりました。レスポンシブ Web デザインしている場合も、サーバー側で User Agent みている場合でも、どちらでも活用できるのが便利です。大手サイトのスマホ デザインを確認するのも手軽にできるのが嬉しいですね。

ちなみに、User Agent を変更する機能は 2012 年 2 月の [Chrome 17 から提供](http://googlesystem.blogspot.jp/2011/12/changing-user-agent-new-google-chrome.html)、サイズを変更する機能は 2012 年 10 月から[提供されている](http://blog.chromium.org/2012/10/do-more-with-chrome-developer-tools.html)ようです。
