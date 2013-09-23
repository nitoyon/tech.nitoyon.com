package{
	import flash.display.*;
	import flash.events.Event;
	import flash.utils.setTimeout;
	import flash.filters.*;
	import flash.text.TextField;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.external.ExternalInterface;
	import caurina.transitions.Tweener;

	[SWF(width="600", height="450")]
	public class Illusion extends Sprite{
		private const WIDTH:int = 600;
		private const HEIGHT:int = 450;
		private const URL_BASE:String = "http://tech.nitoyon.com/illusion1/";

		[Embed(source='title1.png')]
		private var Title1:Class;
		[Embed(source='title2.png')]
		private var Title2:Class;
		[Embed(source='replay1.png')]
		private var Replay1:Class;
		[Embed(source='replay2.png')]
		private var Replay2:Class;
		[Embed(source='create1.png')]
		private var Create1:Class;
		[Embed(source='create2.png')]
		private var Create2:Class;

		private var base:Sprite;
		private var loader:Loader;

		private var url:String;
		private var complete:Boolean = false;
		private var scale:Number;
		private var sw:Number;
		private var sh:Number;

		public function Illusion(){
			stage.scaleMode = "noScale";
			stage.align = "TL";

			sw = stage.stageWidth;
			sh = stage.stageHeight;

			// calc scale
			scale = Math.min(1, Math.min(sw / WIDTH, sh / HEIGHT));

			// add base
			base = new Sprite();
			base.x = (sw - WIDTH  * scale) / 2;
			base.y = (sh - HEIGHT * scale) / 2;
			addChild(base);

			// add mask
			var m:Sprite = new Sprite();
			m.graphics.beginFill(0xffffff);
			m.graphics.drawRect(0, 0, WIDTH * scale, HEIGHT * scale);
			m.graphics.endFill();
			base.addChild(m);
			base.mask = m;

			// get url
			var param:Object = stage.loaderInfo.parameters;
			if(param == null || param['url'] == null || param['url'] == ""){
				showError("Error: URL is not set.");
			}
			url = param['url'];

			// init loader
			loader = new Loader();
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener("complete", function(event:Event):void{
				complete = true;
				dispatchEvent(new Event("complete"));
			});
			loader.contentLoaderInfo.addEventListener("ioError", function(event:Event):void{
				showError("Failed to load image: " + url);
			});

			startTitle();
		}

		// clear
		private function clearBaseChildren():void{
			while(base.numChildren){
				base.removeChildAt(0);
			}
		}

		// show title
		private function startTitle():void{
			var title:Sprite = createButton(Title1, Title2);
			title.scaleX = title.scaleY = scale;
			base.addChild(title);

			title.addEventListener("click", function(event:Event):void{
				if(complete){
					start();
				}
				else{
					addEventListener("complete", function(event:Event):void{
						start();
					});
				}
			});
		}

		// show error
		private function showError(msg:String):void{
			clearBaseChildren();

			var txt:TextField = new TextField();
			txt.textColor = 0xffffff;
			txt.text = msg;
			txt.width = WIDTH * scale;
			base.addChild(txt);
		}

		// start illustion
		private function start():void{
			clearBaseChildren();

			// init image
			base.addChild(loader);
			loader.scaleX = loader.scaleY = 1;
			var imgScale:Number = Math.min(1, Math.min(sw / loader.width, sh / loader.height));
			loader.scaleX = loader.scaleY = imgScale;

			loader.x = (WIDTH  * scale - loader.width ) / 2;
			loader.y = (HEIGHT * scale - loader.height) / 2;
			filter1();

			// init dot
			var dot:Sprite = new Sprite();
			dot.graphics.lineStyle(0, 0xcccccc);
			dot.graphics.beginFill(0);
			dot.graphics.drawCircle(0, 0, 6 * scale);
			dot.graphics.endFill();
			dot.x = WIDTH  * scale / 2;
			dot.y = HEIGHT * scale / 2;
			base.addChild(dot);

			// clickable background
			if(ExternalInterface.available){
				var parentUrl:String = ExternalInterface.call("(function(){return window.location.href})");
				if(parentUrl == null || parentUrl.toLowerCase().indexOf(URL_BASE) != 0){
					var clickable:Sprite = createButton(null, null);
					clickable.width = WIDTH * scale;
					clickable.height = HEIGHT * scale;
					base.addChild(clickable);
					clickable.addEventListener("click", function(event:Event):void{
						if(event.target == clickable){
							ExternalInterface.call("window.open", URL_BASE + "?url=" + encodeURI(url));
						}
					});
				}
			}

			// 15s later
			setTimeout(filter2, 15000);

			// filters
			var filters:Array = [new GlowFilter(0, .6, 30 * scale, 30 * scale)];

			// add button
			var replay:Sprite = createButton(Replay1, Replay2);
			replay.scaleX = replay.scaleY = scale;
			replay.filters = filters;
			base.addChild(replay);
			replay.x = 80 * scale;
			replay.y = (HEIGHT + 30) * scale;

			var create:Sprite = createButton(Create1, Create2);
			create.scaleX = create.scaleY = scale;
			create.filters = filters;
			base.addChild(create);
			create.x = 330 * scale;
			create.y = (HEIGHT + 30) * scale;

			// add tween
			Tweener.addTween(replay, {
				delay: 20,
				time: .8,
				y: (HEIGHT - 85) * scale
			});
			Tweener.addTween(create, {
				delay: 20.5,
				time: .8,
				y: (HEIGHT - 85) * scale
			});

			// handler
			replay.addEventListener("click", function(event:Event):void{
				start();
			});

			create.addEventListener("click", function(event:Event):void{
				navigateToURL(new URLRequest(URL_BASE), "_top");
			});
		}

		private function filter1():void {
			loader.filters = [
				new ColorMatrixFilter([
					-1,  0,  0,  0, 255, 
					 0, -1,  0,  0, 255, 
					 0,  0, -1,  0, 255, 
					 0,  0,  0,  1,   0
				])];
		}

		private function filter2():void {
			loader.filters = [
				new ColorMatrixFilter([
					1/3, 1/3, 1/3, 0, 0,
					1/3, 1/3, 1/3, 0, 0,
					1/3, 1/3, 1/3, 0, 0,
					  0,   0,   0, 1, 0
				])];
		}

		// util: create button
		private function createButton(normalClass:Class, hoverClass:Class):Sprite {
			var ret:Sprite = new Sprite();
			if(normalClass){
				var normal:Bitmap = new normalClass();
				normal.smoothing = true;
				ret.addChild(normal);
			}

			if(hoverClass){
				var hover:Bitmap = new hoverClass();
				hover.smoothing = true;
			}

			ret.graphics.beginFill(0, 0);
			ret.graphics.drawRect(0, 0, normal ? normal.width : 1, normal ? normal.height : 1);
			ret.graphics.endFill();
			ret.buttonMode = ret.useHandCursor = true;

			if(hover){
				ret.addEventListener("mouseOver", function(event:Event):void{
					ret.addChild(hover);
				});
				ret.addEventListener("mouseOut", function(event:Event):void{
					if(hover.parent){
						ret.removeChild(hover);
					}
				});
			}
			return ret;
		}
	}
}