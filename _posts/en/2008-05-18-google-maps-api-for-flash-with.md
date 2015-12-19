---
layout: post
title: Google Maps API for Flash without MXML
lang: en
tags: [ActionScript, Google Maps]
---
In the [Google Maps API for Flash](http://code.google.com/apis/maps/documentation/flash/index.html) tutorial, a sample using MXML is introduced. But MXML is not required, because `com.google.maps.Map` class derives from `Sprite` class.

The following sample demonstrates how to rotate and blur the map without MXML.

{% include flash.html src="/misc/swf/GoogleGuruGuru.swf" bgcolor="#ffffff" width="400" height="300" %}

Here is the code:

{% highlight actionscript %}
package {
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.filters.BlurFilter;
    import com.google.maps.Map;
    import com.google.maps.MapEvent;
    import com.google.maps.MapType;
    import com.google.maps.LatLng;

    public class GoogleGuruGuru extends Map {
        public function GoogleGuruGuru() {
            super();
            key = "ABQIAAAA6de2NwhEAYfH7t7oAYcX3xRWPxFShKMZYAUclLzloAj2mNQgoRQZnk8BRyG0g_m2di3bWaT-Ji54Lg";

            addEventListener(MapEvent.MAP_READY, function(event:Event):void{
                setCenter(new LatLng(35.003759, 135.769322), 18, MapType.NORMAL_MAP_TYPE);
            });

            var r:int = 0;
            var scale:Number = 1;
            addEventListener("enterFrame", function(event:Event):void{
                r = (r + 1) % 360;
                var rad:Number = 2 * Math.PI * r / 360;

                var matrix:Matrix = new Matrix();
                matrix.translate(-stage.stageWidth / 2, -stage.stageHeight / 2);
                matrix.rotate(rad);
                matrix.translate(stage.stageWidth / 2, stage.stageHeight / 2);
                transform.matrix = matrix;
            });

            stage.addEventListener("mouseDown", function(event:Event):void{
                filters = [new BlurFilter(10, 10)];
            }, true);
            stage.addEventListener("mouseUp", function(event:Event):void{
                filters = [];
            });
        }
    }
}
{% endhighlight %}
