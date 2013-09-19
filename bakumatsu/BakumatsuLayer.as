package{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.filters.ColorMatrixFilter;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.utils.setTimeout;
	
	public class BakumatsuLayer extends Sprite{
		[Embed(source="BakumatsuTexture.jpg")]
		private var Texture:Class;

		// event listening
		private var listening:Boolean = false;

		// ìØéûÉçÅ[Éhêîêßå¿ÇÃÇΩÇﬂÇÃ queue
		private var queue:Array = [];
		private var loadingCount:int = 0;
		private const LOADING_COUNT_MAX:int = 3;

		public function BakumatsuLayer(){
			stage.scaleMode = "noScale";
			stage.align = "TL";

			Security.allowDomain("*");
			ExternalInterface.addCallback("setImgList", setImgList);

			stage.addEventListener("click", function(event:Event):void{
				while(numChildren){
					removeChildAt(0);
				}
				ExternalInterface.call("Bakumatsu.hide()");
			});
		}

		private function setImgList(list:Object):void{
			if(list is Array){
				for(var i:int = 0; i < list.length; i++){
					var item:Object = list[i];
					if(item && item.src){
						queue.push(item);
					}
				}

				popQueue();
			}
		}

		private function popQueue():void{
			if(queue.length == 0 || loadingCount >= LOADING_COUNT_MAX) return;

			var img:Object = queue[0];
			loadingCount++;

			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void{
				bakumatsuNize(loader, img);

				queue.shift();
				loadingCount--;
				popQueue();
			});
			loader.contentLoaderInfo.addEventListener("ioError", function(event:Event):void{
				queue.shift();
				loadingCount--;
				popQueue();
			});
			loader.load(new URLRequest(img.src));

			if(loadingCount < LOADING_COUNT_MAX){
				popQueue();
			}
		}

		private function bakumatsuNize(img:DisplayObject, param:Object):void{
			var w:int = param.w || img.width;
			var h:int = param.h || img.width;

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
			img.x = param.x;
			img.y = param.y;
			img.width = w;
			img.height = h;
			addChild(img);

			var texture:Bitmap = new Texture();
			texture.x = param.x;
			texture.y = param.y;
			texture.width = w;
			texture.height = h;
			addChild(texture);
			texture.alpha = 0.5;
		}
	}
}
