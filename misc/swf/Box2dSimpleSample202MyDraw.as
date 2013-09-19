package {
import Box2D.Dynamics.*;
import Box2D.Collision.*;
import Box2D.Collision.Shapes.*;
import Box2D.Common.Math.*;
import flash.events.Event;
import flash.display.*;
import flash.text.TextField;

[SWF(backgroundColor="#ccddff")]
public class Box2dSimpleSample202MyDraw extends Sprite {
    private const SCALE:Number = 10;
    private var world:b2World;

    [Embed(source="icon.png")]
    private var Icon:Class;

    // コンストラクタ
    public function Box2dSimpleSample202MyDraw() {
        stage.scaleMode = "noScale";
        stage.align = "TL";

        // メッセージとクリック時の処理
        var tf:TextField = new TextField();
        tf.text = "Click to start";
        addChild(tf);
        var animation:Boolean = false;
        stage.addEventListener("click", function(event:Event):void{
            count = 0;
            animation = !animation;
            tf.text = "Click to " + (animation ? "stop" : "start");
        });

        // 初期化
        init();
        createObject();

        // 毎フレームの処理
        var count:int = 0;
        addEventListener("enterFrame", function(event:Event):void {
            world.Step(1 / 9, 10);
            if (count == 0 && animation){
                createObject();
            }
            count = (count + 1) % 30;

            // 下に行ったオブジェクトを削除する
            for (var b:b2Body = world.GetBodyList(); b; b = b.GetNext()) {
                var sprite:Sprite = b.GetUserData() as Sprite;
                if (sprite){
                    sprite.x = b.GetWorldCenter().x * SCALE;
                    sprite.y = b.GetWorldCenter().y * SCALE;
                    sprite.rotation = b.GetAngle() * 180 / Math.PI;

                    if (sprite.y > 600){
                        world.DestroyBody(b);
                        removeChild(sprite);
                    }
                }
            }
        });
    }

    // 初期化
    private function init():void {
        //----------------------------------
        // 世界を作成する
        //----------------------------------
        // シミュレーションする座標の範囲を指定する
        var worldAABB:b2AABB = new b2AABB();
        worldAABB.lowerBound.Set(-100.0, -100.0);
        worldAABB.upperBound.Set(100.0, 100.0);

        // 重力を定義する
        var gravity:b2Vec2 = new b2Vec2(0.0, 10.0);

        // 世界のインスタンスを作成する
        world = new b2World(worldAABB, gravity, true);

        //----------------------------------
        // 床を作る
        //----------------------------------
        // 物体の定義を作る
        var wallBdDef:b2BodyDef = new b2BodyDef();
        wallBdDef.position.Set(400 / 2 / SCALE, 300 / SCALE);
        wallBdDef.angle = Math.PI / 24;

        // 物体を作る
        var wallBd:b2Body = world.CreateBody(wallBdDef);

        // 形の定義を作る
        var wallShapeDef:b2PolygonDef = new b2PolygonDef();
        wallShapeDef.SetAsBox(180 / SCALE, 10 / SCALE);

        // 形を物体に追加する
        wallBd.CreateShape(wallShapeDef);

        //----------------------------------
        // 床を直接描画する
        //----------------------------------
        var floorSprite:Sprite = new Sprite();
        floorSprite.graphics.beginFill(0x667788);
        floorSprite.graphics.drawRect(-180, -10, 360, 20);
        floorSprite.graphics.endFill();
        floorSprite.x = 400 / 2;
        floorSprite.y = 300;
        floorSprite.rotation = 180 / 24;
        addChild(floorSprite);
    }

    // 物体を１個作る
    private function createObject():void{
        // 物体の定義を作る (x 座標と角度はランダム)
        var objBdDef:b2BodyDef = new b2BodyDef();
        objBdDef.position.Set((300 * Math.random()) / SCALE, 0);
        objBdDef.angle = Math.PI / 2 * Math.random();

        // 物体を作る
        var objBd:b2Body = world.CreateBody(objBdDef);

        // 形の定義を作る
        var shapeDef:b2PolygonDef = new b2PolygonDef();
        shapeDef.SetAsBox(30 / SCALE, 30 / SCALE);
        shapeDef.density = 1;
        shapeDef.restitution = 0.4;
        shapeDef.friction = 0.1;

        // 形を物体に追加する
        objBd.CreateShape(shapeDef);

        // 定義を変更してもう１個の形を追加する
        shapeDef.SetAsBox(40 / SCALE, 5 / SCALE);
        objBd.CreateShape(shapeDef);

        // 重心を計算する
        objBd.SetMassFromShapes();

        // Sprite を m_userData に割り当てる
        var sprite:Sprite = createSprite();
        sprite.x = sprite.y = -9999; // 画面外に移動
        addChild(sprite);
        objBd.m_userData = sprite;
    }

    // 物体の Sprite を作成する
    private function createSprite():Sprite{
        var ret:Sprite = new Sprite();

        // 細長い横枠を描画
        ret.graphics.lineStyle(1, 0x000000);
        ret.graphics.beginFill(0x008000);
        ret.graphics.drawRect(-40, -5, 80, 10);
        ret.graphics.endFill();

        // 画像
        var bmp:Bitmap = new Icon();
        bmp.x = bmp.y = -30;
        ret.addChild(bmp);

        // 画像の周りの線を描画
        ret.graphics.drawRect(-30, -30, 60, 60);

        return ret;
    }
}
}
