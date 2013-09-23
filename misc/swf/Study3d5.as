http://www.rubenswieringa.com/blog/distortimage

http://www.d-project.com/flex/009_FreeTransform/

package {
	import flash.display.*;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.setInterval;
	import flash.text.TextField;
	import five3D.geom.Matrix3D;
	import five3D.geom.Point3D;

	[SWF(backgroundColor="0x000000")]
	public class Study3d5 extends Sprite{
		private var canvas:Sprite;
		private var cubes:Array;
        private var rad:Number;

		public function Study3d5(){
			stage.scaleMode = "noScale";
			stage.align = "TL";

			cubes = [];
			cubes.push(new Cube(0, 0, 0, 120));

			canvas = new Sprite();
			addChild(canvas);
            canvas.x = 200;
            canvas.y = 150;

            var textField:TextField = new TextField();
            textField.textColor = 0xffffff;
            textField.text = "click to start";
            addChild(textField);

            rad = 0;
			var f:Boolean = true;
            stage.addEventListener("click", function(event:Event):void{
	            if(f){
		            textField.text = "click to stop";
		            addEventListener("enterFrame", changeHandler);
		        }else{
		            textField.text = "click to start";
					addChild(textField);
					removeEventListener("enterFrame", changeHandler);
				}
				f = !f;
			});
		}

		private function changeHandler(event:Object):void {
			canvas.graphics.clear();

            // 回転行列を作成
            var matrix:Matrix3D = new Matrix3D();
            matrix.rotateX(Math.PI / 6);
            matrix.rotateY(rad / 180 * Math.PI * 3);
            matrix.rotateZ(rad / 180 * Math.PI);

			// それぞれの立方体の中心のZ座標を取得する
			var dic:Dictionary = new Dictionary();
			for each(var c:Cube in cubes){
				var center:Point3D = matrix.transformPoint(c.center);
				dic[c] = center.z;
			}

			// Zソート (奥のものから順番に並べる)
			cubes.sort(function(a:Cube, b:Cube):Number {
				return dic[b] - dic[a];
			});

			// 奥から描画
			for each(c in cubes){
				c.draw(canvas.graphics, matrix, 200);
			}

           // 角度更新
            rad = (rad + 1) % 360;
 		}
	}
}

import flash.display.Graphics;
import flash.geom.Point;
import flash.utils.Dictionary;
import five3D.geom.Point3D;
import five3D.geom.Matrix3D;

class Cube {
	[Embed(source="1.jpg")]
	private static var Img1:Class;
	[Embed(source="2.jpg")]
	private static var Img2:Class;
	[Embed(source="3.jpg")]
	private static var Img3:Class;
	[Embed(source="4.jpg")]
	private static var Img4:Class;
	[Embed(source="5.jpg")]
	private static var Img5:Class;
	[Embed(source="6.jpg")]
	private static var Img6:Class;

	private var images:Array = [];

	private var points:Array = [];
	private var _center:Point3D;

	public function get center():Point3D {
		return _center;
	}

	public function Cube(x:Number, y:Number, z:Number, len:Number){
		_center = new Point3D(x, y, z);

		images.push(new Img1());
		images.push(new Img2());
		images.push(new Img3());
		images.push(new Img4());
		images.push(new Img5());
		images.push(new Img6());

		var diff:Function = function(f:Boolean):Number{return f ? len / 2 : -len / 2;};

        // 立方体の頂点８つを作成する
        for(var i:int = 0; i < 8; i++){
            var p:Point3D = new Point3D(x + diff(i % 4 % 3 == 0),  y + diff(i % 4 < 2), z + diff(i < 4));
            points.push(p);
        }
	}

	public function draw(g:Graphics, matrix:Matrix3D, f:Number):void {
		// 回転後の座標を計算
		var p:Array = [];
		for(var i:int = 0; i < points.length; i++){
			var pt:Point3D = matrix.transformPoint(points[i]);
			p.push(pt);
		}

		// 面の一覧
		var planes:Array = [
			[p[0], p[1], p[2], p[3], images[0].bitmapData],
			[p[7], p[6], p[5], p[4], images[1].bitmapData],
			[p[0], p[4], p[5], p[1], images[2].bitmapData],
			[p[1], p[5], p[6], p[2], images[3].bitmapData],
			[p[2], p[6], p[7], p[3], images[4].bitmapData],
			[p[3], p[7], p[4], p[0], images[5].bitmapData]
		];

		// 面の中心のZ座標を求める
		var z:Dictionary = new Dictionary();
		for(i = 0; i < planes.length; i++){
			z[planes[i]] = (planes[i][0].z + planes[i][1].z + planes[i][2].z + planes[i][3].z) / 4;
		}

		// Zソート (奥のものから順番に並べる)
		planes.sort(function(a:Array, b:Array):Number {
			return z[b] - z[a];
		});

		// 奥から順番に面を描画
		var index:int = 0;
		for each(var plane:Array in planes){
			drawPlane(g, plane[4], plane[0], plane[1], plane[2], plane[3]);
		}
	}

	private function drawPlane(g:Graphics, bmd:BitmapData, p1:Point3D, p2:Point3D, p3:Point3D, p4:Point3D):void {
        // 単位法線ベクトル
        var v1:Point3D = p2.subtract(p1);
        var v2:Point3D = p4.subtract(p1);
        var n:Point3D = cross(v1, v2);
        n.normalize(1);

        // 裏側の面は描画しない
        var l:Point3D = new Point3D(0, 0, -1);
        var product:Number = n.dot(l);
		if(product < 0){
			return;
		}

		// 透視投影しつつ２次元座標に変換する
		var p:Point3D;
		var pp1:Point, pp2:Point, pp3:Point, pp4:Point;
		p = p1.clone(); p.project(p.getPerspective(500)); pp1 = new Point(p.x, p.y);
		p = p2.clone(); p.project(p.getPerspective(500)); pp2 = new Point(p.x, p.y);
		p = p3.clone(); p.project(p.getPerspective(500)); pp3 = new Point(p.x, p.y);
		p = p4.clone(); p.project(p.getPerspective(500)); pp4 = new Point(p.x, p.y);

		// 変形してビットマップを表示
		TransformUtil.drawBitmapQuadrangle(g, bmd, 
			new Point(0, 0), new Point(100, 0), new Point(0, 100), new Point(100, 100), 
			pp1, pp2, pp4, pp3);
	}
}

// 外積
function cross(p1:Point3D, p2:Point3D):Point3D {
	return new Point3D(p1.y * p2.z - p1.z * p2.y,
	                   p1.z * p2.x - p1.x * p2.z,
	                   p1.x * p2.y - p1.y * p2.x);
}


    import flash.geom.Point;
    import flash.geom.Matrix;
    import flash.display.Graphics;
    import flash.display.BitmapData;

/**
 * TransformUtil
 * @author Kazuhiko Arase
 */
class TransformUtil {

    /**
     * ビットマップの三角形を描く。 
     * <br/>0 - 1
     * <br/>| /  
     * <br/>2 
     * @param g グラフィックス
     * @param bitmapData ビットマップデータ
     * @param a0 転送元(ビットマップデータ)の座標
     * @param a1 転送元(ビットマップデータ)の座標
     * @param a2 転送元(ビットマップデータ)の座標
     * @param b0 転送先(グラフィック)の座標
     * @param b1 転送先(グラフィック)の座標
     * @param b2 転送先(グラフィック)の座標
     */
    public static function drawBitmapTriangle(
        g : Graphics, bitmapData : BitmapData,
        a0 : Point, a1 : Point, a2 : Point, 
        b0 : Point, b1 : Point, b2 : Point
    ) : void {
        var matrix : Matrix = createMatrix(a0, a1, a2, b0, b1, b2);
        g.beginBitmapFill(bitmapData, matrix);
        drawTriangle(g, a0, a1, a2, matrix);
        g.endFill();
    }

    /**
     * ビットマップの四角形を描く。 
     * <br/>0 - 1
     * <br/>|   |
     * <br/>2 - 3
     * @param g グラフィックス
     * @param bitmapData ビットマップデータ
     * @param a0 転送元(ビットマップデータ)の座標
     * @param a1 転送元(ビットマップデータ)の座標
     * @param a2 転送元(ビットマップデータ)の座標
     * @param a3 転送元(ビットマップデータ)の座標
     * @param b0 転送先(グラフィック)の座標
     * @param b1 転送先(グラフィック)の座標
     * @param b2 転送先(グラフィック)の座標
     * @param b3 転送先(グラフィック)の座標
     * @param hDiv 水平方向の分割数
     * @param vDiv 垂直方向の分割数
     */
    public static function drawBitmapQuadrangle(
        g : Graphics, bitmapData : BitmapData,
        a0 : Point, a1 : Point, a2 : Point, a3 : Point, 
        b0 : Point, b1 : Point, b2 : Point, b3 : Point,
        hDiv : int = 4, vDiv : int = 4
    ) : void {

        for (var h : int = 0; h < hDiv; h++) {

            var h0 : Number = h / hDiv;
            var h1 : Number = (h + 1) / hDiv;

            var ta0 : Point = getPoint(a1, a0, h0);
            var ta1 : Point = getPoint(a1, a0, h1);
            var ta2 : Point = getPoint(a3, a2, h0);
            var ta3 : Point = getPoint(a3, a2, h1);

            var tb0 : Point = getPoint(b1, b0, h0);
            var tb1 : Point = getPoint(b1, b0, h1);
            var tb2 : Point = getPoint(b3, b2, h0);
            var tb3 : Point = getPoint(b3, b2, h1);

            for (var v : int = 0; v < vDiv; v++) {

                var v0 : Number = v / vDiv;
                var v1 : Number = (v + 1) / vDiv;

                var tta0 : Point = getPoint(ta1, ta0, v0);
                var tta1 : Point = getPoint(ta1, ta0, v1);
                var tta2 : Point = getPoint(ta3, ta2, v0);
                var tta3 : Point = getPoint(ta3, ta2, v1);

                var ttb0 : Point = getPoint(tb1, tb0, v0);
                var ttb1 : Point = getPoint(tb1, tb0, v1);
                var ttb2 : Point = getPoint(tb3, tb2, v0);
                var ttb3 : Point = getPoint(tb3, tb2, v1);

                drawBitmapTriangle(g, bitmapData,
                    tta0, tta1, tta2, ttb0, ttb1, ttb2);
                drawBitmapTriangle(g, bitmapData,
                    tta3, tta1, tta2, ttb3, ttb1, ttb2);
            }
        }
    }

    private static function getPoint(p0 : Point, p1 : Point, ratio : Number) : Point {
        return new Point(
            p0.x + (p1.x - p0.x) * ratio,
            p0.y + (p1.y - p0.y) * ratio
        );
    }

    private static function createMatrix(
        a0 : Point, a1 : Point, a2 : Point, 
        b0 : Point, b1 : Point, b2 : Point
    ) : Matrix {

        var ma : Matrix = new Matrix(
            a1.x - a0.x, a1.y - a0.y,
            a2.x - a0.x, a2.y - a0.y);
        ma.invert();

        var mb : Matrix = new Matrix(
            b1.x - b0.x, b1.y - b0.y,
            b2.x - b0.x, b2.y - b0.y);

        var m : Matrix = new Matrix();

        // O(原点)へ移動 
        m.translate(-a0.x, -a0.y);

        // 単位行列に変換(aの座標系の逆行列)
        m.concat(ma);

        // bの座標系に変換 
        m.concat(mb);

        // b0へ移動 
        m.translate(b0.x, b0.y);

        return m;
    }

    private static function drawTriangle(
        g : Graphics,
        p0 : Point, p1 : Point, p2 : Point,
        matrix : Matrix
    ) : void {

        p0 = matrix.transformPoint(p0);
        p1 = matrix.transformPoint(p1);
        p2 = matrix.transformPoint(p2);

        g.moveTo(p0.x, p0.y);
        g.lineTo(p1.x, p1.y);
        g.lineTo(p2.x, p2.y);
        g.lineTo(p0.x, p0.y);
    }        
}

