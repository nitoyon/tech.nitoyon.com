---
layout: post
title: 'as3Query: alpha version (New Wave ActionScript)'
lang: en
tag: ActionScript
---
as3Query is an ActionScript3.0 port of John Resig's exellent JavaScript library <a href="http://jquery.com/">jQuery</a> 1.2.1.

This port is released under the MIT and GPL licenses(as is the original jQuery).
Documentation is NOT available. Please refer to the original <a href="http://docs.jquery.com/Main_Page">jQuery Documentation</a>. Most features are ported except for Ajax methods.

Download
========

Full source code for the engine and examples is hosted on a Subversion(SVN) server.

For anonymous check-out, the command is:

    svn co http://www.libspark.org/svn/as3/as3Query/

Demos
=====
25 Boxes
--------
This demo shows how to create instances and monitor events.

<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="250"
height="250" codebase="http://active.macromedia.com/flash7/cabs/swflash.cab#version=9,0,0,0">
<param name="src" value="http://snippets.libspark.org/svn/as3/as3Query/samples/Box25.swf"/>
<param name="play" value="true"/>
<param name="loop" value="true"/>
<param name="bgcolor" value="#ffffff"/>
<param name="quality" value="high"/>
<embed src="http://snippets.libspark.org/svn/as3/as3Query/samples/Box25.swf" width="250" height="250" bgcolor="#ffffff" play="true" loop="true" quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash">
</embed>
</object>

* [Source code](http://snippets.libspark.org/trac/browser/as3/as3Query/samples/Box25.as) ([plain text](http://snippets.libspark.org/svn/as3/as3Query/samples/Box25.as))

25 Boxes + Tweener
------------------

jQuery animation may be poor for Flash creators. So, I added 'addTween' method to cooperate with '<a href="http://code.google.com/p/tweener/">Tweener</a>' (a famous AS3 animation library).

<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="340"
height="340" codebase="http://active.macromedia.com/flash7/cabs/swflash.cab#version=9,0,0,0">
<param name="src" value="http://snippets.libspark.org/svn/as3/as3Query/samples/Box25withTweener.swf"/>
<param name="play" value="true"/>
<param name="loop" value="true"/>
<param name="bgcolor" value="#d7e3e0"/>
<param name="quality" value="high"/>
<embed src="http://snippets.libspark.org/svn/as3/as3Query/samples/Box25withTweener.swf" width="340" height="340" bgcolor="#d7e3e0" play="true" loop="true"
quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash">
</embed>
</object>

* [Source code](http://snippets.libspark.org/trac/browser/as3/as3Query/samples/Box25withTweener.as) ([plain text](http://snippets.libspark.org/svn/as3/as3Query/samples/Box25withTweener.as))

CSS Selector Demo
-----------------

You can test CSS Selector-based DisplayObject traversal. For example, CSS "E" matches all of the instances of class E.

<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="420"
height="430" codebase="http://active.macromedia.com/flash7/cabs/swflash.cab#version=9,0,0,0">
<param name="src" value="http://snippets.libspark.org/svn/as3/as3Query/samples/CssSelectorDemo.swf"/>
<param name="play" value="true"/>
<param name="loop" value="true"/>
<param name="bgcolor" value="#d7e3e0"/>
<param name="quality" value="high"/>
<embed src="http://snippets.libspark.org/svn/as3/as3Query/samples/CssSelectorDemo.swf" width="420" height="430" bgcolor="#d7e3e0" play="true" loop="true"
quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash">
</embed>
</object>

* [Source code](http://snippets.libspark.org/trac/browser/as3/as3Query/samples/CssSelectorDemo.as) ([plain text](http://snippets.libspark.org/svn/as3/as3Query/samples/CssSelectorDemo.as))

The demo uses an XML to create and place shapes. See <a href="http://snippets.libspark.org/trac/browser/as3/as3Query/samples/CssSelectorDemo.as#L79">the XML object in the source code</a>. When as3Query receives the XML, it creates instances and set attributes according to the XML. It looks like an HTML (or a MXML), doesn't it?