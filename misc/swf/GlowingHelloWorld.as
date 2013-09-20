// Glowing Hellow World revised. (lines: 83 -> 73) 
//------------------------------------------------------- 
// An experiment on creating a dynamic glow text effect. 
// You can edit the text!!! 

package{ 
import flash.display.*; 
import flash.events.Event; 
import flash.filters.GlowFilter; 
import flash.geom.*; 
import flash.text.*; 

[SWF(backgroundColor="#000000", width="450", height="80")] 
public class GlowingHelloWorld extends Sprite{ 
    public function GlowingHelloWorld(){ 
        stage.scaleMode = "noScale"; 
        var ptZero:Point = new Point(); 

        // initialize canvas. 
        var bmpGlow:Bitmap = addChild(new Bitmap()) as Bitmap; 

        // Show original text (input) 
        var text:TextField = new TextField(); 
        text.autoSize = "left"; 
        text.type = "input"; 
        text.htmlText = <font size="50" color="#ffffff">HELLO WORLD</font>.toXMLString(); 
        addChild(text); 
        text.addEventListener("change", function(event:Event):void{ updateGlow() }); 

        // Create a glow BitmapData. 
        var bmdGlow:BitmapData, bmdCanvas:BitmapData; 
        var updateGlow:Function = function():void{ 
            // dispose existing BitmapData. 
            if (bmdGlow) bmdGlow.dispose(); 

            // Glow it. 
            bmdGlow = new BitmapData(text.textWidth + 10, text.textHeight + 10, true, 0);; 
            bmdGlow.draw(text); 
            var glow:GlowFilter = new GlowFilter(0xffffff, .9, 8, 8, 4); 
            bmdGlow.applyFilter(bmdGlow, bmdGlow.rect, ptZero, glow); 

            // Update canvas BitmapData. 
            bmpGlow.bitmapData = bmdGlow; 
        } 
        updateGlow(); 

        // Create a mask sprite. 
        var msk:Sprite = new Sprite(); 
        msk.graphics.beginGradientFill("radial", [0xffffff, 0xffffff], [1, 0], [64, 255]); 
        msk.graphics.drawCircle(0, 0, 100); 
        msk.graphics.endFill(); 
        addChild(msk);

        // Set mask.
        msk.y = 50 - text.textHeight / 2;
        bmpGlow.cacheAsBitmap = msk.cacheAsBitmap = true;
        bmpGlow.mask = msk;

        // Start animation loop. 
        var counter:int = 0; 
        addEventListener("enterFrame", function(event:Event):void{ 
            // move the mask
            msk.x = counter;

            // update counter... 
            counter += 14; 
            if (counter > 800){ 
                counter = -10; 
            } 
        }); 
    } 
} 
} 