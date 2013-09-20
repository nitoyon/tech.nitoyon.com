package {
    import flash.display.Sprite;
    import flash.filters.DropShadowFilter;

    import org.libspark.swfassist.io.*;
    import org.libspark.swfassist.swf.io.*;
    import org.libspark.swfassist.swf.structures.SWF;
    import org.libspark.swfassist.swf.structures.Shape;
    import org.libspark.swfassist.swf.structures.ShapeRecord;
    import org.libspark.swfassist.swf.structures.ShapeRecordTypeConstants;
    import org.libspark.swfassist.inprogress.swf.ShapeCollector;
    import org.libspark.swfassist.flash.display.ShapeDrawer;
    import org.libspark.swfassist.flash.display.ShapeOutlineDrawer;
    import org.libspark.swfassist.flash.display.FlashGraphics;

    public class Pop2 extends Sprite {
        [Embed(source='アニトＭ-教漢.TTF', fontName='anito', unicodeRange='U+58F2,U+5927,U+5B89')]
        private var font:Class;

        public function Pop2(){
            stage.align = "TL";
            stage.scaleMode = "noScale";

            var input:DataInput = new ByteArrayInputStream(loaderInfo.bytes);
            var context:ReadingContext = new ReadingContext();
            var reader:SWFReader = new SWFReader();
            var swf:SWF = reader.readSWF(input, context);

            var shapeCollector:ShapeCollector = new ShapeCollector();
            swf.visit(shapeCollector);

            var drawer:ShapeOutlineDrawer = new ShapeOutlineDrawer();
            var s1:Sprite = draw(shapeCollector.shapes[2], drawer);
            var s2:Sprite = draw(shapeCollector.shapes[3], drawer);
            var s3:Sprite = draw(shapeCollector.shapes[1], drawer);

            addChild(s1); s1.x =  10; s1.y = 50;
            addChild(s2); s2.x =  60; s2.y = 50;
            addChild(s3); s3.x = 110; s3.y = 50;

            scaleX = scaleY = 2;
            filters = [new DropShadowFilter(4, 45, 0x000080, 1, 0, 0)];
        }

        private function draw(shape:Shape, drawer:ShapeOutlineDrawer):Sprite{
            var ret:Sprite = new Sprite();

            drawer.graphics = new FlashGraphics(ret.graphics);
            ret.graphics.lineStyle(5, 0xff0000);
            ret.graphics.beginFill(0xff0000);
            drawer.draw(shape);
            ret.graphics.endFill();

            ret.graphics.lineStyle(1, 0xffffff);
            drawer.draw(shape);
            ret.graphics.endFill();

            return ret;
        }
    }
}

