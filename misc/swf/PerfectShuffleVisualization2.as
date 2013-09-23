package {
import flash.display.*;
import flash.events.Event;
import flash.geom.Point;
import flash.filters.BlurFilter;
import flash.text.TextField;
import org.libspark.betweenas3.BetweenAS3;
import org.libspark.betweenas3.tweens.ITween;
import org.libspark.betweenas3.easing.*;
import frocessing.color.ColorHSV;

[SWF(backgroundColor="0x000000")]
public class PerfectShuffleVisualization2 extends Sprite {
    public var r:Number = 800;
    public var d:Number = 80;
    public var angle:Number = 6;
    private const NUM:int = 5;
    private const SIZE:int = 30;
    private var msk:Sprite;
    
    public function PerfectShuffleVisualization2() {
        stage.scaleMode = "noScale";
        stage.align = "TL";

        var t:TextField = new TextField();
        t.text = "Click to play!!";
        t.textColor = 0xffffff;
        addChild(t);
        x = 240; y = 240;
        draw();

        var tween:ITween = BetweenAS3.parallel(
            BetweenAS3.tween(this, { r: 30 }, null, 5, Quint.easeOut),
            BetweenAS3.tween(this, { angle: 360, d: 160 }, null, 5)
        );
        tween.onUpdate = draw;
        stage.addEventListener("click", function(event:Event):void {
            if (t.parent) t.parent.removeChild(t);
            tween.play();
           });

        filters = [new BlurFilter(2, 2)];
    }

    private function draw():void {
        var p:Point = new Point();
        var g:Graphics = graphics;
        g.clear();

        // draw lines
        for (var yy:int = 0; yy < SIZE; yy++) {
            var num:int = yy;
            g.lineStyle(2, new ColorHSV(yy * 270 / SIZE, .7).value, .7);
            p.x = 0; p.y = num; getXY(p);
            g.moveTo(p.x, p.y);
            for (var xx:int = 1; xx <= NUM; xx++) {
                num = getNext(num);
                p.x = xx; p.y = num; getXY(p);
                g.lineTo(p.x, p.y);
            }
        }
    }

    // get next position after perfect shuffle
    private function getNext(num:int):int {
        if (num < SIZE / 2) {
            return num * 2 + 1;
        } else {
            return (num - SIZE / 2) * 2;
        }
    }

    private function getXY(pt:Point):Point {
        var rad:Number = (-angle / 2.0 + angle * pt.x / NUM) / 180.0 * Math.PI;
        pt.x =  (r + d / (SIZE - 1) * pt.y) * Math.sin(rad);
        pt.y = -(r + d / (SIZE - 1) * pt.y) * Math.cos(rad) + r * Math.cos(angle / 2 / 180 * Math.PI);
        return pt;
    }
}
}
