package {
    import Engine.Dynamics.*;
    import Engine.Collision.*;
    import Engine.Collision.Shapes.*;
    import Engine.Common.Math.*;
    import flash.events.Event
    import flash.display.*;
    import flash.text.TextField;

    [SWF(backgroundColor="#ffffff", width="350", height="200")]
    public class Box2dSimpleSample extends Sprite {
        private var m_world:b2World;
        private var m_physScale:Number = 10;
        private var count:int = 0;  // loop counter

        public function Box2dSimpleSample() {
            stage.scaleMode = "noScale";
            stage.align = "TL";

            var text:TextField = new TextField();
            text.text = "CLICK TO START!!!";
            text.x = (stage.stageWidth  - text.textWidth)  / 2;
            text.y = (stage.stageHeight - text.textHeight) / 2
            addChild(text);

            stage.addEventListener("click", function(event:Event):void {
                text.visible = false;
                init();
            });
            addEventListener("enterFrame", function(event:Event):void {
                Update();
            });
        }

        private function init():void {
            count = 0;

            // Construct a world object
            var worldAABB:b2AABB = new b2AABB();
            worldAABB.minVertex.Set(-100.0, -100.0);
            worldAABB.maxVertex.Set(100.0, 100.0);
            var gravity:b2Vec2 = new b2Vec2(0.0, 10.0);
            m_world = new b2World(worldAABB, gravity, true);

            // Create floor
            var wallSd:b2BoxDef = new b2BoxDef();
            wallSd.extents.Set(300 / m_physScale / 2, 10 / m_physScale);
            wallSd.localRotation = Math.random() * Math.PI / 8;
            var wallBd:b2BodyDef = new b2BodyDef();
            wallBd.position.Set(300 / m_physScale / 2, 250 / m_physScale);
            wallBd.AddShape(wallSd);
            m_world.CreateBody(wallBd);

            // Add bodies
            var sd:b2BoxDef = new b2BoxDef();
            sd.density = 1;
            sd.friction = 0.2;
            var bd:b2BodyDef = new b2BodyDef();
            bd.AddShape(sd);
            for (var i:int = 0; i < 10; i++) {
                sd.extents.Set(30 / m_physScale, 10 / m_physScale);
                bd.position.Set(100 / m_physScale, (160 - 40 - i * 20) / m_physScale);
                m_world.CreateBody(bd);
            }
        }

        public function Update():void {
            if(!m_world) {
                return;
            }

            // Update physics
            count++;
            if(count > 300) {
                init();
            }
            m_world.Step(1 / 30, 10);

            // Render
            graphics.clear();
            for (var bb:b2Body = m_world.m_bodyList; bb; bb = bb.m_next) {
                for (var s:b2Shape = bb.GetShapeList(); s != null; s = s.GetNext()) {
                    DrawShape(s);
                }
            }
        }

        public function DrawShape(shape:b2Shape):void {
            if(shape.m_type == b2Shape.e_polyShape) {
                var poly:b2PolyShape = shape as b2PolyShape;
                var tV:b2Vec2 = b2Math.AddVV(poly.m_position, b2Math.b2MulMV(poly.m_R, poly.m_vertices[i]));

                graphics.beginFill(0x999999, count > 290 ? (300 - count) / 10.0 : 1);
                graphics.lineStyle(1,0xffffff,1);
                graphics.moveTo(tV.x * m_physScale, tV.y * m_physScale);

                for (var i:int = 0; i < poly.m_vertexCount; ++i) {
                    var v:b2Vec2 = b2Math.AddVV(poly.m_position, b2Math.b2MulMV(poly.m_R, poly.m_vertices[i]));
                    graphics.lineTo(v.x * m_physScale, v.y * m_physScale);
                }
                graphics.lineTo(tV.x * m_physScale, tV.y * m_physScale);

                graphics.endFill();
            }
        }
    }
}
