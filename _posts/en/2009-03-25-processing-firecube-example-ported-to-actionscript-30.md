---
layout: post
title: Processing "FireCube" example ported to ActionScript 3.0
lang: en
tag: ActionScript
---
<center><img src="http://f.hatena.ne.jp/images/fotolife/n/nitoyon/20090309/20090309001432.png" width="398" height="168"></center>

Processing example [FireCube](http://processing.org/learning/topics/firecube.html) is so interesting to me. I ported it to ActionScript 3.0.

The result is...

<center><script src="http://www.gmodules.com/ig/ifr?url=http://nitoyon.googlepages.com/embed_flash.xml&amp;up_url=http%3A%2F%2Ftech.nitoyon.com%2Fmisc%2Fswf%2FFireCube.swf&amp;up_background=%23ffffff&amp;synd=open&amp;w=400&amp;h=300&amp;title=AS3.0+FireCube&amp;border=%23ffffff%7C3px%2C1px+solid+%23999999&amp;output=js"> </script><noscript>(Flash Player 9  or later required)</noscript></center>

Performance improvement
=======================

[Processing version](http://processing.org/learning/topics/firecube.html) calculates every pixel color when
* creating noise,
* combining values from adjacent pixels and
* converting color.

So I implement it as follows:
* creating noise -> `BitmapData.noise()`
* combining values from adjacent pixels -> `ConvolutionFilter`
* converting color -> `BitmapData.paletteMap()`

Difficulty
==========

HSV color space is not supported in AS3! I created a function called `HSVtoRGB`.

Drawing a cube was a pain. So, I changed a cube to circle...

Here is the code: (83 lines)

{%highlight actionscript%}
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
{%endhighlight%}