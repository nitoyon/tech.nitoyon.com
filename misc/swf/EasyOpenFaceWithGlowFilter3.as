// GlowFilter Ç≈ÇQèdä»íPë‹ï∂éö
package{
import flash.display.Sprite;
import flash.filters.GlowFilter;
import flash.text.TextField;

public class EasyOpenFaceWithGlowFilter3 extends Sprite{
    public function EasyOpenFaceWithGlowFilter3(){
        stage.align = "TL";
        stage.scaleMode = "noScale";

        // Show original text (input)
        var text:TextField = new TextField();
        text.autoSize = "left";
        text.type = "input";
        text.htmlText = <font size="50" color="#ff0000">HELLO WORLD</font>.toXMLString();
        addChild(text);

        // Glow it
        text.filters = [new GlowFilter(0xffffff, 1, 8, 8, 16, 1),
                        new GlowFilter(0x0000ff, 1, 8, 8, 16, 1)];
    }
}
}
