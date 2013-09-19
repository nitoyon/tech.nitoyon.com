package{
	import flash.display.*;
	import flash.geom.*;
	import flash.events.Event;

	public class IllusionTest extends Sprite{
		function IllusionTest(){
			stage.scaleMode = "noScale";
			stage.align = "TL";

			var toggle:Boolean = true;
			stage.addEventListener("click", function(event:*):void{
				if(event.target != stage) return;
				graphics.clear();
				drawGrad(toggle ? 0x000000 : 0xffffff, 0xffffff, 400, 300, graphics);
				toggle = !toggle;
			});
			stage.dispatchEvent(new Event("click"));

			var s1:Sprite = createBox(); s1.x = 100;
			var s2:Sprite = createBox(); s2.x = 250;
		}

		private function createBox():Sprite{
			var s:Sprite = new Sprite();
			drawGrad(0x242424, 0x626262, 80, 80, s.graphics);
			s.addEventListener("mouseDown", function(event:*):void{
				setChildIndex(s, numChildren - 1);
				s.startDrag();
			});
			s.addEventListener("mouseUp", function(event:*):void{s.stopDrag();});
			s.buttonMode = true; s.useHandCursor = true;
			s.y = 100;
			addChild(s);
			return s;
		}

		private function drawGrad(col1:uint, col2:uint, w:Number, h:Number, g:Graphics):void{
			var m:Matrix = new Matrix();
			m.createGradientBox(w, h);
			g.beginGradientFill("linear", [col1, col2], [100, 100], [0x00, 0xff], m);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
	}
}