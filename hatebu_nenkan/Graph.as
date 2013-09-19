package{
	import flash.display.*;
	import flash.text.*;
	import flash.geom.Point;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.DisplayShortcuts;

	[SWF(backgroundColor="#ffffff")]
	public class Graph extends Sprite{
		public static const MAX_RANK:int = 30;
		public static const WIDTH:int = 400;
		public static const HEIGHT:int = 200;
		public static const MARGIN_T:int = 10;
		public static const MARGIN_B:int = 20;
		public static const MARGIN_X:int = 40;
		public static const LINE_COLOR:int = 0xff0099;

		private const NORMAL_GRID_COLOR:int = 0xf9f9f9;
		private const BOLD_GRID_COLOR:int = 0xaaaaaa;

		private var rankData:Array;
		private var xScale:Number;
		private var yScale:Number;

		[Embed(source='アニトＬ-教漢.TTF', fontName='anito', unicodeRange='U+0020,U+0028-U+0039,U+30AF,U+30E9,U+30F3,U+5916,U+4F4D,U+5E74,U+6708')]
		private var font:Class;

		public function Graph(){
			DisplayShortcuts.init();

			var rank:Object = loaderInfo.parameters.rank;
			rank = rank || "-1,2,3,4,3,3,3,2,2,2,2,3,2,2,4,6,6,4,6,14,7,11,18,12,12,19,9,10,12,17,24,18,10,3,8,24,12,10,6,7,11,7,5,14,29,18";
			if(!rank){
				var t:TextField = new TextField();
				t.text = "invalid parameters";
				addChild(t);
				return;
			}
			stage.align = "TL";
			stage.scaleMode = "noScale";

			rankData = rank.split(',');
			for(var i:int = 0; i < rankData.length; i++){
				rankData[i] = parseInt(rankData[i]);
			}

			draw();
		}

		private function draw():void{
			xScale = (WIDTH  - MARGIN_X) / rankData.length;
			yScale = (HEIGHT - MARGIN_T - MARGIN_B) / MAX_RANK;

			var points:Array = [];

			drawGrid();
			drawPoints(points);
			addChild(Popup.getInstance());
			Popup.getInstance().hide();
		}

		private function drawGrid():void{
			var text:TextField;
			var tf:TextFormat = new TextFormat();
			tf.align = "right";

			// x
			for(var i:int = 0; i < rankData.length; i++){
				graphics.lineStyle(1, 0xf9f9f9);
				graphics.moveTo(xScale * i + MARGIN_X, MARGIN_T);
				graphics.lineTo(xScale * i + MARGIN_X, HEIGHT);
			}

			// y axis
			for(i = 0; i <= MAX_RANK; i++){
				var bold:Boolean = (i == 0 || i % 10 == 9);
				graphics.lineStyle(1, (bold ? BOLD_GRID_COLOR : NORMAL_GRID_COLOR));
				graphics.moveTo(MARGIN_X, yScale * i + MARGIN_T);
				graphics.lineTo(WIDTH, yScale * i + MARGIN_T);

				// y label
				if(bold){
					text = createTextField((i + 1).toString() + "位", tf);
					text.defaultTextFormat = tf;
					text.width = MARGIN_X - 2;
					text.y = yScale * i - 9 + MARGIN_T;
					addChild(text);
				}
			}

			// year
			var year:int = 2005;
			tf.align = "center";

			graphics.lineStyle(1, BOLD_GRID_COLOR);
			graphics.moveTo(MARGIN_X, MARGIN_T);
			graphics.lineTo(MARGIN_X, HEIGHT - MARGIN_B);

			text = createTextField(year.toString() + "年", tf);
			text.x = MARGIN_X;
			text.y = HEIGHT - MARGIN_B;
			text.defaultTextFormat = tf;
			text.width = xScale * 11;
			addChild(text);

			for(i = 11; i < rankData.length; i += 12){
				graphics.lineStyle(1, BOLD_GRID_COLOR);
				graphics.moveTo(xScale * i + MARGIN_X, MARGIN_T);
				graphics.lineTo(xScale * i + MARGIN_X, HEIGHT - MARGIN_B);

				year++;
				text = createTextField(year.toString() + "年", tf);
				text.x = xScale * i + MARGIN_X;
				text.y = HEIGHT - MARGIN_B;
				text.width = Math.min(rankData.length - i, 12) * xScale;
				addChild(text);
			}
		}

		public static function createTextField(text:String, tf:TextFormat = null):TextField{
			if(!tf) tf = new TextFormat();
			tf.font = "anito";

			var t:TextField = new TextField();
			t.defaultTextFormat = tf;
			t.text = text;
			t.selectable = false;
			t.embedFonts = true;
			return t;
		}

		private function drawPoints(points:Array):void{
			var line:GraphLine = new GraphLine(rankData);
			addChild(line);
		}
	}
}


import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.text.TextField;
import flash.utils.setInterval;
import flash.utils.setTimeout;
import flash.external.ExternalInterface;
import caurina.transitions.Tweener;

class GraphLine extends Sprite{
	private var rankData:Array;

	private var points:Array;
	private var a:Array;
	private var b:Array;
	private var c:Array;
	private var d:Array;
	private var w:Array;

	private var xScale:Number;
	private var yScale:Number;

	private var t:int;
	private const N:int = 5;

	public function GraphLine(rankData:Array){
		this.rankData = rankData;
		setTimeout(draw, 0);

		var m:Sprite = new Sprite();
		m.graphics.beginFill(0);
		m.graphics.drawRect(0, 0, Graph.WIDTH, Graph.HEIGHT - Graph.MARGIN_B);
		m.graphics.endFill();
		addChild(m);
		mask = m;
	}

	private function draw():void{
		calc();

		t = 0;
		graphics.lineStyle(2, Graph.LINE_COLOR);
		graphics.moveTo(Graph.MARGIN_X, points[0]);
		setTimeout(drawLine, 0);
	}

	private function calc():void{
		xScale = (Graph.WIDTH  - Graph.MARGIN_X) / rankData.length;
		yScale = (Graph.HEIGHT - Graph.MARGIN_T - Graph.MARGIN_B) / Graph.MAX_RANK;

		points = [];
		for(var i:int; i < rankData.length; i++){
			var rank:int = rankData[i];
			var y:int = (rank != -1 ? rank - 1 : Graph.MAX_RANK + 1) * yScale + Graph.MARGIN_T;
			points.push(y);
		}

		// スプライン曲線を計算
		// http://www5d.biglobe.ne.jp/~stssk/maze/spline.html
		a = new Array(points.length);
		b = new Array(points.length);
		c = new Array(points.length);
		d = new Array(points.length);
		w = new Array(points.length);

		var n:int = points.length - 1;
		for(i = 0; i <= n; i++){
			a[i] = points[i];
		}
		c[0] = c[n] = 0;
		for(i = 1; i < n; i++){
			c[i] = 3 * (a[i - 1] - 2 * a[i] + a[i + 1]);
		}
		w[0] = 0;
		for(i = 1; i < n; i++){
			w[i] = 1 / (4 - w[i - 1]);
			c[i] = (c[i] - c[i - 1]) * w[i];
		}
		for(i = n - 1; i > 0; i--){
			c[i] = c[i] - c[i + 1] * w[i];
		}
		b[n] = d[n] = 0;
		for(i = 0; i < n; i++){
			d[i] = (c[i + 1] - c[i]) / 3;
			b[i] = a[i + 1] - a[i] - c[i] - d[i];
		}
	}

	private function drawLine():void{
		for(var j:int = 0; j < 2; j++){
			var i:int = Math.floor(t / N);
			if(i >= points.length) return;

			var x0:Number = (t - i * N) / N;
			var yy:Number = a[i] + (b[i] + (c[i] + d[i] * x0) * x0) * x0;
			graphics.lineTo((i + x0 + .5) * xScale + Graph.MARGIN_X, yy);

			if(x0 == 0){
				var dot:Dot = new Dot(i, rankData[i]);
				dot.x = Graph.MARGIN_X + xScale * (i + .5);
				dot.y = points[i];
				addChild(dot);
				dot.doEffect();
			}

			t++;
		}

		setTimeout(drawLine, 14);
	}
}

class Dot extends Sprite{
	private var on:Boolean = false;

	public function Dot(i:int, rank:int){
		if(rank < 0) return;
		var year:int = Math.floor((i + 1) / 12 + 2005);
		var month:int = ((i + 1)% 12 + 1);

		graphics.beginFill(Graph.LINE_COLOR);
		graphics.drawCircle(0, 0, 3);
		graphics.endFill();
		graphics.beginFill(0xffffff, 0);
		graphics.drawCircle(0, 0, 8);
		graphics.endFill();
		buttonMode = true;

		
		addEventListener("click", function(event:Event):void{
			ExternalInterface.call("PopupGraph.monthClick(" + year + "," + month + ")");
		});
		addEventListener("rollOver", function(event:MouseEvent):void{
			Popup.getInstance().setPos(event, year, month, rank);
			on = true;
			doEffect();
		});
		addEventListener("mouseMove", function(event:MouseEvent):void{Popup.getInstance().setPos(event, year, month, rank)});
		addEventListener("rollOut", function(event:MouseEvent):void{Popup.getInstance().hide(); on = false;});
	}

	public function doEffect():void{
		var effect:DotEffect = new DotEffect();
		effect.x = x; effect.y = y;
		parent.addChildAt(effect, 0);
		var self:Dot = this;

		Tweener.addTween(effect, {
			alpha: 0,
			_scale: 5,
			time: 1,
			onComplete: function():void{
				effect.parent.removeChild(effect);
				if(self.on){
					self.doEffect();
				}
			}
		});
	}
}

class DotEffect extends Sprite{
	public function DotEffect():void{
		graphics.lineStyle(1, Graph.LINE_COLOR, 1, false, "none");
		graphics.drawCircle(0, 0, 4);
	}
}

class Popup extends Sprite{
	private static var popup:Popup;
	private var text:TextField;
	private var trail:Point;
	private var curVisible:Boolean;

	public function Popup(){
		graphics.beginFill(0xffffff);
		graphics.lineStyle(3, 0xcccccc);
		graphics.drawRect(0, 0, 84, 34);
		graphics.endFill();
		filters = [new DropShadowFilter(5, 45, 0, .5)];

		text = Graph.createTextField("");
		text.x = text.y = 2;
		text.selectable = false;
		text.autoSize = "left";
		addChild(text);

		curVisible = visible = false;

		setInterval(timerHandler, 50);
	}

	public function setPos(event:MouseEvent, year:int, month:int, rank:int):void{
		if(!curVisible){
			curVisible = true;
			visible = true;
			alpha = 0;
			Tweener.addTween(this, {alpha: 1, time: .8});
		}

		text.htmlText = "<font size='-2' color='#3366cc'>" + year + "年" + month + "月</font>\n"
			+ rank + "位";
	}

	public function hide():void{
		if(curVisible){
			curVisible = false;
			Tweener.addTween(this, {alpha: 0, time: .8, onComplete: function():void{visible = false}});
		}
	}

	private function timerHandler():void{
		if(trail){
			var nextX:Number = trail.x + 16;
			var nextY:Number = trail.y + 16;
			if(nextX + width > Graph.WIDTH) nextX = trail.x - width - 12;
			if(nextY + height > Graph.HEIGHT) nextY = trail.y - height - 12;
			if(visible){
				Tweener.addTween(this, {
					x: nextX,
					y: nextY,
					time: .05
				});
			}else{
				x = nextX;
				y = nextY;
			}
		}
		trail = new Point(stage.mouseX, stage.mouseY);
	}

	public static function getInstance():Popup{
		if(!popup) popup = new Popup();
		return popup;
	}
}