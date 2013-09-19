package
{
import flash.external.ExternalInterface;
import flash.display.*;
import flash.text.*;
import flash.events.*;
import flash.geom.*;
import flash.filters.GlowFilter;
import flash.net.*;

public class Marubiru extends Sprite
{
	public static const DOT:int = 4;
	public static const X_START:int = 596;
	public static const Y_START:int = 442;
	public static const X_END:int = 1278;
	public static const Y_END:int = 556;
	public static const TOP_RADIUS:int = 8; // 上方向の膨らみ
	public static const X_SIZE:int = 150;
	public static const Y_SIZE:int = 18;

	public static const PIPE_URL:String = "http://pipes.yahooapis.com/pipes/pipe.run?_id=cEreGvJi3BG2_zgYxQnzeQ&_render=rss&url=";

	public static var scale:Number = 0.5;

	private var dots:Array;
	private var prevLine:Array;
	private var displayingDots:Array;
	private var candidate:Array;
	private var processingSentence:Array;

	public function Marubiru()
	{
		if(!stage) return;

		stage.scaleMode = "noScale";
		stage.align = "TL";

		initStage();
		addEventListener("enterFrame", enterFrameHandler);

		if(ExternalInterface.available)
		{
			ExternalInterface.addCallback("loadRss", loadRss);
			ExternalInterface.addCallback("setSentence", setSentence);
		}

		// get params
		var params:Object = stage.loaderInfo.parameters;
		scale = params.scale || 0.5;
		var url:String = params.url;
		var q:String = params.q;

		if(url != null)
		{
			loadRss(url);
		}
		else if(q != null)
		{
			setSentence(q);
		}
		else
		{
			candidate.push(traceLetter("ERROR: パラメータが設定されていません"));
		}
	}

	private function initStage():void
	{
		var dotsBox:Sprite = Sprite(addChild(new Sprite()));
		dotsBox.filters = [new GlowFilter(0xcc6600, 0.5, 8 * Marubiru.scale, 8 * Marubiru.scale, 4)];

		dots = [];
		for(var i:int = 0; i < X_SIZE; i++)
		{
			for(var j:int = 0; j < Y_SIZE; j++)
			{
				var cos:Number = 1 - Math.cos(Math.PI * i / (X_SIZE - 1));
				var sin:Number = Math.sin(Math.PI * i / (X_SIZE - 1));
				var diff:Number = sin * TOP_RADIUS;

				var dot:Dot = new Dot(sin);
				dots.push(dot);
				dot.x = X_START + (X_END - X_START) * cos * 0.5;
				dot.y = Y_START + (Y_END - Y_START + diff) * j / (Y_SIZE - 1) - diff;

				dot.x *= scale;
				dot.y *= scale;
				dotsBox.addChild(dot);
				dot.lighting = false;
			}
		}

		initLighting();
	}

	private function initLighting():void
	{
		displayingDots = [];
		prevLine = [];
		processingSentence = [];
		candidate = [];

		for(var i:int = 0; i < X_SIZE * Y_SIZE; i++)
		{
			dots[i].lighting = false;
		}
	}

	private function enterFrameHandler(e:Event):void
	{
		// 表示処理中のドットがなくなったら、candidate から取り出す
		if(processingSentence.length == 0)
		{
			if(candidate.length == 0) return;

			processingSentence = candidate.shift();
			candidate.push(processingSentence.slice()); // 後ろに戻す

			for(var i:int = 0; i < Y_SIZE * Y_SIZE * 2; i++)
			{
				processingSentence.push(false); // 全角2文字空ける
			}
		}

		// 点灯状態を変更するドットのリストを更新する
		for(i = 0; i < Y_SIZE; i++)
		{
			var c:Boolean = processingSentence[i];
			if(prevLine[i] && !c)
			{
				displayingDots.unshift(new DiffDot(X_SIZE, i, false));
			}
			else if(!prevLine[i] && c)
			{
				displayingDots.unshift(new DiffDot(X_SIZE, i, true));
			}
			prevLine[i] = c;
		}
		processingSentence.splice(0, Y_SIZE);

		// 点灯状態を変更する
		var len:int = displayingDots.length;
		for(i = 0; i < len; i++)
		{
			var d:DiffDot = displayingDots[i];
			d.x--;
			if(d.x < 0) break;
			dots[d.x * Y_SIZE + d.y].lighting = d.lighting;
		}
		displayingDots.splice(i);
	}

	public function traceLetter(letter:String):Array
	{
		var fontSize:int = Y_SIZE - 2;
		
		var tf:TextFormat = new TextFormat();
		tf.size = fontSize;

		var text:TextField = new TextField();
		text.defaultTextFormat = tf;
		text.autoSize = "left";
		text.text = letter;

		// We have to use threshold method to binarize, because Mac OS draws antialiased text.
		var bmdtmp:BitmapData = new BitmapData(fontSize * letter.length, Y_SIZE * 1.2, true, 0xffffffff);
		var bitmapdata:BitmapData = bmdtmp.clone();
		bmdtmp.draw(text);
		bitmapdata.threshold(bmdtmp, bmdtmp.rect, new Point(), "<", 0xffdddddd, 0xff000000);

		// getBounds
		var rect:Rectangle = bitmapdata.getColorBoundsRect(0xffffff, 0xffffff);

		var ret:Array = [];
		for(var i:int = rect.x * Y_SIZE; i < rect.right * Y_SIZE; i++)
		{
			ret.push(bitmapdata.getPixel(i / Y_SIZE, i % Y_SIZE + 2) == 0x000000);
		}

		bmdtmp.dispose();
		return ret;
	}

	// Y!Pipes 経由で RSS をロードする
	public function loadRss(url:String):void
	{
		setSentence("LOADING...");

		var requestUrl:String = PIPE_URL + escape(url);
		var req:URLRequest = new URLRequest(requestUrl);
		var loader:URLLoader = new URLLoader(req);

		loader.addEventListener(Event.COMPLETE, function(event:Event):void
		{
			var rss:XML = XML(loader.data);
			var items:XMLList = rss..item;

			initLighting();
			if(items.length() == 0)
			{
				candidate.push(traceLetter("RSSを取得できませんでした"));
				return;
			}

			for each(var item:XML in items)
			{
				candidate.push(traceLetter(item.title.toString()));
			}
		});
		loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:Event):void
		{
			initLighting();
			candidate.push(traceLetter("RSSを取得できませんでした"));
		});
	}

	// 文字列を設定する
	public function setSentence(str:String):void
	{
		initLighting();
		candidate.push(traceLetter(str));
	}
}
}

import flash.display.*;
import mx.utils.ColorUtil;

internal class DiffDot
{
	public var x:int;
	public var y:int;
	public var lighting:Boolean;

	public function DiffDot(x:int, y:int, lighting:Boolean)
	{
		this.x = x;
		this.y = y;
		this.lighting = lighting;
	}
}

internal class Dot extends Shape
{
	// 親
	private var cachedParent:Sprite;

	// 点の場所 (0～1)。1が一番手前。
	private var pos:Number;

	// 点の色
	private var color:uint;

	// 点の半径
	private var radius:Number;

	// 点灯しているかどうか
	private var _lighting:Boolean = false;
	public function get lighting():Boolean
	{
		return _lighting;
	}

	public function set lighting(value:Boolean):void
	{
		if(value != _lighting)
		{
			_lighting = value;

			if(_lighting)
			{
				graphics.beginFill(_lighting ? color : 0x000000);
				graphics.drawCircle(0, 0, radius * Marubiru.scale);
				graphics.endFill();
			}
			else
			{
				graphics.clear();
			}
		}
	}

	// 点
	public function Dot(pos:Number)
	{
		this.pos = pos;
		color = ColorUtil.adjustBrightness2(0xff9900, (pos - 1) * 90);
		radius = 2 * (1 + 0.2 * pos);
		_lighting = true;
	}
}