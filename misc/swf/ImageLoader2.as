package {
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.LoaderContext;

    [SWF(width="300", height="80", backgroundColor="#ffffff")]
    public class ImageLoader2 extends Sprite {

        public function ImageLoader2() {
            stage.scaleMode = "noScale";
            stage.align = "TL";

            var colorPreview:Sprite = new Sprite();
            addChild(colorPreview);

            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void {
                var bmd:BitmapData = new BitmapData(loader.width, loader.height);
                bmd.draw(loader);

                colorPreview.x = loader.width + 20;
                colorPreview.y = 20;

                stage.addEventListener("mouseMove", function(e:MouseEvent):void {
                    var g:Graphics = colorPreview.graphics;
                    g.clear();

                    if(stage.mouseX < loader.width && stage.mouseY < loader.height) {
                        g.lineStyle(1, 0);
                        g.beginFill(bmd.getPixel(stage.mouseX, stage.mouseY));
                        g.drawRect(0, 0, 30, 30);
                        g.endFill();
                    }
                });
            });

            var context:LoaderContext = new LoaderContext(true);
            var req:URLRequest = new URLRequest("http://assets3.twitter.com/images/twitter.gif");
            loader.load(req, context);
            addChild(loader);
        }
    }
}
