package {
    import flash.display.*;
    import flash.geom.Point;

    [SWF(width="318", height="110", frameRate="2")]
    public class Labeling extends Sprite {
        [Embed(source="flex.gif")]
        private var FlexImage:Class;

        public function Labeling() {
            var bmp:Bitmap = new FlexImage();
            addChild(bmp);
            var bmd:BitmapData = bmp.bitmapData;

            // ２値化
            var bmd2:BitmapData = new BitmapData(bmd.width, bmd.height, false, 0x000000);
            bmd2.threshold(bmd, bmd.rect, new Point(), "<", 0xffffffff, 0xffffffff);

            // ラベリング
            var labeled:BitmapData = labeling2(bmd2);
            var bmp2:Bitmap = new Bitmap();
            addChild(bmp2).x = bmd.width;

            // 描画
            var lno:int = 0;
            var bmdtmp:BitmapData = labeled.clone();
            addEventListener("enterFrame", function(e:*):void {
                if(bmp2.bitmapData) bmp2.bitmapData.dispose();
                bmp2.bitmapData = extract2(labeled, ++lno);

                // ラベルが見つからなかったときは 0 に戻す
                if(!bmdtmp.threshold(bmp2.bitmapData, bmp2.bitmapData.rect, new Point(), "==", 0xffffffff)) {
                    lno = 0;
                }
            });
        }

        /** ラベリング
         * @param src ラベリング対象ビットマップデータ(モノクロ2値ビットマップ)
         * @return ラベリングデータ(整数の2次元配列)
         */
        public static function labeling2(src:BitmapData):BitmapData {
            var dst:BitmapData = src.clone(); // ソースの複製を作る
            var lno:int = 0;
            for (var x:int = 0; x < dst.width; x++) {
                for (var y:int = 0; y < dst.height; y++) {
                    if (dst.getPixel(x, y) == 0xFFFFFF) { // 白色の場合
                        dst.floodFill(x, y, ++lno);
                    }
                }
            }
            return dst;
        }

        /** ラベル値による画像の抜き出し
         * @param lbd ラベリングデータ
         * @param lno ラベル番号
         * @return 指定のラベル番号だけ抽出したイメージ
         */
        public static function extract2(lbd:BitmapData, lno:int):BitmapData {
            var dst:BitmapData = new BitmapData(lbd.width, lbd.height, true, 0xff000000);
            dst.threshold(lbd, lbd.rect, new Point(), "==", 0xff000000 + lno, 0xffffffff);
            return dst;
        }
    }
}