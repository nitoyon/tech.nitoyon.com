---
layout: post
title: 画像をかっこよく浮かす方法
date: 2005-11-08 21:00:12 +0900
lang: ja
---
画像をきれいに見せるためのテクニックとして、影をつける手法が有用だ。プロが作るようなサイトを見ていても、影をつけてかっこよく見せている例をよく見受けられる。もはやデザインの王道テクニックといっていいだろう。とはいえ、いちいち影をつける加工をするのは面倒だし、画像編集環境が十分にない人もいるだろう。そこで画像に動的に影をつける手法を紹介する。

**(追記 2013/09/18 ) CSS3 の `box-shadow` や `text-shadow` を使えば、ここに書いてあるテクニックは不要となります***


画像に影をつける
================

サンプルは <a href="/css/csstips/drop_shadow/#1">こちら</a> にあるので確認してみてください。

まずは画像を div タグで囲います。

```html
<div class="photo"><img src="shatenki.jpg"></div>
```

CSS は次のように定義しておく。

```css
.photo{
	background:url('shadow.gif') no-repeat right bottom;
	width:auto;
	top:6px; left:6px;
	margin:0 6px 6px 0;
	float:left;
}

.photo img{
	position:relative;
	left:-6px; top:-6px;
}
```

これだけで画像に影がつきます。影は <a href="drop_shadow/shadow.gif">shadow.gif</a> が表示していますが、どんな画像に対しても影を表示できるように、このファイルは大きめに作っています。画像のサイズに合わせて、必要な量だけ自動的に影が表示されるわけです。


マウスを上に持ってくると影がなくなる
====================================

こちらのサンプルも <a href="drop_shadow/#2">こちら</a> に掲載しています。先ほどの例と異なるのは、マウスを画像の上におくと、影がなくなって、凹んだように見えるところです。

先ほどの CSS に次のコードを追加します。

```css
.photo a img{border:0}

.photo a:hover{
	position:relative;
	left:6px; top:6px;
}
```

ポイントは、`a:hover` にあわせて、表示位置を元に戻しているところです。

蛇足となりますが影をつけるレタッチソフトなら Google の [PiCaSa 2](http://picasa.google.com/index.html) がお勧めです。画像管理も編集も簡単な上に無料なのがありがたいですね。
