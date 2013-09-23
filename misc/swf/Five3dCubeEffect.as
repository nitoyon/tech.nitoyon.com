package {
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setInterval;
	import five3D.display.*;

	import caurina.transitions.Tweener;

	public class Five3dCubeEffect extends Sprite {
		private const WIDTH:int = 400;
		private const HEIGHT:int = 267;

		[Embed(source="1.jpg")]
		private var Image1:Class;
		[Embed(source="2.jpg")]
		private var Image2:Class;
		[Embed(source="3.jpg")]
		private var Image3:Class;

		private var isCube:int = -1;

		public function Five3dCubeEffect() {
			stage.scaleMode = "noScale";
			stage.align = "TL";

			var images:Array = [];
			images.push(new Image1());
			images.push(new Image2());
			images.push(new Image3());

			addChild(images[0]);
			var index:int = 0;

			setInterval(function():void{
				isCube = (Math.random() < 0.5 ? 1 : -1);
				transition(images[index], images[(index + 1) % images.length]);
				index = (index + 1) % images.length;
			}, 3500);
		}

		private function transition(bmp1:Bitmap, bmp2:Bitmap):void {
			// シーンの準備
			var scene:Scene3D = new Scene3D();
			scene.x = WIDTH / 2;
			scene.y = HEIGHT / 2;
			addChild(scene);

			// 格納用の箱
			var box:Sprite3D = new Sprite3D();
			box.z = isCube * WIDTH / 2;
			scene.addChild(box);

			// 箱上に配置
			var img2:Bitmap3D = new Bitmap3D(bmp2.bitmapData);
			box.addChild(img2);
			img2.x = WIDTH / 2;
			img2.y = -HEIGHT / 2;
			img2.z = -isCube * WIDTH / 2;
			img2.rotationY = -isCube * 90;

			var img1:Bitmap3D = new Bitmap3D(bmp1.bitmapData);
			box.addChild(img1);
			img1.x = -WIDTH / 2;
			img1.y = -HEIGHT / 2;
			img1.z = -isCube * WIDTH / 2;

			Tweener.addTween(box, {
				time: 1.5,
				rotationY: isCube * 90,
				transition: "easeInOutCubic",
				onStart: function():void{
					removeChild(bmp1);
				},
				onUpdate: function():void{
					if(Math.abs(box.rotationY) > 45){
						box.setChildIndex(img1, 0);
					}
				},
				onComplete: function():void{
					box.parent.removeChild(box);
					addChild(bmp2);
				}
			});
		}
	}

}