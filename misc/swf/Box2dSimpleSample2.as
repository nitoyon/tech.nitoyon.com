package {
    import Engine.Dynamics.*;
    import Engine.Collision.*;
    import Engine.Collision.Shapes.*;
    import Engine.Common.Math.*;
    import flash.events.Event
    import flash.display.*;
    import flash.text.TextField;

    [SWF(backgroundColor="#ffffff", width="350", height="200")]
    public class Box2dSimpleSample2 extends Sprite {
        private var count:int = 0;  // loop counter
        private var first:Boolean = true; // init flag

        // Box2d
        private var m_world:b2World;
        private var m_physScale:Number = 10;
        private var m_floor:b2Body;
        private var m_blocks:Array;

        // Sprites
        private var spriteFloor:Sprite;
        private var spriteBlocks:Array;
        [Embed(source="daruma.png")]
        private var daruma:Class;
        private const colors:Array = [0x333366, 0xffffdd, 0xcc0000, 0xffcc00, 0x006600];

        // display param
        private static const LOOP:int = 280;
        private static const FADE_OUT:int = 20;

        public function Box2dSimpleSample2() {
            stage.scaleMode = "noScale";
            stage.align = "TL";

            var text:TextField = new TextField();
            text.text = "CLICK TO START!!!";
            text.x = text.y = 100;
            addChild(text);

            stage.addEventListener("click", function(event:Event):void {
                text.visible = false;
                init();
            });
        }

        private function init():void {
            count = 0;

            // init sprites
            if(first){
                first = false;

                // init floor sprite
                spriteFloor = new Sprite();
                spriteFloor.graphics.beginFill(0x808080);
                spriteFloor.graphics.drawRect(-300 / 2, -20 / 2, 300, 20);
                spriteFloor.graphics.endFill();
                addChild(spriteFloor);

                // init blocks sprite
                spriteBlocks = [];
                for(i = 0; i < colors.length; i++) {
                    var s:Sprite = new Sprite();
                    s.graphics.beginFill(colors[i]);
                    s.graphics.lineStyle(0, 0x999999);
                    s.graphics.drawRoundRect(-28, -10, 56, 20, 10, 10);
                    s.graphics.endFill();
                    addChild(s);
                    spriteBlocks.push(s);
                }
                s = new Sprite();
                var bmp:DisplayObject = s.addChild(new daruma());
                bmp.x = -bmp.width / 2;
                bmp.y = -bmp.height / 2;
                addChild(s);
                spriteBlocks.push(s);

                addEventListener("enterFrame", function(event:Event):void {
                    Update();
                });
            }

            // Construct a world object
            var worldAABB:b2AABB = new b2AABB();
            worldAABB.minVertex.Set(-100.0, -100.0);
            worldAABB.maxVertex.Set(100.0, 100.0);
            var gravity:b2Vec2 = new b2Vec2(0.0, 10.0);
            m_world = new b2World(worldAABB, gravity, true);

            // Create floor
            var wallSd:b2BoxDef = new b2BoxDef();
            wallSd.extents.Set(300 / 2 / m_physScale, 20 / 2 / m_physScale);
            var wallBd:b2BodyDef = new b2BodyDef();
            wallBd.position.Set(300 / m_physScale / 2, 250 / m_physScale);
            wallBd.rotation = Math.random() * Math.PI / 8;
            wallBd.AddShape(wallSd);
            m_floor = m_world.CreateBody(wallBd);

            // Add bodies
            var sd:b2BoxDef = new b2BoxDef();
            sd.density = 1;
            sd.friction = 0.2;
            var bd:b2BodyDef = new b2BodyDef();
            bd.AddShape(sd);
            m_blocks = [];
            for (var i:int = 0; i < spriteBlocks.length; i++) {
                sd.extents.Set(30 / m_physScale, (i == 5 ? 30 : 10) / m_physScale);
                bd.position.Set(100 / m_physScale, (120 - i * 20 - (i == 5 ? 18 : 0)) / m_physScale);
                m_blocks.push(m_world.CreateBody(bd));
            }
        }

        public function Update():void {
            count++;
            if(count > 300) {
                init();
            }

            // Update physics
            m_world.Step(1 / 30, 10);

            // Render
            var alpha:Number = (count > LOOP - FADE_OUT ? (LOOP - count) / FADE_OUT : 
                                count < FADE_OUT        ? count / FADE_OUT : 1);
            applyBodyToSprite(spriteFloor, m_floor, alpha);
            for(var i:int = 0; i < m_blocks.length; i++) {
                applyBodyToSprite(spriteBlocks[i], m_blocks[i], alpha);
            }
        }

        private function applyBodyToSprite(sprite:Sprite, body:b2Body, alpha:Number):void{
            sprite.x = body.m_position.x * m_physScale;
            sprite.y = body.m_position.y * m_physScale;
            sprite.rotation = body.m_rotation * 180 / Math.PI;
            sprite.alpha = alpha;
        }
    }
}
