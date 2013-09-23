/**
 * Presentation at Silverlight study meeting #2 at Osaka (2008/5/16)
 * http://www.silverlightsquare.com/page_1208178913506.html
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
import flash.net.SharedObject;
import caurina.transitions.Tweener;
import com.nitoyon.as3query.*;
import five3D.display.*;

[SWF(backgroundColor="#000000", width=640, height=480)]
public class Slide extends Sprite {
	private var typingNumber:int = -1;
	private var so:SharedObject;

	[Embed(source="assets/left.png")]
	private var LeftArrow:Class;
	[Embed(source="assets/right.png")]
	private var RightArrow:Class;
	private var rightCursor:Bitmap;
	private var leftCursor:Bitmap;

	private var curPage:int = 0;
	private var curPageSprite:Sprite;

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
		so = SharedObject.getLocal("silverlight_kakomu2");
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
		while(numChildren) removeChildAt(0);

		// アニメーション後の位置に強制表示
		if(curPageSprite){
			curPageSprite.x = curPageSprite.y = 0;
			addChild(curPageSprite);
		}

		// 新しいページを作成
		var d:DisplayObject = createParts(page),
			d2:DisplayObject = createParts(page);
		d.filters = [new BlurFilter(10, 10)];
		d.y = d2.y = (HEIGHT - d.height) / 2;
		var newPage:Sprite = new Sprite();
		newPage.addChild(d);
		newPage.addChild(d2);

		// effect を決定
		var effect:String = (next ? page.@effect.toString() : slide[curPage].@effect.toString());

		switch(effect){
			case "cube":		moveCube(curPageSprite, newPage, next); break;
			case "slide":		moveSlide(curPageSprite, newPage, next); break;
			case "fadeinout":	moveFadeInOut(curPageSprite, newPage, next); break;
			default:			moveNormal(curPageSprite, newPage, next); break;
		}
		curPageSprite = newPage;
	}

	private function moveNormal(cur:DisplayObject, newPage:DisplayObject, next:Boolean):void{
		if(cur && cur.parent){
			cur.parent.removeChild(cur);
		}

		addChild(newPage);
	}

	private function moveFadeInOut(cur:DisplayObject, newPage:DisplayObject, next:Boolean):void{
        var bmd1:BitmapData = new BitmapData(WIDTH, HEIGHT, true, 0xff000000);
        var bmd2:BitmapData = new BitmapData(WIDTH, HEIGHT, true, 0xff000000);
		if(cur) bmd1.draw(cur);
        bmd2.draw(newPage);

		var bmp1:Bitmap = new Bitmap(bmd1);
		var bmp2:Bitmap = new Bitmap(bmd2);

		addChild(bmp1);
		if(cur && cur.parent){
			cur.parent.removeChild(cur);
		}
		Tweener.addTween(bmp1, {
			alpha: 0,
			time: .8
		});

		bmp2.alpha = 0;
		addChild(bmp2);
		Tweener.addTween(bmp2, {
			alpha: 1,
			time: .8,
			onComplete: function():void{
                if(bmp2.parent){
					removeChild(bmp1);
					removeChild(bmp2);
                	addChild(newPage);
                }
                bmd1.dispose();
                bmd2.dispose();
            }
		});
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
		addChild(newPage);
		Tweener.addTween(newPage, {
			x : 0,
			time: .8
		});
	}

    private function moveCube(cur:DisplayObject, newPage:DisplayObject, next:Boolean):void {
        var scene:Scene3D = new Scene3D();
        scene.x = WIDTH / 2;
        scene.y = HEIGHT / 2;
        addChild(scene);

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

		if(cur) removeChild(cur);
		box.rotationY = next ? 0 : 90;
        Tweener.addTween(box, {
            time: .8,
            rotationY: next ? 90 : 0,
            transition: "easeInOutCubic",
            onUpdate: function():void{
                box.setChildIndex(Math.abs(box.rotationY) > 45 ? img1 : img2, 0);
            },
            onComplete: function():void{
                if(scene.parent){
					scene.parent.removeChild(scene);
                	addChild(newPage);
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
	[Embed(source="assets/vc.gif")]
	private var Vc:Class;
	[Embed(source="assets/mb.gif")]
	private var Mb:Class;
	[Embed(source="assets/racing.gif")]
	private var Racing:Class;

	private static var slide:XMLList = <>
		<!--title-->
		<takahashi size="100">
			<![CDATA[<font color="#6666ff">Silverlight</font> と <font color="#ff6666">Flash</font>をつなぐ]]>
		</takahashi>

		<takahashi size="50" align="left" effect="cube">
			<![CDATA[
				<font color="#cccccc">Agenda</font><br>
				1. 自己紹介<br>
				2. Silverlight 雑感<br>
				3. Flash とつなぐ<br>
				4. まとめ
			]]>
		</takahashi>

		<takahashi size="80" effect="cube">1. 自己紹介</takahashi>
		<vbox effect="slide">
			<takahashi size="50">にとよんです</takahashi>
			<image class="Techni"/>
			<takahashi size="30">http://tech.nitoyon.com/</takahashi>
		</vbox>

		<takahashi size="50" effect="slide">
			<![CDATA[<font size="-20">連載してました</font><br>
				プログラマ<font size="-10">のための</font><br>
				Flash遊<font size="-10">び</font>方入門</font><br>
				<font size="-20">http://gihyo.jp/</font>]]>
		</takahashi>

		<takahashi size="60" effect="slide">もともと<br/>Windows プログラマ</takahashi>

		<vbox effect="slide">
			<takahashi size="50">Visual C++ と Win32 API</takahashi>
			<image class="Vc"/>
			<takahashi size="30">VC++の使い方</takahashi>
		</vbox>

		<vbox effect="slide">
			<takahashi size="60">C# 1.1 を少々</takahashi>
			<image class="Mb"/>
			<takahashi size="30">mixiブラウザ(仮)</takahashi>
		</vbox>

		<vbox effect="slide">
			<takahashi size="60">JavaScript を少々</takahashi>
			<image class="Racing"/>
			<takahashi size="30">Google Mapsでレーシング</takahashi>
		</vbox>

		<takahashi size="60" effect="slide">ActionScript/Flex を<br/>１年半</takahashi>

		<takahashi size="100" effect="slide">Silverlight 歴<br/><font size="+30">１日</font></takahashi>

		<takahashi size="80" effect="slide">よろしく<br/>おねがいします</takahashi>

		<takahashi size="120" effect="cube">2. Silverlight 雑感</takahashi>
		<takahashi size="60" effect="slide">というか、はまったところ</takahashi>
		<takahashi size="80" effect="fadeinout">言い換えると</takahashi>
		<takahashi size="60" effect="fadeinout">逆質問タイム</takahashi>

		<takahashi size="60" effect="fadeinout">CHM のサンプルが動かなかった...</takahashi>
		<takahashi size="60" effect="fadeinout">XAML のサンプル<br/>ばっかり...</takahashi>
		<takahashi size="60" effect="fadeinout">UserControl の中に<br/>タグを複数書いたら<br/>動かない</takahashi>
		<takahashi size="50" effect="fadeinout">C#、VB な開発と<br/>JS, Ruby, Python 開発の<br/>関係が分からない</takahashi>

		<takahashi size="120" effect="slide">気を取り直して</takahashi>

		<takahashi size="120" effect="cube">3. Flash と<br/>つなぐ</takahashi>

		<takahashi size="50" effect="fadeinout">直接は繋がらないので<br/>間に JavaScript を挟む</takahashi>

		<takahashi size="80" effect="fadeinout">Silverlight<br/>｜<br/>JS<br/>｜<br/>Flash</takahashi>

		<takahashi size="120" effect="fadeinout">Silverlight から Flash を呼ぶ</takahashi>
		<takahashi size="80">Silverlight<br/>↓<br/>JS<br/>↓<br/>Flash</takahashi>

		<takahashi size="80">Silverlight<br/>↓<br/>JS<br/>↓<br/><font color="#ffff00">Flash</font></takahashi>
		<takahashi size="60" family="mono" align="left"><![CDATA[ExternalInterface<br/>&nbsp;&nbsp;.addCallback(<br/>&nbsp;&nbsp;&nbsp;&nbsp;"change", <br/>&nbsp;&nbsp;&nbsp;&nbsp;change);]]></takahashi>

		<takahashi size="80">Silverlight<br/>↓<br/><font color="#ffff00">JS<br/>↓<br/>Flash</font></takahashi>
		<takahashi size="40" family="mono" align="left">
<![CDATA[function clicked(){<br/>
&nbsp;&nbsp;document<br/>
&nbsp;&nbsp;&nbsp;&nbsp;.getElementById("swf")<br/>
&nbsp;&nbsp;&nbsp;&nbsp;.change();<br/>
}]]></takahashi>

		<takahashi size="80"><font color="#ffff00">Silverlight<br/>↓<br/>JS<br/></font>↓<br/>Flash</takahashi>
		<takahashi size="60" family="mono"><![CDATA[HtmlPage.Window.<br/>Invoke("change");]]></takahashi>

		<!--Flash -> SL -->
		<takahashi size="120" effect="cube">Flash から Silverlight を呼ぶ</takahashi>
		<takahashi size="80">Silverlight<br/>↑<br/>JS<br/>↑<br/>Flash</takahashi>

		<takahashi size="80"><font color="#ffff00">Silverlight</font><br/>↑<br/>JS<br/>↑<br/>Flash</takahashi>
		<takahashi size="35" family="mono" align="left"><![CDATA[HTMLPage<br/>.RegisterScriptableObject()]]></takahashi>

		<takahashi size="60">外に出すオブジェクトは<br/><font color="#ff8080">[ScriptableMember()]</font> を<br/>持ってないといけない(?)</takahashi>
		<takahashi size="55">C# と VB のサンプルしか<br/>なくて分からない</takahashi>
		<takahashi size="55">Managed code only???</takahashi>

		<takahashi size="120" effect="cube">4. まとめ</takahashi>
		<takahashi size="60">Flash と Silverlight を組み合わせられた</takahashi>
		<takahashi size="60">お互いに足りないものをおぎあえる！</takahashi>
		<takahashi size="60">でも、Silverlight の全容がまだ不明...</takahashi>
		<takahashi size="120">色々教えてください！</takahashi>


		<takahashi size="60">ご清聴ありがとうございました</takahashi>

	</>;
	
}
}