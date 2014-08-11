---
layout: post
title: Driving on Google Earth!
date: 2006-09-21 00:00:00 +0900
lang: en
alternate:
  lang: ja_JP
  url: /javascript/application/racing/2.html
---
About six month ago, I released '[Google Map Racing Game](./1/)'.

But it was not enough to some people, who wanted to drive on Google Earth...


Demo
====

Look at <a href="http://www.youtube.com/watch?v=iMB5gzUtiM4">this movie</a>. I climbed up Mt.Fuji (the highest mountain in Japan), and drove on the expressways in Tokyo.


How to play
===========

The latest version of Google Earth (4.0.2080 beta or later) must be installed. 

This software works on Windows and Google Earth. I do not check on Google Earth Plus, Pro and Enterprise Edition.

1. Download <a href="2/drive_earth.hta">drive_earth.hta</a> and execute it.

2. Then, Google Earth starts, and you will see Mt.Fuji.

3. *Click 'drive_earth.hta' application to make it topmost window*。

4. Press 'Z' to accelerate, and 'Right' and 'Left' to turn. Enjoy driving!!!

   The following keys are available.

   Key        |Description
   -----------|----------------
   Right, Left|Handle
   Z          |Accelerator
   X          |Brake
   C          |Reverse
   Up, Down   |Change camera height.
   A, S       |Change camera angle.


Tips
====

* To go far away, press 'Up' key and zoom up. When you are close to the destination, zoom up by pressing 'Down' key.
* Check 'Terrian' on Layers panel. You can enjoy climbing Mt.Fuji and walk across Grand Canyon.


How it works
============

This software communicates with Google Earth using its COM interface. <s>This interface is not announced by Google.</s> This interface is announced by google on September 26, 2006. See here: <a href="http://earth.google.com/comapi/">http://earth.google.com/comapi/</a>.<br>You can look the definition of ths interface using OLE/COM Object Viewer('Type Libraries' -> 'Google Earth 1.0 Type Library').
