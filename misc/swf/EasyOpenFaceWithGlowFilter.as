// Easy Open Face with GlowFilter
//--------------------------------------------------
// GlowFilter ‚ÅŠÈ’P‘Ü•¶Žš
package{
import flash.display.*;
import flash.filters.GlowFilter;
import flash.text.*;

[SWF(backgroundColor="#ffffff", width="450", height="80")]
public class EasyOpenFaceWithGlowFilter extends Sprite{
    public function EasyOpenFaceWithGlowFilter(){
        stage.scaleMode = "noScale";

        // initialize canvas.
        var bmp:Bitmap = addChild(new Bitmap()) as Bitmap;

        // Show original text (input)
        var text:TextField = new TextField();
        text.autoSize = "left";
        text.type = "input";
        text.htmlText = <font size="50" face="Verdana" color="#ffffff">HELLO WORLD</font>.toXMLString();
        addChild(text);

        // Glow it
        text.filters = [new GlowFilter(0x000000, 1, 8, 8, 16, 1)];
    }
}
}