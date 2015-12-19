---
layout: post
title: 50 polygons Mona Lisa in AS3
lang: en
tag: ActionScript
---
I ported [Image evolution](http://alteredqualia.com/visualization/evolve/) to ActionScript 3. 

> We start from random 50 polygons that are invisible. In each optimization step
> we randomly modify one parameter (like color components or polygon vertices)
> and check whether such new variant looks more like the original image.
> If it is, we keep it, and continue to mutate this one instead.

In my computer, the result was as follows.

<center><img src="http://f.hatena.ne.jp/images/fotolife/n/nitoyon/20090217/20090217014358.jpg" width="450" height="378"></center>

It's waste of CPU.., but very interesting.

Published SWF (CAUSION: TOO HEAVY CPU 60%~)

{% include flash.html src="/misc/swf/MonalisaEvolve.swf" bgcolor="#ffffff" width="450" height="420" %}

Because this program uses `BitmapData.compare()` to improve performance, it is about 10 times faster than the [JavaScript version](http://alteredqualia.com/visualization/evolve/). The original [C# version](http://rogeralsing.com/2008/12/11/genetic-programming-mona-lisa-source-code-and-binaries/) is about 3 times faster than mine.

Here is the code: (189lines)

{%highlight actionscript%}
package{
import flash.display.*;
import flash.text.*;
import flash.geom.*;
import flash.filters.ColorMatrixFilter;
import flash.utils.setInterval;

[SWF(backgroundColor="#eeeeee")]
public class Evolve extends Sprite{
    [Embed(source='mona_lisa_crop.jpg')]
    private var MonaLisa:Class;
    private var imgWidth:int;
    private var imgHeight:int;

    private const POLYGONS:int = 50;
    private var polygons:Array = [];
    private var mutating:Boolean = false;

    private var monotoneFilter:ColorMatrixFilter = new ColorMatrixFilter([
            1 / 3, 1 / 3, 1 / 3, 0, 0, 
            1 / 3, 1 / 3, 1 / 3, 0, 0, 
            1 / 3, 1 / 3, 1 / 3, 0, 0, 
                0,     0,     0, 1, 0 ]);
    private var pt0:Point = new Point(0, 0);
    private var rect:Rectangle;

    private var bestBmd:BitmapData;
    private var testBmd:BitmapData;
    private var inputBmd:BitmapData;
    private var debugBmd:BitmapData;

    private var canvas:Sprite;

    private var score:uint;
    private var scoreMax:uint;
    private var mutations:uint = 0;
    private var candidates:uint = 0;
    private var totalTime:Number = 0;
    private var time:Date;
    private var scoreText:TextField;

    public function Evolve(){
        stage.scaleMode = "noScale";
        stage.align = "TL";

        // init image
        var bmp:Bitmap = new MonaLisa();
        inputBmd = bmp.bitmapData;
        addChild(bmp);
        imgWidth = bmp.width;
        imgHeight = bmp.height;
        rect = inputBmd.rect;
        score = scoreMax = rect.width * rect.height * 255;

        // init buffer
        bestBmd = inputBmd.clone(); bestBmd.fillRect(rect, 0x000000);
        testBmd = inputBmd.clone(); testBmd.fillRect(rect, 0x000000);
        debugBmd = inputBmd.clone();
        addChild(new Bitmap(bestBmd)).x = bmp.width + 10;

        // init data and canvas
        canvas = new Sprite();
        for(var i:int = 0; i < POLYGONS; i++){
            polygons[i] = new Polygon();
            canvas.addChild(new Sprite());
        }
        drawTest();
        testToBest();

        // init ui
        var tf:TextField = new TextField();
        tf.text = "click to start";
        tf.y = bmp.height + 10;
        tf.scaleX = tf.scaleY = 3;
        addChild(tf);
        stage.addEventListener("click", function(event:*):void{
            mutating = !mutating;
            time = (mutating ? new Date() : null);
            tf.text = (mutating ? "Now Simulating..." : "click to start");
        });
        scoreText = new TextField();
        scoreText.autoSize = "left";
        scoreText.y = bmp.height + 60;
        scoreText.scaleX = scoreText.scaleY = 3;
        addChild(scoreText);

        // start timer
        setInterval(update, 10);
    }

    private function update():void{
        if(!mutating) return;
        var t:Date = new Date();
        totalTime += (t.getTime() - time.getTime()) / 1000;
        time = t;

        for(var i:int = 0; i < 10; i++) update1();
        scoreText.text = (int((1 - score / scoreMax) * 10000) / 100)
             + "%\n" + mutations + " / " + candidates + "\n"
             + (int(totalTime * 10) / 10) + "s";
    }

    private function update1():void{
        var index:int = Math.random() * POLYGONS;
        var backup:Polygon = polygons[index].clone();
        polygons[index].mutate();
        drawTest();

        var diffBmd:BitmapData = testBmd.compare(inputBmd) as BitmapData;
        diffBmd.applyFilter(diffBmd, rect, pt0, monotoneFilter);
        var testScore:uint = 0;
        for(var i:int = 0; i < 0x100; i++){
            testScore += diffBmd.threshold(diffBmd, rect, pt0, "==", i, i, 0xff) * i;
        }

        if(score > testScore){
            score = testScore;
            testToBest();
            mutations++;
        }else{
            polygons[index] = backup;
        }
        candidates++;
    }

    private function drawTest():void{
        canvas.graphics.clear();
        for(var i:int = 0; i < POLYGONS; i++){
            polygons[i].draw(canvas, imgWidth, imgHeight);
        }

        testBmd.fillRect(rect, 0x000000);
        testBmd.draw(canvas);
    }

    private function testToBest():void{
        bestBmd.copyPixels(testBmd, rect, pt0);
    }
}
}

import flash.display.*;
import flash.geom.*;

class Polygon{
    private const POINTS:int = 6;

    public var points:Array = [];
    public var color:uint;
    public var alpha:Number;

    public function Polygon(polygon:Polygon = null){
        for(var i:int = 0; i < POINTS; i++)
            points[i] = (polygon ? polygon.points[i].clone() : new Point(Math.random(), Math.random()));
        color = (polygon ? polygon.color : 0xffffff * Math.random());
        alpha = (polygon ? polygon.alpha : .1);
    }

    public function clone():Polygon{
        return new Polygon(this);
    }

    public function mutate():void{
        (Math.random() < 0.5 ? mutateColor() : mutatePosition());
    }

    private function mutateColor():void{
        switch(int(Math.random() * 4)){
            case 0: color = (color & 0x00ffff) + int(Math.random() * 255) * 0x010000; break;
            case 1: color = (color & 0xff00ff) + int(Math.random() * 255) * 0x000100; break;
            case 2: color = (color & 0xffff00) + int(Math.random() * 255) * 0x000001; break;
            case 3: alpha = Math.random(); break;
        }
    }

    private function mutatePosition():void{
        var p:int = Math.random() * POINTS;
        if(Math.random() < .5) points[p].x = Math.random();
        else                   points[p].y = Math.random();
    }

    public function draw(canvas:Sprite, w:Number, h:Number):void{
        canvas.graphics.beginFill(color, alpha);
        canvas.graphics.moveTo(points[0].x * w, points[0].y * h);
        for(var i:int = 1; i < POINTS; i++)
            canvas.graphics.lineTo(points[i].x * w, points[i].y * h);
        canvas.graphics.endFill();
    }
}
{%endhighlight%}