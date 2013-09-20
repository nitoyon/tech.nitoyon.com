package {
    import flash.display.*;
    import flash.geom.*;

    public class BitmapOffset extends Sprite {
        [Embed(source='techni.png')]
        private var Logo:Class;

        private var size:Number = 5;
        private static const SIGN:int = 20;
        private static const MARGIN:int = 20;
        private var brush:Sprite;
        private var bmd:BitmapData;
        private var bmd1:BitmapData;
        private var bmd2:BitmapData;

        public function BitmapOffset() {
            stage.scaleMode = "noScale";
            stage.align = "TL";
            var bmp:Bitmap = new Logo();
            addChild(bmp);

            bmd  = bmp.bitmapData;
            bmd1 = new BitmapData(bmd.width, bmd.height, false);
            bmd2 = new BitmapData(bmd.width, bmd.height);

            var curX:int = bmd.width + MARGIN;
            var curY:int = bmd.height / 2;

            // x
            graphics.lineStyle(5, 0xff0000, 1, false, "normal", "none");
            graphics.moveTo(curX       , curY - SIGN / 2);
            graphics.lineTo(curX + SIGN, curY + SIGN / 2);
            graphics.moveTo(curX       , curY + SIGN / 2);
            graphics.lineTo(curX + SIGN, curY - SIGN / 2);

            // brush
            curX += SIGN + MARGIN;
            addChild(brush = new Sprite()).x = curX + bmd.width * 0.25;
            brush.y = curY;

            // =
            curX += bmd.width / 2 + MARGIN;
            graphics.lineStyle(5, 0x0099ff, 1, false, "normal", "none");
            graphics.moveTo(curX       , curY - SIGN * 0.3);
            graphics.lineTo(curX + SIGN, curY - SIGN * 0.3);
            graphics.moveTo(curX       , curY + SIGN * 0.3);
            graphics.lineTo(curX + SIGN, curY + SIGN * 0.3);

            // result
            curX += SIGN + MARGIN;
            addChild(new Bitmap(bmd2)).x = curX;

            draw();
            stage.addEventListener("click", function(event:*):void {
                size = size < 10 ? size + 1 : 1;
                draw();
            });
        }

        private function draw():void {
            bmd1.fillRect(bmd.rect, 0xffffff);
            bmd2.fillRect(bmd.rect, 0xffffff);

            brush.graphics.clear();
            brush.graphics.beginFill(0);
            brush.graphics.drawCircle(0, 0, size / 2);
            brush.graphics.endFill();

            var m:Matrix = new Matrix();
            m.tx = m.ty = size / 2;
            bmd1.draw(brush, m);

            var c:ColorTransform = new ColorTransform();
            for(var i:int = 0; i < size * size; i++) {
                m.tx = i % 5; m.ty = Math.floor(i / 5);
                var alpha:int = -bmd1.getPixel(m.tx, m.ty) % 0x100;
                c.alphaOffset = alpha;
                m.tx -= size / 2; m.ty -= size / 2;
                bmd2.draw(bmd, m, c);
            }
        }
    }
}
