package {
	import flash.display.*;
	import flash.geom.Point;

	[SWF(backgroundColor="0x000000")]
	public class Study3d1 extends Sprite{
		private var canvas:Sprite = new Sprite();

		private var p1:Point3D = new Point3D(  0,   0, 100);
		private var p2:Point3D = new Point3D(100,   0,   0);
		private var p3:Point3D = new Point3D(  0, 100,   0);
		private var p4:Point3D = new Point3D(-50, -50, -50);

		public function Study3d1(){
			stage.scaleMode = "noScale";
			stage.align = "TL";

			addChild(canvas);
			canvas.x = 150;
			canvas.y = 150;

			changeHandler(null);
			addEventListener("enterFrame", changeHandler);
		}

		private function changeHandler(event:Object):void {
			var pp1:Point3D = rotate(p1);
			var pp2:Point3D = rotate(p2);
			var pp3:Point3D = rotate(p3);
			var pp4:Point3D = rotate(p4);

			canvas.graphics.clear();
			drawPoint(pp1); drawPoint(pp2);
			drawPoint(pp3); drawPoint(pp4);
			drawLine(pp1, pp2); drawLine(pp1, pp3); drawLine(pp1, pp4);
			drawLine(pp2, pp3); drawLine(pp2, pp4); drawLine(pp3, pp4);
		}

		private function drawPoint(p:Point3D):void {
			canvas.graphics.beginFill(0xffffff);
			canvas.graphics.drawCircle(p.x, p.y, 10);
			canvas.graphics.endFill();
		}

		private function drawLine(p1:Point3D, p2:Point3D):void {
			canvas.graphics.lineStyle(3, 0xffffff);
			canvas.graphics.moveTo(p1.x, p1.y);
			canvas.graphics.lineTo(p2.x, p2.y);
			canvas.graphics.lineStyle();
		}

		private function rotate(_p:Point3D):Point3D {
			var ret:Point3D = new Point3D(_p.x, _p.y, _p.z);
			var p:Point;

			// y rotate
			p = rotate2d(ret.z, ret.x, stage.mouseX / 180 * Math.PI);
			ret.z = p.x; ret.x = p.y;

			// z rotate
			p = rotate2d(ret.x, ret.y, -stage.mouseY / 180 * Math.PI);
			ret.x = p.x; ret.y = p.y;

			return ret;
		}

		private function rotate2d(x:Number, y:Number, rad:Number):Point {
			var p:Point = new Point();
			p.x =  Math.cos(rad) * x + Math.sin(rad) * y;
			p.y = -Math.sin(rad) * x + Math.cos(rad) * y;
			return p;
		}
	}
}

class Point3D {
	public var x:Number;
	public var y:Number;
	public var z:Number;

	public function Point3D(_x:Number = 0, _y:Number = 0, _z:Number = 0){
		x = _x;
		y = _y;
		z = _z;
	}
}
