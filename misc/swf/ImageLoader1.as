package {
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.filters.*;
    import flash.geom.*;

    [SWF(width="200", height="100", backgroundColor="#ffffff")]
    public class ImageLoader1 extends Sprite {
        public static const RADIUS:int = 50;
        
        public function ImageLoader1() {
            stage.scaleMode = "noScale";
            stage.align = "TL";

            var loader:Loader = new Loader();

            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void {
                var bmd:BitmapData = createMap(RADIUS);
                loader.scaleY = 1.5;
                loader.alpha = 0.6;
                loader.rotation = 0;
                var cmf:ColorMatrixFilter = new ColorMatrixFilter([
                    0, 1, 0, 0, 0, 
                    0, 0, 1, 0, 0, 
                    1, 0, 0, 0, 0, 
                    0, 0, 0, 1, 0
                ]);
                loader.filters = [cmf];

                // 座標ごとにフィルタを変更
                stage.addEventListener("mouseMove", function(e:MouseEvent):void {
                    var dmf:DisplacementMapFilter = new DisplacementMapFilter(bmd,
                            new Point(stage.mouseX - RADIUS/2,stage.mouseY-RADIUS/2),
                            BitmapDataChannel.RED,BitmapDataChannel.BLUE, 256, 256,"color",0x0);
                    // フィルタを適用
                    loader.filters = [dmf, cmf];
                });
            });

            var req:URLRequest = new URLRequest("http://img.mixi.jp/img/basic/common/mixilogo001.gif");
            loader.load(req);
            addChild(loader);
        }

        // Special thanks: http://yamasv.blog92.fc2.com/blog-entry-80.html
        private function createMap(radius:int):BitmapData{
            var bmd:BitmapData = new BitmapData(radius, radius, false, 0xffffff);

            // distance 計算用
            var center:Point = new Point(radius / 2, radius / 2);
            var cur:Point = new Point();

            // 虫眼鏡
            for(var j:int = 0; j < radius; j++){
                for(var i:int = 0; i < radius; i++){
                    cur.x = i; cur.y = j;
                    var distance:Number = Point.distance(center, cur);

                    if(distance > radius / 2) {
                        // 円の外側は変形しない
                        bmd.setPixel(i,j,(128<<16)+ 128);
                    }
                    else {
                        // 内側なら歪ませて拡大
                        var ratio:Number = distance/ (radius / 2);
                        var colR:int = 128 + (radius / 2 - i) * 0.5 * ratio;
                        var colB:int = 128 + (radius / 2 - j) * 0.5 * ratio;
                        bmd.setPixel(i, j, (colR << 16) + colB);
                    }
                }
            }
            return bmd;
        }
    }
}
