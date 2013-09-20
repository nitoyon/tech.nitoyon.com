// Easy Dynamic Text Mask
package{
import flash.display.*;
import flash.events.Event;
import flash.text.*;

[SWF(backgroundColor="#ffffff", width="450", height="80")]
public class EasyDynamicTextMask extends Sprite{
    public function EasyDynamicTextMask(){
        stage.scaleMode = "noScale";

        // Show original text (input)
        var text:TextField = new TextField();
        text.type = "input";
        text.autoSize = "left";
        text.htmlText = <font size="50" color="#000000">HELLO WORLD</font>.toXMLString();
        addChild(text);

        // Create sprite
        var sprite:Sprite = new Sprite();
        addChild(sprite);

        // Set text as mask
        sprite.mask = text;
        text.cacheAsBitmap = sprite.cacheAsBitmap = true;
        
        // Draw sprite
        addEventListener("enterFrame", function(event:Event):void{
            sprite.graphics.beginFill(Math.random() * 0xffffff);
            sprite.graphics.drawCircle(Math.random() * 450, Math.random() * 80, Math.random() * 50);
            sprite.graphics.endFill();

            if (Math.random() < .02){
                sprite.graphics.clear();
            }
        });
    }
}
}