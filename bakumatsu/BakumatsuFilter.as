package{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.filters.ColorMatrixFilter;
	
	public class BakumatsuFilter extends Sprite{
		[Embed(source="BakumatsuTexture.jpg")]
		private var Texture:Class;

		private var canvas:Sprite;

		public function BakumatsuFilter(){
			stage.scaleMode = "noScale";
			stage.align = "TL";

			var param:Object = loaderInfo.parameters;
			trace(param.url);
			if(param.url == null || param.url == ""){
				showErr();
			}else{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
				loader.contentLoaderInfo.addEventListener("ioError", function(event:Event):void{showErr();});
				var req:URLRequest = new URLRequest(param.url);
				loader.load(req);
			}
		}

		private function completeHandler(event:Event):void{
			var li:LoaderInfo = event.currentTarget as LoaderInfo;
			bakumatsuNize(li.loader);
		}

		private function showErr():void{
			graphics.lineStyle(1, 0x000000);
			graphics.beginFill(0xffffff);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();

			graphics.moveTo(0, 0);
			graphics.lineTo(stage.stageWidth, stage.stageHeight);
			graphics.moveTo(0, stage.stageHeight);
			graphics.lineTo(stage.stageWidth, 0);
		}

		private function bakumatsuNize(img:DisplayObject):void{
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
			img.width = stage.stageWidth;
			img.height = stage.stageHeight;
			addChild(img);

			var texture:Bitmap = new Texture();
			texture.width = img.width;
			texture.height = img.height;
			addChild(texture);
			texture.alpha = 0.5;
		}
	}
}
