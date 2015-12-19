---
layout: post
title: Keynote-like cube transition by FIVe3D
lang: en
tag: ActionScript
---
I tried <a href="http://five3d.mathieu-badimon.com/">FIVe3D</a> v2.1, very simple 3D library. For example, `Graphics3D` class has method like `lineTo()` and `drawCircle()`. Looks like Graphics class!!

I created an example 'Keynote-like cube transition' using `Bitmap3D` class.

{% include flash.html src="/misc/swf/Five3dCubeEffect.swf" bgcolor="#ffffff" width="400" height="265" %}

I refered to [unic8 Studios - Flex Cube - 3D OSX look](http://www.unic8.com/en/news/labs/flexcube-os-x-3d-look-2.html), which uses PV3D.

FIVe3D doesn't execute hidden surface removal, so I used `setChildIndex()` in the `onUpdate` callback of Tweener.

And since `fl.motion.Color` was not in Flex SDK, I commented out to compile :)

Here is the code:

{% highlight actionscript %}
package {
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.utils.setInterval;
    import five3D.display.*;

    import caurina.transitions.Tweener;

    public class Five3dCubeEffect extends Sprite {
        private const WIDTH:int = 400;
        private const HEIGHT:int = 267;

        [Embed(source="1.jpg")]
        private var Image1:Class;
        [Embed(source="2.jpg")]
        private var Image2:Class;
        [Embed(source="3.jpg")]
        private var Image3:Class;

        private var isCube:int = -1;

        public function Five3dCubeEffect() {
            stage.scaleMode = "noScale";
            stage.align = "TL";

            var images:Array = [];
            images.push(new Image1());
            images.push(new Image2());
            images.push(new Image3());

            addChild(images[0]);
            var index:int = 0;

            setInterval(function():void{
                isCube = (Math.random() < 0.5 ? 1 : -1);
                transition(images[index], images[(index + 1) % images.length]);
                index = (index + 1) % images.length;
            }, 3500);
        }

        private function transition(bmp1:Bitmap, bmp2:Bitmap):void {
            var scene:Scene3D = new Scene3D();
            scene.x = WIDTH / 2;
            scene.y = HEIGHT / 2;
            addChild(scene);

            var box:Sprite3D = new Sprite3D();
            box.z = isCube * WIDTH / 2;
            scene.addChild(box);

            var img2:Bitmap3D = new Bitmap3D(bmp2.bitmapData);
            box.addChild(img2);
            img2.x = WIDTH / 2;
            img2.y = -HEIGHT / 2;
            img2.z = -isCube * WIDTH / 2;
            img2.rotationY = -isCube * 90;

            var img1:Bitmap3D = new Bitmap3D(bmp1.bitmapData);
            box.addChild(img1);
            img1.x = -WIDTH / 2;
            img1.y = -HEIGHT / 2;
            img1.z = -isCube * WIDTH / 2;

            Tweener.addTween(box, {
                time: 1.5,
                rotationY: isCube * 90,
                transition: "easeInOutCubic",
                onStart: function():void{
                    removeChild(bmp1);
                },
                onUpdate: function():void{
                    if(Math.abs(box.rotationY) > 45){
                        box.setChildIndex(img1, 0);
                    }
                },
                onComplete: function():void{
                    box.parent.removeChild(box);
                    addChild(bmp2);
                }
            });
        }
    }
}
{% endhighlight %}