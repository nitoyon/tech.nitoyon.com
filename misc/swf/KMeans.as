package{
import flash.display.*;
import flash.events.Event;
import flash.utils.setTimeout;
import sketchbook.colors.ColorSB;
import caurina.transitions.Tweener;

[SWF(backgroundColor="#223344", width=400, height=400)]
public class KMeans extends Sprite{
	private var k:int;
	private var n:int;
	private var colors:Array;
	private var dots:Array;
	private var groups:Array;
	private var centers:Array;
	private var changed:Boolean;
	private var canvas:Sprite = new Sprite();

	private const WIDTH:int = 400;
	private const HEIGHT:int = 300;
	private const ANIMATE:Number = .2;

	public function KMeans():void{
		stage.scaleMode = "noScale";

		// init canvas
		canvas.graphics.beginFill(0x000000, 0);
		canvas.graphics.drawRect(0, 0, WIDTH, HEIGHT);
		canvas.graphics.endFill();
		canvas.useHandCursor = buttonMode = true;
		canvas.mouseChildren = false;
		addChild(canvas);

		var state:int = 0;
		canvas.addEventListener("click", function(event:Event):void{
			if(state == 0){
				moveCenter();
			}else{
				updateGroups();
			}
			state = (state + 1) % 2;
		});

		// init inputs
		var nInput:Input = new Input("N (the number of node):", "100");
		nInput.y = HEIGHT + 5;
		addChild(nInput);

		var kInput:Input = new Input("K (the number of cluster):", "5");
		kInput.y = nInput.y + nInput.height + 5;
		addChild(kInput);

		var nextButton:Button = new Button("Step");
		nextButton.y = kInput.y + kInput.height + 5;
		addChild(nextButton);
		nextButton.addEventListener("click", canvas.dispatchEvent);

		var resetButton:Button = new Button("Restart");
		resetButton.x = nextButton.width + 5;
		resetButton.y = nextButton.y;
		addChild(resetButton);
		resetButton.addEventListener("click", function(event:Event):void{
			changed = true;
			state = 0;

			k = kInput.value;
			n = nInput.value;
			init();
		});
		resetButton.dispatchEvent(new Event("click"));
	}

	private function init():void{
		// remove previous sprites
		graphics.clear();
		for each(var dot:Dot in dots){
			canvas.removeChild(dot);
		}
		for each(var center:Center in centers){
			if(center) canvas.removeChild(center);
		}

		// init colors
		colors = [];
		for(var i:int = 0; i < k; i++){
			colors.push(ColorSB.createHSB(i * 360 / k, 90, 100).value);
		}

		// init dot
		dots = [];
		groups = [];
		centers = [];
		for(var i:int = 0; i < n; i++){
			var group:int = Math.floor(Math.random() * k);
			dot = new Dot(colors[group]);
			dot.x = Math.random() * WIDTH;
			dot.y = Math.random() * HEIGHT;
			canvas.addChild(dot);

			dots.push(dot);
			if(!groups[group]) groups[group] = [];
			groups[group].push(dot);
		}
	}

	private function moveCenter():void{
		for each(var dot:Dot in dots) dot.glow = false;
		if(!changed) return;

		graphics.clear();
		var animated:Boolean = false;
		for(var i:int = 0; i < groups.length; i++){
			if(!groups[i] || !groups.length){
				continue;
			}

			// get center of gravity
			var x:Number = 0, y:Number = 0;
			for each(dot in groups[i]){
				x += dot.x;
				y += dot.y;
			}
			x /= groups[i].length;
			y /= groups[i].length;

			if(centers[i]){
				Tweener.addTween(centers[i], {
					x: x, y: y, time: ANIMATE
				});
				animated = true;
			}else{
				var center:Center = new Center(colors[i]);
				center.x = x; center.y = y;
				centers[i] = canvas.addChild(center);
			}
		}

		if(!animated) drawCenterLines();
		else setTimeout(drawCenterLines, ANIMATE * 1000);
	}

	private function drawCenterLines():void{
		graphics.clear();
		for(var i:int = 0; i < groups.length; i++){
			var center:Center = centers[i];
			if(!center) continue;
			for each(var dot:Dot in groups[i]){
				graphics.lineStyle(1, colors[i], .5);
				graphics.moveTo(center.x, center.y);
				graphics.lineTo(dot.x, dot.y);
				graphics.lineStyle();
			}
		}
	}

	private function updateGroups():void{
		changed = false;
		groups = [];
		for each(var dot:Dot in dots){
			// find the nearest group
			var min:Number = Infinity;
			var group:int = -1;
			for(var i:int = 0; i < centers.length; i++){
				var center:Center = centers[i];
				if(!center) continue;

				var d:Number = Math.pow(center.x - dot.x, 2) + Math.pow(center.y - dot.y, 2);
				if(d < min){
					min = d;
					group = i;
				}
			}

			// update group
			if(!groups[group]) groups[group] = [];
			groups[group].push(dot);
			if(dot.color != colors[group]){
				dot.color = colors[group];
				dot.glow = true;
				changed = true;
			}
		}

		drawCenterLines();
	}
}
}

import flash.display.*;
import flash.text.*;
import flash.filters.GlowFilter;

class Dot extends Sprite{
	private var _color:uint;
	public function get color():uint{return _color;}
	public function set color(v:uint):void{
		_color = v;
		draw();
	}

	public function set glow(v:Boolean):void{
		if(v) filters = [new GlowFilter(0xffffff, 1, 5, 5)];
		else filters = [];
	}

	public function Dot(col:uint){
		color = col;
	}

	private function draw():void{
		graphics.clear();
		graphics.beginFill(_color);
		graphics.drawCircle(0, 0, 5);
		graphics.endFill();
	}
}

class Center extends Sprite{
	public function Center(col:uint){
		graphics.lineStyle(3, 0xffffff);
		draw();
		graphics.endFill();

		graphics.lineStyle(2, col);
		draw();
		graphics.endFill();
	}

	private function draw():void{
		graphics.moveTo(-5, -5);
		graphics.lineTo(5, 5);
		graphics.moveTo(5, -5);
		graphics.lineTo(-5, 5);
	}
}

class Button extends Sprite{
	public function Button(label:String){
		useHandCursor = buttonMode = true;
		mouseChildren = false;

		var t:TextField = new TextField();
		t.text = label;
		t.autoSize = "left";
		t.selectable = false;
		t.x = t.y = 5
		addChild(t);

		graphics.beginFill(0xcccccc);
		graphics.drawRect(0, 0, t.width + 10, t.height + 10);
		graphics.endFill();
	}
}

class Input extends Sprite{
	private var input:TextField;

	public function get value():int{
		return parseInt(input.text, 10);
	}

	public function Input(labelStr:String, valueStr:String):void{
		var tf:TextFormat = new TextFormat();
		tf.size = 20;

		var label:TextField = new TextField();
		input = new TextField();
		input.textColor = label.textColor = 0xffffff;
		input.defaultTextFormat = label.defaultTextFormat = tf;

		label.text = labelStr;
		label.autoSize = "left";
		addChild(label);

		input.border = true;
		input.borderColor = 0x999999;
		input.type = "input";
		input.text = valueStr;
		input.height = 22;
		addChild(input).x = 220;
	}
}