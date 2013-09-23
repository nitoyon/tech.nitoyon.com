package{
	import flash.display.*;
	import flash.events.Event;
	import flash.utils.setTimeout;

	public class BasicCircle extends Sprite{
		static private const COLOR:Array = [
			0x000000, 0x2424db, 0x6c6cff, 0x24ff24, 0x48ff6d, 
			0xb62424, 0x48ffdb, 0xff2424, 0xff6d6d, 0xdb24db, 
			0xdb6ddb, 0x242491, 0xdbb648, 0xb6b6b6, 0xffffff
		];
		static private const TIMEOUT:int = 10;
		
		public function BasicCircle(){
			stage.scaleMode = "noScale";

			var bmd:BitmapData = new BitmapData(256, 192);
			var bmp:Bitmap = new Bitmap(bmd);
			bmp.scaleX = bmp.scaleY = 2;
			addChild(bmp);

			addEventListener("complete", function(event:Event):void{
				drawCircle(bmd, 
					256 * Math.random(), 
					192 * Math.random(), 
					50 * Math.random() + 50, 
					COLOR[Math.floor(Math.random() * COLOR.length)]);
			});
			dispatchEvent(new Event("complete"));
		}

		private function drawCircle(bmd:BitmapData, x0:int, y0:int, r:int, col:uint):void{
			var x:int = r;
			var y:int = 0;
			var F:int = -2 * r + 3;

			setTimeout(function():void{
				if ( x < y ) {
					dispatchEvent(new Event("complete"));
				} else {
					bmd.setPixel( x0 + x, y0 + y, col );
					bmd.setPixel( x0 - x, y0 + y, col );
					bmd.setPixel( x0 + x, y0 - y, col );
					bmd.setPixel( x0 - x, y0 - y, col );
					bmd.setPixel( x0 + y, y0 + x, col );
					bmd.setPixel( x0 - y, y0 + x, col );
					bmd.setPixel( x0 + y, y0 - x, col );
					bmd.setPixel( x0 - y, y0 - x, col );
					if ( F >= 0 ) {
						x--;
						F -= 4 * x;
					}
					y++;
					F += 4 * y + 2;

					setTimeout(arguments.callee, TIMEOUT);
				}
			}, TIMEOUT);
		}
	}
}