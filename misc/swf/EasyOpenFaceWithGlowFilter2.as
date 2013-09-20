package{
import flash.display.*;
import flash.filters.GlowFilter;
import flash.filters.DropShadowFilter;
import flash.text.*;

[SWF(backgroundColor="#ffffff", width="450", height="80")]
public class EasyOpenFaceWithGlowFilter2 extends Sprite{
    public function EasyOpenFaceWithGlowFilter2(){
        stage.scaleMode = "noScale";

        // initialize canvas.
        var bmp:Bitmap = addChild(new Bitmap()) as Bitmap;

        // Show original text (input)
        var text:TextField = new TextField();
        text.autoSize = "left";
        text.type = "input";
        text.htmlText = <font size="50" color="#ffffff">HELLO WORLD</font>.toXMLString();
        addChild(text);

        // Glow it
        text.filters = [
            new GlowFilter(0x000000, 1, 4, 4, 16, 1),
            new DropShadowFilter(4, 45, 0x000000, 1, 4, 4, 16)
        ];
    }
}
}