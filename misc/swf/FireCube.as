// Processing FireCube (AS3 version) 
// original source: http://processing.org/learning/topics/firecube.html
package {
import flash.display.*;
import flash.filters.*;
import flash.geom.*;

public class FireCube extends Sprite{
    private const WIDTH:int = 200;
    private const HEIGHT:int = 150;

    public function FireCube(){
        stage.align = "TL";
        stage.scaleMode = "noScale";
        scaleX = scaleY = 2;

        // Create circle
        var circle:Sprite = new Sprite();
        circle.graphics.beginFill(0x808080);
        circle.graphics.drawCircle(0, 0, 10);
        circle.graphics.endFill();

        // Create buffered image
        var fire:BitmapData = new BitmapData(WIDTH, HEIGHT, false, 0);
        var pg:BitmapData = fire.clone();
        var noiseBmd:BitmapData = new BitmapData(WIDTH, 1);

        var bmp:Bitmap = new Bitmap(pg);
        addChild(bmp);

        // Generate the palette
        var r:Array = [], g:Array = [], b:Array = [];
        for(var x:int = 0; x < 256; x++) {
            //Hue goes from 0 to 85: red to yellow
            //Saturation is always the maximum: 255
            //Lightness is 0..255 for x=0..128, and 255 for x=128..255
            HSVtoRGB(x / 3, 1, Math.min(x * 3 / 255.0, 1), r, g, b);
        }

        // Use ConvolutionFilter to calculate for every pixel
        var filter:ConvolutionFilter = new ConvolutionFilter(3, 3, [0, 0, 0, 16, 16, 16, 0, 16, 0], 65);

        // Prepare points and matrix
        var matrix:Matrix = new Matrix();
        var pt0:Point = new Point(0, HEIGHT - 1);
        var pt1:Point = new Point(0, -1);
        var pt2:Point = new Point(0, 1);

        // Do loop
        addEventListener("enterFrame", function(event:*):void{
            // Randomize the bottom row of the fire buffer
            noiseBmd.noise(Math.random() * 0xffffffff, 0, 190, 7, true);
            fire.copyPixels(noiseBmd, noiseBmd.rect, pt0);

            // Display circle
            matrix.tx = mouseX;
            matrix.ty = mouseY;
            fire.draw(circle, matrix);

            // Add pixel values around current pixel
            fire.applyFilter(fire, fire.rect, pt1, filter);

            // Output everything to screen using our palette colors
            pg.paletteMap(fire, fire.rect, pt2, r, g, b);
        });
    }

    // AS3 does not natively support HSV...  :-(
    private function HSVtoRGB(h:int, s:Number, v:Number, r:Array, g:Array, b:Array):void {
        if (h < 60) {
            r.push((v * 255) << 16);
            g.push((v * (1 - (1 - h / 60.0) * s) * 255) << 8)
            b.push(v * (1 - s) * 255);
        } else if (h < 120) {
            r.push((v * (1 - (-h / 60.0 - 1) * s) * 255) << 16);
            g.push((v * 255) << 8);
            b.push(v * (1 - s) * 255);
        } else {
            throw Error('not implemented');
        }
    }
}
}
