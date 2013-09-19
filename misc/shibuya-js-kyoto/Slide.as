/**
 * DOM for WSH
 *
 * Presentation at Shibuya.js at Kyoto (2008/7/19)
 * http://shibuyajs.org/articles/2008/07/01/shibuya-js-in-kyoto
 *
 * requires as3Query, Tweener and FIVe3D
 */
package {

import flash.filters.*;
import flash.display.*;
import flash.text.*; TextField;
import flash.events.*;
import flash.ui.Keyboard;
import flash.ui.Mouse;
import flash.net.*;
import flash.utils.*;
import caurina.transitions.Tweener;
import com.nitoyon.as3query.*;
import five3D.display.*;
Kyoto; NotepadFadeOut;

[SWF(backgroundColor="#000000")]
public class Slide extends Sprite {
	private var curPage:int = 0;
	private var typingNumber:int = -1;
	private var so:SharedObject;

	// cursor
	[Embed(source="assets/left.png")]
	private var LeftArrow:Class;
	[Embed(source="assets/right.png")]
	private var RightArrow:Class;
	private var rightCursor:Bitmap;
	private var leftCursor:Bitmap;

	// font
	[Embed(source='アニトＭ-教漢.TTF', fontName='anito', unicodeRange="U+0020,U+0021,U+0022,U+0027,U+0028,U+0029,U+002B,U+002C,U+002D,U+002E,U+002F,U+0031,U+0032,U+0033,U+0034,U+0035,U+0038,U+0039,U+003A,U+003B,U+003F,U+0041,U+0042,U+0043,U+0044,U+0045,U+0047,U+0048,U+0049,U+004A,U+004B,U+004C,U+004D,U+004E,U+004F,U+0052,U+0053,U+0054,U+0055,U+0056,U+0057,U+0058,U+0059,U+0061,U+0062,U+0063,U+0064,U+0065,U+0066,U+0067,U+0068,U+0069,U+006A,U+006B,U+006C,U+006D,U+006E,U+006F,U+0070,U+0071,U+0072,U+0073,U+0074,U+0075,U+0076,U+0077,U+0078,U+0079,U+2026,U+2191,U+2192,U+3000,U+3001,U+3002,U+3042,U+3044,U+3046,U+3048,U+304A,U+304B,U+304C,U+304D,U+304F,U+3051,U+3053,U+3054,U+3055,U+3056,U+3057,U+3058,U+3059,U+305A,U+305B,U+305F,U+3060,U+3061,U+3063,U+3064,U+3065,U+3066,U+3067,U+3068,U+3069,U+306A,U+306B,U+306E,U+306F,U+3070,U+3079,U+307E,U+307F,U+3081,U+3082,U+3084,U+3087,U+3088,U+3089,U+308A,U+308B,U+308C,U+308D,U+3092,U+3093,U+30A1,U+30A2,U+30A4,U+30A6,U+30A7,U+30A8,U+30AA,U+30AF,U+30B0,U+30B1,U+30B3,U+30B6,U+30B7,U+30B8,U+30B9,U+30BB,U+30BD,U+30BF,U+30C1,U+30C3,U+30C4,U+30C8,U+30C9,U+30CF,U+30D0,U+30D5,U+30D6,U+30D7,U+30D9,U+30DE,U+30DF,U+30E5,U+30E6,U+30E7,U+30E9,U+30EA,U+30EB,U+30EC,U+30ED,U+30F3,U+30FB,U+30FC,U+4E00,U+4E0A,U+4E8B,U+4EAC,U+4ECA,U+4ED5,U+4ED6,U+4EE5,U+4F3C,U+4F4D,U+4F4F,U+4F55,U+4F5C,U+4F7F,U+4F8B,U+5065,U+5165,U+5229,U+529B,U+52D5,U+5316,U+5358,U+5408,U+540C,U+540D,U+5531,U+5584,U+5728,U+5831,U+5834,U+5916,U+5B58,U+5B9A,U+5B9F,U+5BA3,U+5BFE,U+5C64,U+5F35,U+5F8C,U+5FDC,U+60C5,U+6280,U+62E1,U+64CD,U+6539,U+65B9,U+6700,U+6709,U+672A,U+672C,U+697D,U+69CB,U+6A19,U+6A5F,U+6B21,U+6CD5,U+6E96,U+7121,U+7406,U+7528,U+7530,U+767B,U+76EE,U+79C1,U+7AE0,U+7B2C,U+7C21,U+7D44,U+7D50,U+7F6E,U+7FA9,U+80FD,U+81EA,U+884C,U+8853,U+88C5,U+8907,U+8A00,U+8A66,U+8AB2,U+8AD6,U+8D77,U+9020,U+90E8,U+90FD,U+9332,U+9580,U+964D,U+968E,U+96D1,U+984C,U+9858,U+98A8,U+FF01,U+FF11,U+FF12,U+FF13,U+FF1A,U+FF1F,U+FF5E")]
	private var font:Class;

	// sprites
	private var base:Sprite;
	private var curPageSprite:Sprite;

	// size
	private var scale:Number = 1.0;
	private const WIDTH:int = 640;
	private const HEIGHT:int = 480;

	// Assets
	[Embed(source="assets/techni.jpg")]
	private var Techni:Class;
	[Embed(source="assets/notepad.png")]
	private var Notepad:Class;
	[Embed(source="assets/cmd.png")]
	private var Cmd:Class;
	[Embed(source="assets/dom-html.png")]
	private var DomHtml:Class;
	[Embed(source="assets/dom-q.png")]
	private var DomQ:Class;
	[Embed(source="assets/dom-win.png")]
	private var DomWin:Class;
	[Embed(source="assets/calc.png")]
	private var Calc:Class;
	[Embed(source="assets/calc1.png")]
	private var Calc1:Class;
	[Embed(source="assets/calc2.png")]
	private var Calc2:Class;
	[Embed(source="assets/calc3.png")]
	private var Calc3:Class;
	[Embed(source="assets/orecalc1.png")]
	private var Orecalc1:Class;
	[Embed(source="assets/orecalc2.png")]
	private var Orecalc2:Class;

	public function Slide() {
		var loader:Loader = new Loader();
		//loader.load(new URLRequest('assets/AnitoFont.swf'));
		//loader.contentLoaderInfo.addEventListener("complete", function(event:Event):void{
			init();
		//});
	}

	private function init():void{
		$(stage)
			.attr({
				scaleMode : "noScale",
				align : "TL"
			})
			.keydown(keydownHandler)
			.mousemove(mouseMoveHandler)
			.resize(resizeHandler)
			.bind("mouseLeave", function(event:Event):void{
				leftCursor.visible = rightCursor.visible = false;
			})
			.click(clickHandler);

		stage.addChild(rightCursor = new RightArrow());
		stage.addChild(leftCursor = new LeftArrow());
		rightCursor.visible = leftCursor.visible = false;

		base = new Sprite();
		addChild(base);
		resizeHandler(null);

		curPage = -1;
		var page:int = 0;
		so = SharedObject.getLocal("shibuya_js_kyoto");
		page = so.data.index;

		show(page);
	}

	/**
	 * resize handler
	 */
	private function resizeHandler(event:Event):void{
		var sw:Number = stage.stageWidth;
		var sh:Number = stage.stageHeight;

		// calc scale
		scale = Math.min(sw / WIDTH, sh / HEIGHT);

		// update base
		base.x = (sw - WIDTH  * scale) / 2;
		base.y = (sh - HEIGHT * scale) / 2;
		base.scaleX = base.scaleY = scale;
	}

	/**
	 * UI操作
	 */
	private function keydownHandler(event:KeyboardEvent):void{
		switch(event.keyCode)
		{
			case Keyboard.RIGHT:
				next();
				break;
			case Keyboard.LEFT:
				prev();
				break;
			case Keyboard.SPACE:
				event.shiftKey ? prev() : next();
				break;
			case Keyboard.HOME:
				show(0);
				break;
			case Keyboard.END:
				show(slide.length() - 1);
				break;
			case Keyboard.ENTER:
				if(typingNumber != -1)
				{
					show(typingNumber - 1);
				}
				break;
		}

		// 入力中の数字を管理
		if(48 <= event.keyCode && event.keyCode < 58)
		{
			if(typingNumber == -1) typingNumber = 0;
			typingNumber = typingNumber * 10 + event.keyCode - 48;
		}
		else
		{
			typingNumber = -1;
		}

		// フォーカスを stage に固定
		stage.focus = stage;
	}

	/**
	 * マウスの位置を取得。
	 * @return -1: 左へ、0: なし、1: 右へ
	 */
	private function getMousePos(x:Number):int
	{
		return -base.x + x < WIDTH * scale / 3 ? -1 : -base.x + x > WIDTH * scale / 3 * 2 ? 1 : 0;
	}

	/**
	 * カーソルの切り替え
	 */
	private function mouseMoveHandler(event:MouseEvent):void
	{
		var prev:Boolean = false;
		switch(getMousePos(event.stageX))
		{
			case 0:
				Mouse.show();
				rightCursor.visible = leftCursor.visible = false;
				return;
			case -1:
				prev = true;
				break;
		}

		Mouse.hide();

		var s:Bitmap = (prev ? leftCursor : rightCursor);
		var h:Bitmap = (prev ? rightCursor : leftCursor);

		s.visible = true;
		s.x = event.stageX;
		s.y = event.stageY;
		h.visible = false;
	}

	private function clickHandler(event:MouseEvent):void
	{
		show(curPage + getMousePos(event.stageX));
	}

	/**
	 * 前のページに移動
	 */
	private function prev():void{
		show(curPage - 1);
	}

	/**
	 * 次のページに移動
	 */
	private function next():void{
		show(curPage + 1);
	}

	/**
	 * 指定されたページを表示
	 */
	private function show(page:int):void{
		var newPage:int = Math.min(Math.max(0, page), slide.length() - 1);
		if(newPage != curPage)
		{
			showXml(slide[newPage], curPage < newPage);

			so.data.index = curPage = newPage;
			so.flush();
		}
	}

	/**
	 * XML からページを表示
	 */
	private function showXml(page:XML, next:Boolean = true):void{
		// アニメーション中のものを削除
		while(base.numChildren) base.removeChildAt(0);

		// アニメーション後の位置に強制表示
		if(curPageSprite){
			curPageSprite.x = curPageSprite.y = 0;
			base.addChild(curPageSprite);
		}

		// 新しいページを作成
		var d:DisplayObject = createParts(page);
		d.y = page.@valign != "no" ? Math.max(0, (HEIGHT - d.height) / 2) : 0;
		var newPage:Sprite = new Sprite();
		newPage.addChild(d);

		// effect を決定
		var effect:String = (next ? page.@effect.toString() : slide[curPage].@effect.toString());

		switch(effect.toLowerCase()){
			case "cube":		moveCube(curPageSprite, newPage, next); break;
			case "slide":		moveSlide(curPageSprite, newPage, next); break;
			case "fadeinout":	moveFadeInOut(curPageSprite, newPage, next); break;
			case "bouncein":	moveBounceIn(curPageSprite, newPage, next); break;
			default:			moveNormal(curPageSprite, newPage, next); break;
		}
		curPageSprite = newPage;
	}

	private function moveNormal(cur:DisplayObject, newPage:DisplayObject, next:Boolean):void{
		if(cur && cur.parent){
			cur.parent.removeChild(cur);
		}

		base.addChild(newPage);
	}

	private function moveFadeInOut(cur:DisplayObject, newPage:DisplayObject, next:Boolean):void{
		if(cur){
			Tweener.addTween(cur, {
				alpha : 0,
				time: .8,
				onComplete: function():void{
					if(cur.parent) cur.parent.removeChild(cur);
				}
			});
		}

		base.addChild(newPage);
		newPage.alpha = 0;
		Tweener.addTween(newPage, {
			alpha: 1,
			time: .8
		});
	}

	private function moveBounceIn(cur:DisplayObject, newPage:DisplayObjectContainer, next:Boolean):void{
		if(cur && cur.parent){
			cur.parent.removeChild(cur);
		}

		if(next){
			newPage.x = -WIDTH / 2;
			newPage.y = -HEIGHT / 2;
			newPage.alpha = 0;
			newPage.scaleX = newPage.scaleY = 2;

			Tweener.addTween(newPage, {
				x: 0,
				y: 0,
				_scale: 1,
				time: .8,
				transition: "easeOutBounce"
			});
			Tweener.addTween(newPage, {
				alpha: 1,
				time: .8
			});
		}
		base.addChild(newPage);
	}

	private function moveSlide(cur:DisplayObject, newPage:DisplayObject, next:Boolean):void{
		// 前面のオブジェクトをスライド
		if(cur){
			Tweener.addTween(cur, {
				x : WIDTH * (next ? -1.5 : 1.5),
				time: .8,
				onComplete: function():void{
					if(cur.parent) cur.parent.removeChild(cur);
				}
			});
		}

		newPage.x = WIDTH * (next ? 1.5 : -1.5);
		base.addChild(newPage);
		Tweener.addTween(newPage, {
			x : 0,
			time: .8
		});
	}

    private function moveCube(cur:DisplayObject, newPage:DisplayObject, next:Boolean):void {
        var scene:Scene3D = new Scene3D();
        scene.x = WIDTH / 2;
        scene.y = HEIGHT / 2;
        base.addChild(scene);

        var box:Sprite3D = new Sprite3D();
        box.z = WIDTH / 2;
        scene.addChild(box);

        var bmd1:BitmapData = new BitmapData(WIDTH, HEIGHT, true, 0xff000000);
        var bmd2:BitmapData = new BitmapData(WIDTH, HEIGHT, true, 0xff000000);
		if(cur) bmd1.draw(cur);
        bmd2.draw(newPage);

        var img2:Bitmap3D = new Bitmap3D(next ? bmd2 : bmd1);
        box.addChild(img2);
        img2.x = WIDTH / 2;
        img2.y = -HEIGHT / 2;
        img2.z = -WIDTH / 2;
        img2.rotationY = -90;

        var img1:Bitmap3D = new Bitmap3D(next ? bmd1 : bmd2);
        box.addChild(img1);
        img1.x = -WIDTH / 2;
        img1.y = -HEIGHT / 2;
        img1.z = -WIDTH / 2;

		if(cur) cur.parent.removeChild(cur);
		box.rotationY = next ? 0 : 90;
        Tweener.addTween(box, {
            time: 1.0,
            rotationY: next ? 90 : 0,
            transition: "easeInOutCubic",
            onUpdate: function():void{
                box.setChildIndex(Math.abs(box.rotationY) > 45 ? img1 : img2, 0);
            },
            onComplete: function():void{
                if(scene.parent){
					scene.parent.removeChild(scene);
                	base.addChild(newPage);
                }
                bmd1.dispose();
                bmd2.dispose();
            }
        });
	}

	/**
	 * XML から DisplayObject を生成
	 */
	private function createParts(page:XML):DisplayObject
	{
		switch(page.localName())
		{
			case "takahashi":
				return createTakahashi(page);
			case "image":
				return createImage(page);
			case "vbox":
				return createVBox(page);
			case "canvas":
				return createCanvas(page);
			default:
				return createClass(page);
		}
		return null;
	}

	/**
	 * 文字列を表示
	 */
	private function createTakahashi(page:XML):DisplayObject{
		var t:TextField = $(TextField)
			.css("p",{
				fontSize: (page.@size.toString() != "" ? page.@size : 60),
				textAlign: page.@align.toString() != "" ? page.@align : "center",
				color: page.@color.toString() != "" ? page.@color : "#ffffff",
				fontFamily: page.@family.toString() != "" ? page.@family : "anito"
			})
			.attr({
				embedFonts: page.@family.toString() == "",
				selectable: false,
				multiline: true,
				wordWrap: true,
				width: page.@width.toString() != "" ? parseInt(page.@width) : WIDTH,
				condenseWhite: true,
				x: page.@x.toString() != "" ? parseInt(page.@x) : 0,
				height: HEIGHT
			})
			.attr(
				"htmlText", "<p>" + page.toString() + "</p>"
			)[0];

		t.height = t.textHeight + 10;
		return t;
	}

	/**
	 * 画像を作成する
	 */
	private function createImage(page:XML):DisplayObject
	{
		if(page.@["class"].toString() != "")
		{
			var cls:Class = this[page.@["class"].toString()] as Class;
			if(cls)
			{
				var d:DisplayObject = new cls() as DisplayObject;
				if(d)
				{
					if(page.@width.toString() != "") d.width  = parseInt(page.@width);
					if(page.@height.toString() != "") d.height = parseInt(page.@height);
					d.x = (WIDTH - d.width) / 2;
					return d;
				}
			}
		}
		return null;
	}

	/**
	 * VBox コンテナを作成する
	 */
	private function createVBox(page:XML):DisplayObject
	{
		var container:Sprite = new Sprite();

		var h:Number = 0;
		for each(var xml:XML in page.children())
		{
			var child:DisplayObject = createParts(xml);
			if(child)
			{
				container.addChild(child);
				child.y = h;
				h += child.height;
			}
		}

		return container;
	}

	/**
	 * VBox コンテナを作成する
	 */
	private function createCanvas(page:XML):DisplayObject
	{
		var container:Sprite = new Sprite();

		for each(var xml:XML in page.children())
		{
			var child:DisplayObject = createParts(xml);
			if(child)
			{
				container.addChild(child);
				child.x = parseInt(xml.@x, 10);
				child.y = parseInt(xml.@y, 10);
			}
		}

		return container;
	}

	/**
	 * クラスから作成する
	 */
	private function createClass(page:XML):DisplayObject
	{
		var cls:Class = Class(getDefinitionByName(page.localName()));
		var d:DisplayObject = new cls();
		return d;
	}

	private static var slide:XMLList = <>
		<!--title-->
		<takahashi size="60">
			<![CDATA[<font size="80">WSH <font size="-10">で</font> DOM</font><br/>
			<font size="40">～dom4winui.js～</font><br/>
			<br/>
			<font size="30">nitoyon <font size="-10">(最田 健一)</font></font>
			]]>
		</takahashi>

		<canvas>
			<Kyoto/>
			<takahashi size="40" y="275">WELCOME TO KYOTO</takahashi>
		</canvas>

		<takahashi size="30">
			nitoyon
		</takahashi>

		<vbox effect="fadeinout">
			<takahashi size="50">京都在住プログラマ</takahashi>
			<image class="Techni" width="440" height="289"/>
			<takahashi size="30">http://tech.nitoyon.com/</takahashi>
		</vbox>

		<takahashi size="40" x="30" align="left" effect="cube">
			<![CDATA[
				<p align="center"><font size="80">WSH<font size="-20">で</font>DOM</font><br/>
				<font size="-10">～dom4winui.js～</font></p>
				<font size="+10" color="#cccccc">目次</font><br>
				1. WSH入門<br>
				2. WSH<font size="-10">で</font>ライブラリ<font size="-10">を</font>使う<br>
				3. おまじない<font size="-10">を</font>改善<br>
				4. 結論
			]]>
		</takahashi>

		<takahashi size="40" effect="cube">第1章<br/><br/><font size="80">WSH 入門</font></takahashi>

		<takahashi size="60" effect="fadeinout"><font color="#66ccff">WSH</font>って何だろう？</takahashi>

		<canvas effect="fadeinout">
			<takahashi size="28" x="30" color="#ffffff" width="600" align="left">
				<![CDATA[WSH <font size="-5">(Windows Script Host)</font>は、Microsoft Windowsにおいてスクリプトを実行するソフトウェアである。
				<br/>
				<br/>
				Windows 98以降で標準で利用できる。
				<br/>
				<br/>
				バッチファイルやUnixにおけるシェルスクリプトと似た位置づけの技術である。
				<br/>
				<br/>
				標準ではVBScriptとJScriptを利用できる。
				]]>
			</takahashi>
		</canvas>

		<canvas>
			<takahashi size="28" x="30" color="#666666" width="600" align="left">
				<![CDATA[WSH <font size="-5" color="#99eeff">(Windows Script Host)</font>は、Microsoft Windowsにおいてスクリプトを実行するソフトウェアである。
				<br/>
				<br/>
				Windows 98以降で標準で利用できる。
				<br/>
				<br/>
				バッチファイルやUnixにおけるシェルスクリプトと似た位置づけの技術である。
				<br/>
				<br/>
				標準ではVBScriptとJScriptを利用できる。
				]]>
			</takahashi>
		</canvas>

		<canvas>
			<takahashi size="28" x="30" color="#666666" width="600" align="left">
				<![CDATA[WSH <font size="-5">(Windows Script Host)</font>は、Microsoft Windowsにおいてスクリプトを実行するソフトウェアである。
				<br/>
				<br/>
				<font color="#99eeff">Windows 98以降で標準で利用できる</font>。
				<br/>
				<br/>
				バッチファイルやUnixにおけるシェルスクリプトと似た位置づけの技術である。
				<br/>
				<br/>
				標準ではVBScriptとJScriptを利用できる。
				]]>
			</takahashi>
		</canvas>

		<canvas>
			<takahashi size="28" x="30" color="#666666" width="600" align="left">
				<![CDATA[WSH <font size="-5">(Windows Script Host)</font>は、Microsoft Windowsにおいてスクリプトを実行するソフトウェアである。
				<br/>
				<br/>
				Windows 98以降で標準で利用できる。
				<br/>
				<br/>
				バッチファイルやUnixにおけるシェルスクリプトと似た位置づけの技術である。
				<br/>
				<br/>
				標準ではVBScriptと<font color="#99eeff">JScriptを利用できる</font>。
				]]>
			</takahashi>
		</canvas>

		<takahashi size="80" effect="slide">試してみよう</takahashi>

		<canvas effect="fadeinout">
			<image class="Notepad" x="5" y="5" width="630" height="450"/>
		</canvas>

		<canvas>
			<image class="Notepad" x="5" y="5" width="630" height="450"/>
			<takahashi width="600" x="10" y="70" color="#000000" align="left" size="40" family="_sans">
				WScript.echo("Hello, World!");
			</takahashi>
		</canvas>

		<canvas>
			<image class="Notepad" x="5" y="5" width="630" height="450"/>
			<takahashi width="600" x="10" y="70" color="#000000" align="left" size="40" family="_sans">
				WScript.echo("Hello, World!");<br/>
				<font color="#008000" size="-5">// window.alert("Hello, World!); の<br/>
				// WSHでの書き方</font>
			</takahashi>
		</canvas>

		<canvas>
			<image class="Cmd" x="3" y="1" width="634" height="478"/>
			<takahashi width="600" x="10" y="45" color="#ffffff" align="left" size="30" family="_sans">
				<![CDATA[
					<font color="#999999">C:\&gt;</font> cscript.exe helloworld.js
				]]>
			</takahashi>
		</canvas>

		<canvas>
			<image class="Cmd" x="3" y="1" width="634" height="478"/>
			<takahashi width="600" x="10" y="45" color="#ffffff" align="left" size="30" family="_sans">
				<![CDATA[
					<font color="#999999">C:\&gt; cscript.exe helloworld.js</font><br/>
					Microsoft (R) Windows Script Host Version 5.6<br/>
					Copyright (C) Microsoft Corporation 1996-2001. All rights reserved.<br/>
					<br/>
					Hello world!<br/>
					<br/>
					<font color="#999999">C:\&gt;</font>
				]]>
			</takahashi>
		</canvas>

		<canvas>
			<image class="Cmd" x="3" y="1" width="634" height="478"/>
			<takahashi width="600" x="10" y="45" color="#ffffff" align="left" size="30" family="_sans">
				<![CDATA[
					<font color="#999999">C:\&gt;</font> cscript.exe <font color="#66ccff">/nologo</font> helloworld.js<br/>
					Hello world!<br/>
					<br/>
					<font color="#999999">C:\&gt;</font>
				]]>
			</takahashi>
		</canvas>

		<takahashi size="60" effect="slide">もうちょっと複雑な例</takahashi>

		<canvas>
			<image class="Notepad" x="5" y="5" width="630" height="450"/>
			<takahashi width="600" x="10" y="70" color="#000000" family="_sans" align="left" size="30">
				<![CDATA[
					for(var i = 0; i &lt; 10; i++){<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;WScript.echo(fibonacci(i));<br/>
					}<br/>
					<br/>
					function fibonacci(n){<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;if(n &lt; 2) return n;<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;return fibonacci(n - 1)<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; + fibonacci(n - 2);<br/>
					}
				]]>
			</takahashi>
		</canvas>

		<canvas>
			<image class="Cmd" x="3" y="1" width="634" height="478"/>
			<takahashi width="600" x="10" y="45" color="#ffffff" align="left" size="30" family="_sans">
				<![CDATA[
					<font color="#999999">C:\&gt;</font> cscript.exe /nologo fibonacci.js<br/>
					0<br/>
					1<br/>
					1<br/>
					2<br/>
					3<br/>
					5<br/>
					8<br/>
					13<br/>
					21<br/>
					34<br/>
				]]>
			</takahashi>
		</canvas>


		<takahashi size="80" effect="slide">ファイル操作してみる</takahashi>

		<canvas>
			<image class="Notepad" x="5" y="5" width="630" height="450"/>
			<takahashi width="600" x="10" y="70" color="#000000" family="_sans" align="left" size="30">
				<![CDATA[
					var fso = new ActiveXObject(<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;"Scripting.FileSystemObject");<br/>
					<br/>
					var file = fso.CreateTextFile("c:\\output.txt");<br/>
					file.WriteLine("Hello World!");<br/>
					file.Close();
				]]>
			</takahashi>
		</canvas>

		<canvas>
			<image class="Notepad" x="5" y="5" width="630" height="450"/>
			<takahashi width="600" x="10" y="70" color="#999999" family="_sans" align="left" size="30">
				<![CDATA[
					var fso = <font color="#ff0000">new ActiveXObject(<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;"Scripting.FileSystemObject")</font>;<br/>
					<br/>
					var file = fso.CreateTextFile("c:\\output.txt");<br/>
					file.WriteLine("Hello World!");<br/>
					file.Close();
				]]>
			</takahashi>
		</canvas>

		<takahashi size="40" effect="slide" align="left">
			<![CDATA[
				<font color="#ff0000">ActiveXObject</font> を使えば事実上なんでもできる<br/>
				<font color="#cccccc" size="-5">- ファイル操作<br/>
				- プロセス起動<br/>
				- Excel操作 <font size="-10">(Excel.Application)</font><br/>
				- IE自動化 <font size="-10">(InternetExplorer.Application)</font><br/>
				- ハードウェア情報 <font size="-10">(WMI)</font><br/>
				- etc...</font>
			]]>
		</takahashi>

		<takahashi size="40" effect="fadeinout">
			第１章<br/><font size="80">まとめ</font><br/><br/>
			Windows ユーザーは<br/><font color="#66ccff">WSH</font> を使うべき</takahashi>

		<takahashi size="60" effect="slide">ところで</takahashi>

		<takahashi size="60"><font color="#66ccff">WSH</font> <font size="-10">と</font> <font color="#6666ff">IE</font> <font size="-10">は</font>同じ<br/>JavaScript エンジン</takahashi>

		<takahashi size="80" effect="fadeinout">つまり</takahashi>
		<takahashi size="60" effect="bouncein"><font color="#ff3300">
			prototype.js</font><font size="-10">が</font><br/>
			<font color="#66ccff">WSH</font><font size="-10">で</font>動くはず
		</takahashi>

		<takahashi size="40" effect="cube">第2章<br/><br/><font size="70">WSH<font size="-10">で</font><br/>
		ライブラリ<font size="-10">を</font>使う</font></takahashi>

		<takahashi size="30">外部 JS をインクルードする方法</takahashi>

		<canvas>
			<takahashi width="620" size="50">外部JS： lib.js</takahashi>
			<image class="Notepad" x="5" y="60" width="630" height="450"/>
			<takahashi width="600" x="10" y="120" color="#000000" family="_sans" align="left" size="30">
				<![CDATA[
					function lib() {<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;WScript.echo("I'm lib.js");<br/>
					}
				]]>
			</takahashi>
		</canvas>

		<canvas>
			<takahashi width="620" size="50">main.js</takahashi>
			<image class="Notepad" x="5" y="60" width="630" height="450"/>
			<takahashi width="600" x="10" y="120" color="#000000" family="_sans" align="left" size="30">
				<![CDATA[
					function include(src){<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;return new ActiveXObject(<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"Scripting.FileSystemObject")<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.OpenTextFile(src)<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.ReadAll(); <br/>
					}<br/>
					<br/>
					eval(include('lib.js'));<br/>
					<br/>
					lib();
				]]>
			</takahashi>
		</canvas>

		<canvas>
			<image class="Cmd" x="3" y="1" width="634" height="478"/>
			<takahashi width="600" x="10" y="45" color="#ffffff" align="left" size="30" family="_sans">
				<![CDATA[
					<font color="#999999">C:\&gt;</font> cscript.exe /nologo main.js<br/>I'm lib.js
				]]>
			</takahashi>
		</canvas>

		<takahashi size="60" effect="slide">同じように<br/><font color="#ff3300">prototype.js</font><font size="-10">を</font><br/>インクルードすると...</takahashi>

		<canvas>
			<image class="Cmd" x="3" y="1" width="634" height="478"/>
			<takahashi width="600" x="10" y="45" color="#ffffff" align="left" size="30" family="_sans">
				<![CDATA[
					<font color="#999999">C:\&gt; cscript.exe /nologo main.js<br/>
					c:\main.js(7, 1)</font> Microsoft JScript 実行時エラー: 'document' は宣言されていません。
				]]>
			</takahashi>
		</canvas>

		<canvas>
			<image class="Cmd" x="3" y="1" width="634" height="478"/>
			<takahashi width="600" x="10" y="45" color="#ffffff" align="left" size="30" family="_sans">
				<![CDATA[
					<font color="#999999">C:\&gt; cscript.exe /nologo main.js<br/>
					c:\main.js(7, 1)</font> Microsoft JScript 実行時エラー: <font color="#ff0000">'document' は宣言されていません</font>。
				]]>
			</takahashi>
		</canvas>

		<takahashi size="100" color="#ff0000">'document' は宣言されていません</takahashi>

		<takahashi size="50"><font color="#66ccff">WSH</font><font size="-10">は</font>コマンドライン用<font size="-10">なので</font>...</takahashi>
		<takahashi size="40"><font color="#ff0000">DOMオブジェクト</font><br/><font size="-10">(window・documentなど)</font> <font size="-10">が</font><br/>存在しない...</takahashi>

		<takahashi size="60" effect="bouncein"><font color="#ff3300">prototype.js</font><font size="-20">が</font><br/>使えない!?</takahashi>

		<takahashi size="100" color="#ff0000">いやだ、<br/>無理やり使う</takahashi>

		<takahashi size="30"><font size="80">おまじないを<br/>１行<br/></font><font color="#999999">(prototype.js 1.5 の場合)</font></takahashi>

		<canvas>
			<image class="Notepad" x="5" y="5" width="630" height="450"/>
			<takahashi width="600" x="10" y="65" color="#000000" family="_sans" align="left" size="30">
				<![CDATA[
					function include(src){<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;return new ActiveXObject(<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"Scripting.FileSystemObject")<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.OpenTextFile(src)<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.ReadAll(); <br/>
					}<br/>
					<br/>
					<font color="#ff0000">var document = {}, window = {},<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;navigator = {appVersion: "0.1"};</font><br/>
					eval(include('prototype.js'));<br/>
				]]>
			</takahashi>
		</canvas>

		<takahashi size="100">利用例</takahashi>

		<canvas>
			<image class="Notepad" x="5" y="5" width="630" height="450"/>
			<takahashi width="600" x="10" y="65" color="#000000" family="_sans" align="left" size="30">
				<![CDATA[
					<font color="#008000">// おまじないは省略</font><br/>
					eval(include('prototype.js'));<br/>
					<br/>
					$A([3, 4]).each(function(v){<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;WScript.echo(v);<br/>
					});<br/>
					<font color="#008000">// 3</font><br/>
					<font color="#008000">// 4</font>
				]]>
			</takahashi>
		</canvas>

		<takahashi size="40">
			第２章<br/><font size="80">まとめ</font><br/><br/>
			おまじない<font size="-10">を</font>唱えれば、<br/><font color="#3399ff">WSH</font><font size="-10">でも</font><br/> <font color="#ff3300">prototype.js</font><font size="-10">が</font>使える</takahashi>

		<takahashi size="40" effect="slide">といっても…</takahashi>
		<takahashi size="40" effect="fadeinout">Array や Object を<br/>拡張する機能しか<br/>まともに使えない</takahashi>

		<takahashi size="80" effect="bouncein" color="#ff0000">DOMにアクセス<br/>したらエラー</takahashi>

		<!--<takahashi size="50">そもそも<font color="#ff0000">DOM</font>って何？</takahashi>

		<takahashi size="40"><font color="#ff0000">Document Object Model<br/><font size="-10">(DOM)</font></font> は、<br/>
			<font color="#ffff33">HTML文書</font>や<font color="#ffff33">XML文書</font>を<br/>
			<font color="#3399ff">アプリケーション</font>から<br/>利用するためのAPIである<br/>
			<p align="right"><font size="-20" color="#cccccc">(Wikipedia より)</font></p>
		</takahashi>-->

		<vbox>
			<takahashi size="80" color="#ffff33">HTMLの場合</takahashi>
			<takahashi size="50">DOMオブジェクトがある</takahashi>
			<takahashi size="30" align="left" x="80">
				(例) document.getElementById()<br/>
				　　elem.parentNode
			</takahashi>
		</vbox>

		<image effect="cube" class="DomHtml" width="640" height="480"/>

		<vbox>
			<takahashi size="80" color="#3399ff">WSHの場合</takahashi>
			<takahashi size="50">DOMは未定義</takahashi>
		</vbox>

		<image effect="cube" class="DomQ" width="640" height="480"/>

		<takahashi size="40" effect="cube">第３章<br/><br/><font size="80">おまじない<br/>を改善</font></takahashi>

		<takahashi size="50"><font color="#3399ff">WSH</font>で<br/><font color="#ff0000">DOM</font>を定義してみよう</takahashi>
		<takahashi size="50" effect="bouncein"><font color="#ff0000">dom4winui.js</font>という<br/>ライブラリを作った！</takahashi>

		<image class="DomWin" width="640" height="480"/>

		<takahashi size="40" effect="fadeinout">
			<font color="#ffff33">ウインドウの階層構造</font><font size="-10">を</font><br/>
			<font color="#ff0000">DOMツリー</font><font size="-10">と</font>みなす
		</takahashi>

		<vbox>
			<takahashi size="40" effect="slide">(例) calc.exe</takahashi>
			<image class="Calc" effect="slide"/>
		</vbox>

		<canvas>
			<image class="Calc" width="180" height="146"/>
			<takahashi size="30" family="_sans" align="left" x="210">
				<![CDATA[
					&lt;SciCalc value="電卓"<br/>
					&nbsp;&nbsp;class="calc" style="..." &gt;<br/>
					&nbsp;&nbsp;&lt;Edit value="0" style="..."&gt;<br/>
					&nbsp;&nbsp;&lt;Button value="MC" style="..."&gt;<br/>
					&nbsp;&nbsp;&lt;Button value="MR" style="..."&gt;<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:<br/>
					&lt;/SciCalc&gt;<br/>
				]]>
			</takahashi>
		</canvas>

		<canvas>
			<image class="Calc1" width="180" height="146"/>
			<takahashi size="30" family="_sans" align="left" x="210">
				<![CDATA[
					<font color="#ff3333">&lt;SciCalc value="電卓"<br/>
					&nbsp;&nbsp;class="calc" style="..." &gt;</font><br/>
					&nbsp;&nbsp;&lt;Edit value="0" style="..."&gt;<br/>
					&nbsp;&nbsp;&lt;Button value="MC" style="..."&gt;<br/>
					&nbsp;&nbsp;&lt;Button value="MR" style="..."&gt;<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:<br/>
					<font color="#ff3333">&lt;/SciCalc&gt;</font><br/>
				]]>
			</takahashi>
		</canvas>

		<canvas>
			<image class="Calc2" width="180" height="146"/>
			<takahashi size="30" family="_sans" align="left" x="210">
				<![CDATA[
					&lt;SciCalc value="電卓"<br/>
					&nbsp;&nbsp;class="calc" style="..." &gt;<br/>
					&nbsp;&nbsp;<font color="#ff3333">&lt;Edit value="0" style="..."&gt;</font><br/>
					&nbsp;&nbsp;&lt;Button value="MC" style="..."&gt;<br/>
					&nbsp;&nbsp;&lt;Button value="MR" style="..."&gt;<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:<br/>
					&lt;/SciCalc&gt;<br/>
				]]>
			</takahashi>
		</canvas>

		<canvas>
			<image class="Calc3" width="180" height="146"/>
			<takahashi size="30" family="_sans" align="left" x="210">
				<![CDATA[
					&lt;SciCalc value="電卓"<br/>
					&nbsp;&nbsp;class="calc" style="..." &gt;<br/>
					&nbsp;&nbsp;&lt;Edit value="0" style="..."&gt;<br/>
					<font color="#ff3333">&nbsp;&nbsp;&lt;Button value="MC" style="..."&gt;</font><br/>
					&nbsp;&nbsp;&lt;Button value="MR" style="..."&gt;<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:<br/>
					&lt;/SciCalc&gt;<br/>
				]]>
			</takahashi>
		</canvas>


		<takahashi size="30" effect="slide">
			<![CDATA[
				<font size="100" color="#8080ff">DEMO</font><br/>
				ijs.js + dom4winui.js + jquery.js<br/><br/>
			]]>
		</takahashi>

		<takahashi size="30">
			<![CDATA[
				<font size="100" color="#8080ff">DEMO</font><br/>
				<font color="#ffff33">ijs.js</font> <font color="#808080">+ dom4winui.js + jquery.js</font><br/><br/>
				id:nak2k さん作の WSH 用シェル
			]]>
		</takahashi>

		<takahashi size="30">
			<![CDATA[
				<font size="100" color="#8080ff">DEMO</font><br/>
				<font color="#808080">ijs.js + <font color="#ffff33">dom4winui.js</font> + jquery.js</font><br/><br/>
				私が作った DOM エミュレータ
			]]>
		</takahashi>

		<takahashi size="30">
			<![CDATA[
				<font size="100" color="#8080ff">DEMO</font><br/>
				<font color="#808080">ijs.js + dom4winui.js +</font> <font color="#ffff33">jquery.js</font><br/><br/>
				簡単にDOMを使える有名ライブラリ
			]]>
		</takahashi>

		<canvas>
			<image class="Notepad" x="5" y="5" width="630" height="450"/>
			<takahashi width="600" x="10" y="70" color="#000000" align="left" size="20" family="_sans">
				<![CDATA[
				function include(src){return new ActiveXObject("Scripting.FileSystemObject").OpenTextFile(src).ReadAll();}<br/>
				<br/>
				eval(include('dom4winui.js'));<br/>
				eval(include('jquery.js'));<br/>
				<br/>
				$(".calc")<br/>
				&nbsp;&nbsp;&nbsp;&nbsp;.css("left", 30)<br/>
				&nbsp;&nbsp;&nbsp;&nbsp;.css("top", 30)<br/>
				&nbsp;&nbsp;&nbsp;&nbsp;.val("俺の電卓");<br/>
				$(".calc button:odd").hide();<br/>
				]]>
			</takahashi>
		</canvas>

		<image class="Orecalc1"/>
		<canvas effect="fadeinout" valign="no">
			<image class="Orecalc2" x="30" y="30"/>
		</canvas>

		<canvas>
			<image class="Notepad" x="5" y="5" width="630" height="450"/>
			<takahashi width="600" x="10" y="70" color="#000000" align="left" size="20" family="_sans">
				<![CDATA[
				function include(src){return new ActiveXObject("Scripting.FileSystemObject").OpenTextFile(src).ReadAll();}<br/>
				<br/>
				eval(include('dom4winui.js'));<br/>
				eval(include('jquery.js'));<br/>
				<br/>
				$(".notepad").hide(3000);<br/>
				waitForTimer();<br/>
				]]>
			</takahashi>
		</canvas>

		<NotepadFadeOut/>

		<takahashi size="100">仕組み</takahashi>

		<vbox>
			<takahashi family="_sans" size="30" x="60" align="left">
				var window = this;<br/>
				window.document = new ActiveXObject(<br/>
				　<font>"dom4winui.DomUiDocument"</font>);
			</takahashi>
			<takahashi color="#000000"><br/>C++で実装</takahashi>
		</vbox>

		<vbox>
			<takahashi family="_sans" size="30" color="#999999" x="60" align="left">
				var window = this;<br/>
				window.document = new ActiveXObject(<br/>
				　<font color="#ff0000">"dom4winui.DomUiDocument"</font>);
			</takahashi>
			<takahashi>↑<br/>C++で実装</takahashi>
		</vbox>

		<takahashi size="50">
			ソースコードは<br/>CodeRepos に！<br/>
			<font size="-20" color="#cccccc">root/lang/cplusplus/dom4winui/</font>
		</takahashi>

		<takahashi size="40" effect="slide">
			第３章<br/><font size="80">まとめ</font><br/><br/>
			<font color="#ff0000">dom4winui.js</font>を使えば<br/><font color="#66ccff">WSH</font>で DOM 風に<br/>UIをいじれる</takahashi>

		<takahashi size="40" effect="cube">第4章<br/><br/><font size="80">結論</font></takahashi>

		<takahashi align="left" size="50">
			<![CDATA[
			WSH<font size="-10">は</font>楽しい<br/><br/>

			WSH<font size="-10">で</font>prototype.js<font size="-10">が</font><br/>使える<br/><br/>

			dom4winui.js<font size="-10">を</font>使うとDOM<font size="-10">で</font>UIをいじれる
			]]>
		</takahashi>

		<takahashi size="100" effect="slide">今後の課題<br/>３つ</takahashi>

		<takahashi align="left" size="50">
			<![CDATA[
			1. DOMイベント対応<br/>
			<font color="#999999">→ JSでAutoHotKey</font>
			]]>
		</takahashi>

		<takahashi align="left" size="50">
			<![CDATA[
			2. アプリケーションごと<br/>　 のJS登録<br/>
			<font color="#999999">→ Greasemonkey風</font>
			]]>
		</takahashi>

		<takahashi size="50" align="left">
			3. dom4macui.js<br/>
			<font color="#999999">→ できるの？ 他力本願...</font>
		</takahashi>

		<takahashi size="60">
			ごせいちょう<br/>
			ありがとう<br/>ございました
		</takahashi>
	</>;
	
}
}

