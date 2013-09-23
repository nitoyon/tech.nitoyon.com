package{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.net.*;
	import flash.filters.ColorMatrixFilter;
	
	[SWF(backgroundColor="#ffffff")]
	public class Bakumatsu extends Sprite{
		[Embed(source="BakumatsuTexture.jpg")]
		private var Texture:Class;

		private var canvas:Sprite;

		public function Bakumatsu(){
			stage.scaleMode = "noScale";
			stage.align = "TL";

			// 入力欄
			var tf:TextField = new TextField;
			tf.border = true;
			tf.text = "http://tech.nitoyon.com/img/title-blog.jpg";
			tf.type = "input";
			tf.width = 380;
			tf.height = 22;
			tf.x = tf.y = 5;
			addChild(tf);

			// ボタン
			var button:Sprite = new Sprite();
			button.graphics.beginFill(0xcccccc);
			button.graphics.drawRect(0, 0, 50, 22);
			button.graphics.endFill();
			button.filters = [new BevelFilter(2, 45, 0xffffff, 0.5, 0x000000, 0.5)];
			button.mouseChildren = false;
			var label:TextField = new TextField();
			label.width = 50;
			label.height = 22;
			label.htmlText = "<p align='center'>幕末化</p>";
			button.addChild(label);
			button.buttonMode = true;
			button.x = 395;
			button.y = 5;
			addChild(button);

			// キャンバス
			canvas = new Sprite();
			canvas.x = 5;
			canvas.y = 35;
			addChild(canvas);

			button.addEventListener("click", function(event:Event):void{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
				loader.contentLoaderInfo.addEventListener("ioError", ioErrorHandler);
				var req:URLRequest = new URLRequest(tf.text);
				loader.load(req);

				showMsg("Loading...");
			});
			button.dispatchEvent(new Event("click"));
		}

		private function completeHandler(event:Event):void{
			var li:LoaderInfo = event.currentTarget as LoaderInfo;
			var loader:Loader = li.loader;
			bakumatsuNize(loader);
		}

		private function ioErrorHandler(event:Event):void{
			showMsg("Not found!!");
		}

		private function showMsg(msg:String):void{
			var tf:TextField = new TextField();
			tf.htmlText = "<font size='40'>" + msg + "</font>";
			tf.autoSize = "left";
			tf.selectable = false;
			bakumatsuNize(tf);
		}

		private function bakumatsuNize(img:DisplayObject):void{
			while(canvas.numChildren > 0){
				canvas.removeChildAt(0);
			}
			canvas.graphics.clear();
			canvas.addChild(img);

			var f:ColorMatrixFilter = new ColorMatrixFilter([
				 3,  0,  0, 0, -200, 
				 0,  3,  0, 0, -200, 
				 0,  0,  3, 0, -200, 
				 0,  0,  0, 1, 0
			]);

			var f2:ColorMatrixFilter = new ColorMatrixFilter([
				1 / 4, 1 / 2, 1 / 8, 0, 0, 
				1 / 4, 1 / 2, 1 / 8, 0, 0, 
				1 / 4, 1 / 2, 1 / 8, 0, 0, 
				    0,     0,     0, 1, 0
			]);
			img.filters = [f, f2];

			var texture:Bitmap = new Texture();
			texture.width = img.width;
			texture.height = img.height;
			canvas.addChild(texture);
			texture.alpha = 0.5;

			// 枠
			img.x = img.y = texture.x = texture.y = 5;
			canvas.graphics.beginFill(0xf3f3f3);
			canvas.graphics.lineStyle(1, 0xcccccc);
			canvas.graphics.drawRect(0, 0, img.width + 10, img.height + 10);
			canvas.graphics.endFill();
			canvas.filters = [new DropShadowFilter(2, 45, 0, 0.4)];
		}
	}
}
