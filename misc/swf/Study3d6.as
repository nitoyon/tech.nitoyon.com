package {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.Dictionary;
	import five3D.geom.Matrix3D;
	import five3D.geom.Point3D;

	public class Study3d4 extends Sprite{
		private var canvas:Sprite;
		private var subView:SubView;
		private var shapes:Array;

		private var camera:Point3D;
		private var cameraAt:Point3D;
		private var cameraUp:Point3D;

		public function Study3d4(){
			stage.scaleMode = "noScale";
			stage.align = "TL";

			shapes = [];
			shapes.push(new Cube(0, 0, 0, 50));
			shapes.push(new Cube(0, 100, 0, 20));
			shapes.push(new Cube(0, -100, 0, 20));
			shapes.push(new Cube(100, 0, 0, 20));
			shapes.push(new Cube(-100, 0, 0, 20));
			shapes.push(new Cube(0, 0, 100, 20));
			shapes.push(new Cube(0, 0, -100, 20));

			canvas = new Sprite();
			addChild(canvas);
			canvas.x = 300;
			canvas.y = 150;

			camera = new Point3D(0, 0, 0);
			cameraAt = new Point3D(0, 0, 0);
			cameraUp = new Point3D(0, 1, 0);

			subView = new SubView(shapes, this, camera);
			subView.scaleX = subView.scaleY = 0.2;
			subView.x = subView.y = 100;
			addChild(subView);
		}

		public function update():void {
			canvas.graphics.clear();

			// カメラの座標軸を計算
			var cz:Point3D = cameraAt.subtract(camera);
			cz.normalize(1);
			var cx:Point3D = cross(cameraUp, cz);
			cx.normalize(1);
			var cy:Point3D = cross(cz, cx);

			subView.notifyCameraCoordinate(cx, cy, cz);

			// 回転行列を作成
			var matrix:Matrix3D = new Matrix3D(cx.x, cx.y, cx.z, cy.x, cy.y, cy.z, cz.x, cz.y, cz.z);
			matrix.translate(-camera.dot(cx), -camera.dot(cy), -camera.dot(cz));

			// Zソート
			var dic:Dictionary = new Dictionary();
			for(var i:int = 0; i < shapes.length; i++){
				var c:Cube = shapes[i];
				var center:Point3D = matrix.transformPoint(c.center);
				log(center);
				dic[c] = center.z;
			}
			shapes.sort(function(a:Cube, b:Cube):Number {
				return dic[b] - dic[a];
			});

			// 奥から描画
			for each(c in shapes){
				c.draw(canvas.graphics, matrix);
			}
		}
	}
}

import flash.display.*;
import flash.events.*;
import flash.geom.Point;
import flash.utils.setInterval;
import five3D.geom.Point3D;
import five3D.geom.Matrix3D;

class SubView extends Sprite {
	private var pointer:Sprite;
	private var coordinate:Sprite;
	private var main:Study3d4;
	private var camera:Point3D;

	private const SIZE:int = 600;

	public function SubView(shapes:Array, main:Study3d4, camera:Point3D) {
		this.main = main;
		this.camera = camera;

		init(shapes);
	}

	private function init(shapes:Array):void {
		var g:Graphics = graphics;
		g.beginFill(0xffffff);
		g.drawRect(-SIZE / 2, -SIZE / 2, SIZE, SIZE);
		g.endFill();

		g.lineStyle(0, 0x808080);
		g.moveTo(-SIZE / 2, 0);
		g.lineTo(SIZE / 2, 0);
		g.moveTo(0, -SIZE / 2);
		g.lineTo(0, SIZE / 2);
		g.lineStyle();

		g.lineStyle(0, 0);
		for each(var c:Cube in shapes){
			var p:Point3D = c.center;
			var l:Number = c.len;
			g.drawRect(p.x -l / 2, p.z -l / 2, l, l);
		}
		g.lineStyle();

		pointer = new Sprite();
		pointer.graphics.beginFill(0xff0000);
		pointer.graphics.drawCircle(0, 0, 20);
		pointer.graphics.endFill();
		addChild(pointer);

		coordinate = new Sprite();
		addChild(coordinate);

		var pressing:Boolean = false;
		addEventListener("mouseDown", function(event:MouseEvent):void{
			pressing = true;
		});
		addEventListener("mouseUp", function(event:MouseEvent):void {
			pressing = false;
		});

		setInterval(function():void {
			var old:Point3D = camera.clone();
			camera.y = (pressing ? camera.y + 10 : Math.max(camera.y - 10, 0));
			var p:Point = globalToLocal(new Point(stage.mouseX, stage.mouseY));
			if(Math.abs(p.x) <= SIZE / 2 && Math.abs(p.y) <= SIZE / 2){
				camera.x = pointer.x = p.x;
				camera.z = pointer.y = p.y;
			}

			if(old.x != camera.x || old.y != camera.y || old.z != camera.z){
				main.update();
			}
		}, 100);
	}

	public function notifyCameraCoordinate(cx:Point3D, cy:Point3D, cz:Point3D):void {
		coordinate.x = pointer.x;
		coordinate.y = pointer.y;

		coordinate.graphics.clear();
		coordinate.graphics.lineStyle(1, 0x808000);
		coordinate.graphics.lineTo(cz.x * 100, cz.z * 100);
	}
}


class Cube {
	private var points:Array = [];

	private var _center:Point3D;
	public function get center():Point3D {
		return _center.clone();
	}

	private var _len:Number;
	public function get len():Number {
		return _len;
	}

	public function Cube(x:Number, y:Number, z:Number, len:Number){
		_center = new Point3D(x, y, z);
		_len = len;

		var diff:Function = function(f:Boolean):Number{return f ? len / 2 : -len / 2;};

		for(var i:int = 0; i < 8; i++){
			var p:Point3D = new Point3D(x + diff(i % 4 % 3 == 0),  y + diff(i % 4 < 2), z + diff(i < 4));
			points.push(p);
		}
	}

	public function draw(g:Graphics, matrix:Matrix3D):void {
		// 回転後の座標を計算
		var p:Array = [];
		for(var i:int = 0; i < points.length; i++){
			var pt:Point3D = matrix.transformPoint(points[i]);
			p.push(pt);
		}

		// 面を奥から並べる
		var planes:Array = [
			[p[0], p[1], p[2], p[3]],
			[p[7], p[6], p[5], p[4]],
			[p[0], p[4], p[5], p[1]],
			[p[1], p[5], p[6], p[2]],
			[p[2], p[6], p[7], p[3]],
			[p[3], p[7], p[4], p[0]]
		];
		planes.sort(function(a:Array, b:Array):int{
			return (b[0].z + b[1].z + b[2].z + b[3].z)
			     - (a[0].z + a[1].z + a[2].z + a[3].z)
		});

		// 奥から描画
		for each(var plane:Array in planes){
			drawPlane(g, plane[0], plane[1], plane[2], plane[3]);
		}
	}

	private function drawPlane(g:Graphics, p1:Point3D, p2:Point3D, p3:Point3D, p4:Point3D):void {
		// 単位法線ベクトル
		var v1:Point3D = p4.subtract(p1);
		var v2:Point3D = p2.subtract(p1);
		var v:Point3D = cross(v1, v2);
		v.normalize(1);

		// 光の方向ベクトルとの内積
		var pz:Point3D = new Point3D(0, 0, 1);
		var product:Number = pz.dot(v);

		// 透視投影しつつ面を塗る
		if(product >= 0 && p1.z > 0 && p2.z > 0 && p3.z > 0 && p4.z > 0){
			var b:int = 0x80 * product + 0x7f;
			g.lineStyle(1, 0x808080);
			g.beginFill(b * 0x10000 + b * 0x100 + b);
			var p:Point3D;
			p = p1.clone(); g.moveTo(-p.x / p.z * 200, -p.y / p.z * 200);
			p = p2.clone(); g.lineTo(-p.x / p.z * 200, -p.y / p.z * 200);
			p = p3.clone(); g.lineTo(-p.x / p.z * 200, -p.y / p.z * 200);
			p = p4.clone(); g.lineTo(-p.x / p.z * 200, -p.y / p.z * 200);
			g.endFill();
			g.lineStyle();
		}
	}
}

// 外積
function cross(p1:Point3D, p2:Point3D):Point3D {
	return new Point3D(p1.y * p2.z - p1.z * p2.y,
	                   p1.z * p2.x - p1.x * p2.z,
	                   p1.x * p2.y - p1.y * p2.x);
}
