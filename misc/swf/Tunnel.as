// Processing Tunnel (AS3 version) 
// original source: http://processing.org/learning/topics/tunnel.html
package {
import flash.display.*;
import flash.geom.*;
import flash.text.*;
import flash.utils.setTimeout;

[SWF(backgroundColor="#ffffff", width="320", height="200")]
public class Tunnel extends Sprite{
	[Embed(source='red_smoke.jpg')]
	private var Texture:Class;
	private var textureImg:BitmapData;

	private var tunnelEffect:BitmapData;
	private var distanceTable:Array = [];
	private var angleTable:Array = [];

	private var w:int;
	private var h:int;

	private var count:int;
	private const CYCLE:int = 50;
	private var bmdCache:Array = [];

	public function Tunnel(){
		// Load texture 512 x 512
		textureImg = new Texture().bitmapData;

		// Create buffer screen
		tunnelEffect = new BitmapData(320, 200);
		addChild(new Bitmap(tunnelEffect));
		w = tunnelEffect.width;
		h = tunnelEffect.height;

		var ratio:Number = 32.0

		// Make the tables twice as big as the screen. 
		// The center of the buffers is now the position (w,h).
		for (var x:int = 0; x < w * 2; x++){
			distanceTable[x] = [];
			angleTable[x] = [];
			for (var y:int = 0; y < h * 2; y++){
				var depth:int = int(ratio * textureImg.height / Math.sqrt((x - w) * (x - w) + (y - h) * (y - h))) ;
				var angle:int = int(0.5 * textureImg.width * atan2(y - h, x - w) / Math.PI) ;

				// The distance table contains for every pixel of the 
				// screen, the inverse of the distance to the center of 
				// the screen this pixel has.
				distanceTable[x][y] = depth ;

				// The angle table contains the angle of every pixel of the screen, 
				// where the center of the screen represents the origin.
				angleTable[x][y] = angle ;
			}
		}

		var tf:TextField = new TextField();
		tf.text = "Click to start...";
		addChild(tf);

		var i:int = 0;
		stage.addEventListener("click", function(event:*):void{
			stage.removeEventListener("click", arguments.callee);
			setTimeout(function():void{
				if(i >= CYCLE){
					// Buffering finish. Start animating.
					addEventListener("enterFrame", function(event:*):void{draw()});
					removeChild(tf);
					return;
				}

				// Create buffered images.
				tf.text = "Buffering " + int(i / CYCLE * 100) + "%...";
				createBmdCache(i++);
				setTimeout(arguments.callee, 20);
			}, 0);
		});
	}

	// Create i-th buffered image.
	private function createBmdCache(i:int):void{
		var timeDisplacement:Number = count++ / CYCLE;

		// Calculate the shift values out of the time value
		var shiftX:int = textureImg.width * timeDisplacement; // speed of zoom
		var shiftY:int = textureImg.height * timeDisplacement; //speed of spin

		var bmd:BitmapData = new BitmapData(w * 2, h * 2);
		for (var y:int = 0; y < h * 2; y++)  {
			for (var x:int = 0; x < w * 2; x++) {
				// Make sure that x + shiftLookX never goes outside 
				// the dimensions of the table
				var texture_x:int = (distanceTable[x][y] + shiftX) % textureImg.width;
				var texture_y:int = (angleTable[x][y] + shiftY + textureImg.height) % textureImg.height;

				var color:uint = textureImg.getPixel(texture_x, texture_y);
				color = darken(color, 300 / distanceTable[x][y]);
				bmd.setPixel(x, y, color);
			}
		}
		bmdCache[i] = bmd;
	}

	private function draw():void{
		// looking left/right and up/down
		var shiftLookX:int = w / 2 + w / 4 * Math.sin(count / 20);
		var shiftLookY:int = h / 2 + h / 4 * Math.sin(count / 20 * 1.5);
		var rect:Rectangle = new Rectangle(shiftLookX, shiftLookY, w, h);

		tunnelEffect.copyPixels(bmdCache[count % CYCLE], rect, new Point(0, 0));
		count++;
	}

	private function darken(color:uint, brightness:Number):uint{
		brightness = brightness > 1 ? 1 : brightness < 0 ? 0 : brightness;
		return (((color & 0xff0000) >> 16) * brightness << 16)
		     + (((color & 0x00ff00) >>  8) * brightness <<  8)
		     + (((color & 0x0000ff)      ) * brightness      );
	}

	private function atan2(y:Number, x:Number):Number{
		if (x == 0) return Math.PI * (y > 0 ? .5 : -.5);
		if (x < 0 && y < 0) return Math.atan(y / x) - Math.PI;
		return Math.atan(y / x) + (x > 0 ? 0 : Math.PI)
	}
}
}
