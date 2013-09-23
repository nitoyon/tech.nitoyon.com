package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import org.libspark.swfassist.io.*;
	import org.libspark.swfassist.swf.io.*;
	import org.libspark.swfassist.swf.structures.SWF;
	import org.libspark.swfassist.swf.structures.Shape;
	import org.libspark.swfassist.swf.structures.ShapeRecord;
	import org.libspark.swfassist.swf.structures.ShapeRecordTypeConstants;
	import org.libspark.swfassist.inprogress.swf.ShapeCollector;
	import org.libspark.swfassist.flash.display.ShapeDrawer;
	import org.libspark.swfassist.flash.display.ShapeOutlineDrawer;

	[SWF(backgroundColor="#000000", frameRate="6")]
	public class FuzzyFontDemo extends Sprite {
		[Embed(source='アニトＭ-教漢.TTF', fontName='anito', unicodeRange='U+5922')]
		private var font:Class;

		public function FuzzyFontDemo(){
			stage.align = "TL";
			stage.scaleMode = "noScale";

			var input:DataInput = new ByteArrayInputStream(loaderInfo.bytes);
			var context:ReadingContext = new ReadingContext();
			var reader:SWFReader = new SWFReader();
			var swf:SWF = reader.readSWF(input, context);

			var shapeCollector:ShapeCollector = new ShapeCollector();
			swf.visit(shapeCollector);
			var shape:Shape = shapeCollector.shapes[1];

			var sprite:Sprite = new Sprite();
			addChild(sprite);

			var rad:Number = 0;
			addEventListener("enterFrame", function(event:Event):void{
				sprite.graphics.clear();

				var fuzzy:FuzzyFlashGraphics = new FuzzyFlashGraphics(sprite.graphics);
				var a:Number = Math.sin(rad / 180 * Math.PI) * 4;
				rad = (rad + 4) % 360;
				fuzzy.f = function(pt:Point):Point{
					pt.x += (Math.random() - .5) * a;
					pt.y += (Math.random() - .5) * a;
					return pt;
				}

				var drawer:ShapeOutlineDrawer = new ShapeOutlineDrawer();
				drawer.graphics = fuzzy;

				sprite.graphics.lineStyle(0, 0xffffff);
				sprite.graphics.beginFill(0xffffff);
				drawer.draw(shape);
				sprite.graphics.endFill();
			});

			sprite.y = 50;
			scaleX = scaleY = 5;
		}
	}
}

import flash.display.Graphics;
import flash.geom.Point;
import org.libspark.swfassist.flash.display.FlashGraphics;

class FuzzyFlashGraphics extends FlashGraphics
{
	public function FuzzyFlashGraphics(graphics:Graphics = null){
		super(graphics);
		_f = function(pt:Point):Point{return pt;}
	}

	private var _f:Function = null;
	public function get f():Function{return _f;}
	public function set f(value:Function):void{_f = value;}

	public override function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void{
		var p1:Point = _f(new Point(controlX, controlY));
		var p2:Point = _f(new Point(anchorX, anchorY));
		super.curveTo(p1.x, p1.y, p2.x, p2.y);
	}

	public override function lineTo(x:Number, y:Number):void{
		var p:Point = _f(new Point(x, y));
		super.lineTo(p.x, p.y);
	}

	public override function moveTo(x:Number, y:Number):void{
		var p:Point = _f(new Point(x, y));
		super.moveTo(p.x, p.y);
	}
}
