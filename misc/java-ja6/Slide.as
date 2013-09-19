/**
 * Presentation at java-ja 6th study meeting
 * http://java-ja.yoshiori.org/index.php?%E7%AC%AC%E5%85%AD%E5%9B%9E
 *
 * requires as3Query and Tweener
 */
package {

import flash.filters.BlurFilter;
import flash.display.*;
import flash.text.*; TextField;
import flash.events.*;
import flash.ui.Keyboard;
import flash.ui.Mouse;
import flash.utils.getDefinitionByName;
import flash.net.SharedObject;
import caurina.transitions.Tweener; Tweener;
import com.nitoyon.as3query.*;

[SWF(backgroundColor="#000000", width=640, height=480)]
public class Slide extends Sprite {
	private var typingNumber:int = -1;
	private var curPage:int = 0;
	private var so:SharedObject;

	[Embed(source="assets/left.png")]
	private var LeftArrow:Class;
	[Embed(source="assets/right.png")]
	private var RightArrow:Class;
	private var rightCursor:Bitmap;
	private var leftCursor:Bitmap;

	private const WIDTH:int = 640;
	private const HEIGHT:int = 480;

	public function Slide() {
		$(stage)
			.keydown(keydownHandler)
			.mousemove(mouseMoveHandler)
			.bind("mouseLeave", function(event:Event):void{
				leftCursor.visible = rightCursor.visible = false;
			})
			.click(clickHandler);

		stage.addChild(rightCursor = new RightArrow());
		stage.addChild(leftCursor = new LeftArrow());
		rightCursor.visible = leftCursor.visible = false;

		curPage = -1;
		var page:int = 0;
		so = SharedObject.getLocal("slide-java");
		page = so.data.index;

		show(page);
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
				(event.shiftKey ? prev() : next());
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
		return x < WIDTH / 3 ? -1 : x > WIDTH / 3 * 2 ? 1 : 0;
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
		s.x = event.stageX - 16;
		s.y = event.stageY - 16;
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
		$("> *[x != 0]", this).remove();

		// 前面のオブジェクトをスライド
		$(this).children()
			.addTween({
				x : WIDTH * (next ? -1.5 : 1.5),
				time: 1.5,
				onComplete: function():void{
					$(this).remove();
				}
			});

		// 新しいページを作成
		var d:DisplayObject = createParts(page),
			d2:DisplayObject = createParts(page);
		if(!d) return;

		var y:Number = (HEIGHT - d.height) / 2;
		$(d2)
			.attr({
				y: y,
				alpha: 1,
				filters: [new BlurFilter(100, 100)]
			})
			.addTween({
				alpha: .6,
				_blur_blurX: 16,
				_blur_blurY: 16,
				delay: 0.15,
				time: 1
			})
			.appendTo(this);
		$(d)
			.attr({
				y: y
			})
			.appendTo(this);
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
				fontFamily: page.@family.toString() != "" ? page.@family : "_sans"
			})
			.attr({
				selectable: false,
				multiline: true,
				wordWrap: true,
				width: WIDTH,
				condenseWhite: true,
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

	[Embed(source="assets/techni.jpg")]
	private var Techni:Class;

	private static var slide:XMLList = <>
		<!--title-->
		<takahashi size="100">
			<![CDATA[<font color="#ff0000">ActionScript</font> for <font color="#ff9900">JAVA</font>er]]>
		</takahashi>

		<takahashi size="80">自己紹介</takahashi>
		<vbox>
			<takahashi size="50">にとよんです</takahashi>
			<image class="Techni"/>
			<takahashi size="30">http://tech.nitoyon.com/</takahashi>
		</vbox>
		<takahashi size="50">
			<![CDATA[<font size="-20">好評連載中!</font><br>
				プログラマ<font size="-10">のための</font><br>
				Flash遊<font size="-10">び</font>方入門</font><br>
				<font size="-20">http://gihyo.jp/</font>]]>
		</takahashi>
		<takahashi size="60"><font color="#ff9900">Java</font> の人に<br/><font color="#ff0000">ActionScript</font> を<br/>お薦めする<br/>プレゼンをします。</takahashi>
		<takahashi size="60"><font size="-20">ちなみに</font><br/><font color="#ff9900">Java</font> は 1.2 を<br/>触ったことが<br/>あります!!!</takahashi>

		<takahashi size="50" align="left">
			<![CDATA[
				<font color="#cccccc">Agenda</font><br>
				1. ActionScript の歴史<br>
				2. HelloWorld.as<br>
				3. abc, asc and AVM<br>
				4. ライブラリとかツールとか<br>
				5. まとめ
			]]>
		</takahashi>

		<takahashi size="100">1. ActionScript の歴史</takahashi>

		<takahashi size="50" color="#cccccc">もともとは Flash に動きをつけるための簡単なスクリプト</takahashi>
		<takahashi size="30" align="left" family="mono"><![CDATA[
on(rollOver) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;gotoAndPlay(20);<br>
}
		]]>
		</takahashi>

		<takahashi size="50" color="#dddddd"><![CDATA[Flash のバージョンが<br>上がるにつれて、<br>プログラミング言語<br>っぽく進化。]]></takahashi>

		<takahashi size="80" color="#ffffff">
			<![CDATA[ActionScript 1.0<br><font color="#dddddd" size="-30">ECMAScript 3 準拠</font>]]>
		</takahashi>
		<takahashi size="80" color="#ffffff">
			<![CDATA[ActionScript 2.0<br>
			<font color="#dddddd" size="-30">オブジェクト指向</font><br>
			<font color="#dddddd" size="-40">(ECMAScript 4 先行実装)</font>]]>
		</takahashi>
		<takahashi size="50" color="#ffffff">
			<![CDATA[<font size="+30">ActionScript 3.0</font><br>
			<font color="#dddddd">コマンドライン コンパイラ登場<br>
			よりOOPらしく書けるように!<br/>
			<font size="-20">(E4X, 実行速度改善, クラス整備...etc)</font>
			</font>]]>
		</takahashi>

		<takahashi size="130">2. HelloWorld.as</takahashi>
		<takahashi size="20" align="left" family="mono"><![CDATA[
<font color="#99ff99">// HelloWorld.as</font><br>
package {<br>
&nbsp;&nbsp;&nbsp;&nbsp;import flash.display.*;<br>
&nbsp;&nbsp;&nbsp;&nbsp;import flash.text.*;<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;public class HelloWorld extends Sprite{<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;public function HelloWorld(){<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;var tf:TextField = new TextField();<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;tf.text = "Hello World!";<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;addChild(tf);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>
&nbsp;&nbsp;&nbsp;&nbsp;}<br>
}
]]></takahashi>

		<takahashi size="80" color="#ff9900">Java!?</takahashi>

		<takahashi size="20" align="left" family="mono"><![CDATA[
<font color="#99ff99">// DrawCircle.as</font><br>
package {<br>
&nbsp;&nbsp;&nbsp;&nbsp;import flash.display.*;<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;public class DrawCircle extends Sprite{<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;public function DrawCircle(){<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;graphics.beginFill(0xff0000);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;graphics.drawCircle(10, 10, 5);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;graphics.endFill();<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>
&nbsp;&nbsp;&nbsp;&nbsp;}<br>
}
]]></takahashi>

		<takahashi size="120" color="#ff9900">Java!?</takahashi>
		<takahashi size="80"><![CDATA[オブジェクト指向は<br><font color="#ff9900">Java</font> 風]]></takahashi>
		<takahashi size="80"><![CDATA[クラス群は<br><font color="#ffff00">JavaScript</font> 風]]></takahashi>

		<takahashi size="180">3. abc, asc and AVM</takahashi>

		<takahashi size="80" align="left">
			<![CDATA[
				<font color="#ff0000">ActionScript</font><br>
				<br>
				<br><br>
			]]>
		</takahashi>

		<takahashi size="80" align="left">
			<![CDATA[
				<font color="#ff0000">ActionScript</font><br>
				&nbsp;&nbsp;<font color="#6699cc">↓</font><font color="#cc99ff" size="-40">コンパイル</font><br>
				SWF<br>
				<br>
			]]>
		</takahashi>

		<takahashi size="80" align="left">
			<![CDATA[
				<font color="#ff0000">ActionScript</font><br>
				&nbsp;&nbsp;<font color="#6699cc">↓</font><font color="#cc99ff" size="-40">コンパイル</font><br>
				SWF<br>
				&nbsp;&nbsp;<font color="#6699cc">↑</font><font color="#cc99ff" size="-40">再生</font><br>
				<font color="#cccccc">Flash Player</font>
			]]>
		</takahashi>

		<takahashi size="120">
			<![CDATA[<font color="#cc99ff">コンパイラ</font>を<br>もうちょっと詳しく]]>
		</takahashi>

		<takahashi size="80" align="left">
			<![CDATA[
				<font color="#ff0000">ActionScript</font><br>
				&nbsp;&nbsp;<font color="#6699cc">↓</font><br>
				&nbsp;&nbsp;<font color="#6699cc">↓</font><br>
				&nbsp;&nbsp;<font color="#6699cc">↓</font><br>
				SWF
			]]>
		</takahashi>

		<takahashi size="80" align="left">
			<![CDATA[
				<font color="#ff0000">ActionScript</font><br>
				&nbsp;&nbsp;<font color="#6699cc">↓</font><br>
				<font color="#88ff88">ABC</font><br>
				&nbsp;&nbsp;<font color="#6699cc">↓</font><br>
				SWF
			]]>
		</takahashi>

		<takahashi size="80" align="left">
			<![CDATA[
				<font color="#ff0000">ActionScript</font><br>
				&nbsp;&nbsp;<font color="#6699cc">↓</font><br>
				<font color="#88ff88">ABC</font> <font size="30">(ActionScript ByteCode)</font><br>
				&nbsp;&nbsp;<font color="#6699cc">↓</font><br>
				SWF
			]]>
		</takahashi>

		<takahashi size="80" align="left">
			<![CDATA[
				<font color="#ff0000">ActionScript</font><br>
				&nbsp;&nbsp;<font color="#6699cc">↓</font><font color="#cc99ff" size="-40">Compiled by asc.jar</font><br>
				<font color="#88ff88">ABC</font> <font size="30">(ActionScript ByteCode)</font><br>
				&nbsp;&nbsp;<font color="#6699cc">↓</font><font color="#cc99ff" size="-40">Linked by mxmlc.jar</font><br>
				SWF
			]]>
		</takahashi>

		<takahashi size="60">
			<![CDATA[
				<font color="#cc99ff">asc.jar</font><font size="-15">と</font>
				<font color="#cc99ff">mxmlc.jar</font><font size="-15">は、</font><br>
				オープンソース！
			]]>
		</takahashi>

		<takahashi size="80">
			<![CDATA[<font color="#cc99ff">Flash Player</font>を<br>もうちょっと詳しく]]>
		</takahashi>

		<takahashi size="60" align="left">
			<![CDATA[
			SWF の構成要素<br>
			<li>図形
			<li>リソース <font size="-40">(画像・フォント・音声...)</font>
			<li>ABC
			<li>その他いろいろ
			]]>
		</takahashi>

		<takahashi size="60" align="left">
			<![CDATA[
			SWF の構成要素<br>
			<li>図形
			<li>リソース <font size="-40">(画像・フォント・音声...)</font>
			<li><font color="#88ff88">ABC</font>
			<li>その他いろいろ
			]]>
		</takahashi>

		<takahashi size="60" align="left">
			<![CDATA[
			SWF の構成要素<br>
			<li>図形
			<li>リソース <font size="-40">(画像・フォント・音声...)</font>
			<li><font color="#88ff88">ABC</font> <font color="#6699cc">←</font><font color="#cc99ff">AVM2 が実行</font>
			<li>その他いろいろ
			]]>
		</takahashi>

		<takahashi size="80">
			<![CDATA[
				<font color="#cc99ff">AVM2</font><font size="-15">のコアは、</font><br>
				オープンソース！
			]]>
		</takahashi>

		<takahashi size="80">Tamarin<br/>プロジェクト</takahashi>

		<takahashi size="60">
			<![CDATA[
				Firefox に統合予定<br><font size="-20">(Firefox4 で??)</font>
			]]>
		</takahashi>

		<takahashi size="80">
			<![CDATA[
				Firefox 4 の<br/>JavaScript 2.0 <br/>実行エンジン<br/>になる <font size="-20">(らしい)</font>
			]]>
		</takahashi>

		<takahashi size="60">
			<![CDATA[
				Flash Player は<br/>OSS 化の予定なし<br/><br/>
				<font size="-30">Adobe は Flash Player もどきの<br/>作成を禁じている</font>
			]]>
		</takahashi>

		<takahashi size="110">4. ライブラリとかツールとか</takahashi>

		<takahashi size="100">
			<![CDATA[
				デザイナ向けからプログラマ向けまで
			]]>
		</takahashi>

		<takahashi size="80">有名どころ<br/>ライブラリ</takahashi>

		<takahashi size="60" align="left">
			<![CDATA[
				<li>PV3D <font size="-20">(3D)</font>
				<li>Box2dFlashAs3 <font size="-20">(物理エンジン)</font>
				<li>Tweener <font size="-20">(アニメーション)</font>
			]]>
		</takahashi>

		<takahashi size="120">Flex<br/><font size="-80">(Adobe 製の OSS)</font></takahashi>
		<takahashi size="80">RIA 用<br/>フレームワーク<br/><font size="-40">swing みたいなもん(!?)</font></takahashi>
		<takahashi size="60" align="left"><li>豊富なGUIコンポーネント</li><li>XML で配置</li><li>Binding</li></takahashi>

		<takahashi size="80">BlazeDS<br/><font size="-20">(Adobe 製の OSS)</font></takahashi>
		<takahashi size="80">サーバー側の<br/><font color="#ff9900">Java</font> ライブラリ</takahashi>
		<takahashi size="60">クライアントと<br/>サーバーで<br/>オブジェクトを<br/>生でやり取り</takahashi>
		<takahashi size="60" align="left"><li>over HTTP</li><li>push 配信サポート <font size="-30">(commet みたいな)</font></li></takahashi>

		<takahashi size="80">S2Flex<br/><font size="-20">Seasar のメソッドを Flex から呼ぶ</font></takahashi>

		<takahashi size="120">Flex Builder</takahashi>

		<takahashi size="60"><font size="+30">IDE</font><br/>Eclipse プラグイン <font size="-20">(有償)</font></takahashi>
		<takahashi size="40">学生はタダ(らしい)</takahashi>

		<takahashi size="130">5. まとめ</takahashi>

		<takahashi size="80">AS/Flex は <br/><font color="#ff9900">Java</font> な人にも<br/>オススメ</takahashi>
		<takahashi size="60">実際、Flex 勉強会の参加者は Java 経験者が多い</takahashi>
		<takahashi size="60">クライアント側は Flex、サーバー側は <font color="#ff9900">Java</font><br/>とか。</takahashi>

		<takahashi size="30">ご清聴ありがとうございました</takahashi>
	</>;
}
}