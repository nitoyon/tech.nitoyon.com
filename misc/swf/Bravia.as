package {
	import Engine.Dynamics.*;
	import Engine.Collision.*;
	import Engine.Collision.Shapes.*;
	import Engine.Common.Math.*;
	import flash.events.Event
	import flash.display.*;
	import flash.text.TextField;

	[SWF(backgroundColor="#ffffff", width="350", height="200")]
	public class Bravia extends Sprite {
		private var m_world:b2World;
		private var m_physScale:Number = 10;
		private var count:int = 0;  // loop counter

		public function Bravia() {
			stage.scaleMode = "noScale";
			stage.align = "TL";

			init();
			Update();
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
			var floor:b2PolyDef = new b2PolyDef();
			floor.vertices[0] = new b2Vec2(0   / m_physScale, 200 / m_physScale);
			floor.vertices[1] = new b2Vec2(100 / m_physScale, 180 / m_physScale);
			floor.vertices[2] = new b2Vec2(400 / m_physScale, 230 / m_physScale);
			floor.vertices[3] = new b2Vec2(400 / m_physScale, 400 / m_physScale);
			floor.vertices[4] = new b2Vec2(0   / m_physScale, 400 / m_physScale);
			floor.vertexCount = 5;
			var floorBody:b2BodyDef = new b2BodyDef();
			floorBody.AddShape(floor);
			m_world.CreateBody(floorBody);
		}

		public function Update():void {
			if(!m_world) {
				return;
			}

			// Update physics
			m_world.Step(1 / 30, 10);


			// Render
			graphics.clear();
			var c:int = 0;
			var destroyList:Array = [];
			for (var bb:b2Body = m_world.m_bodyList; bb; bb = bb.m_next) {
				if(bb.GetCenterPosition().y > 300 / m_physScale)
				{
					destroyList.push(bb);
				}
				else
				{
					for (var s:b2Shape = bb.GetShapeList(); s != null; s = s.GetNext()) {
						c++;
						DrawShape(s);
					}
				}
			}
			for each(bb in destroyList)
			{
				m_world.DestroyBody(bb);
			}

			count++;
			if(count > 10){
				count = 0;
				var ball:b2CircleDef = new b2CircleDef();
				ball.radius = 10 / m_physScale;
				ball.density = 1.0;
				ball.friction = 0.5;
				ball.restitution = 0.5;
				var ballBody:b2BodyDef = new b2BodyDef();
				ballBody.AddShape(ball);
				ballBody.position.Set(Math.random() * 400 / m_physScale, 0);
				m_world.CreateBody(ballBody);
			}
		}

		public function DrawShape(shape:b2Shape):void{
			switch (shape.m_type)
			{
			case b2Shape.e_circleShape:
				{
					var circle:b2CircleShape = shape as b2CircleShape;
					var pos:b2Vec2 = circle.m_position;
					var r:Number = circle.m_radius;
					var k_segments:Number = 16.0;
					var k_increment:Number = 2.0 * Math.PI / k_segments;
					graphics.beginFill(0x999999);
					graphics.lineStyle(1,0xffffff,1);
					graphics.moveTo((pos.x + r) * m_physScale, (pos.y) * m_physScale);
					var theta:Number = 0.0;
					
					for (var i:int = 0; i < k_segments; ++i)
					{
						var d:b2Vec2 = new b2Vec2(r * Math.cos(theta), r * Math.sin(theta));
						var v:b2Vec2 = b2Math.AddVV(pos , d);
						graphics.lineTo((v.x) * m_physScale, (v.y) * m_physScale);
						theta += k_increment;
					}
					graphics.lineTo((pos.x + r) * m_physScale, (pos.y) * m_physScale);
					
					graphics.moveTo((pos.x) * m_physScale, (pos.y) * m_physScale);
					var ax:b2Vec2 = circle.m_R.col1;
					var pos2:b2Vec2 = new b2Vec2(pos.x + r * ax.x, pos.y + r * ax.y);
					graphics.lineTo((pos2.x) * m_physScale, (pos2.y) * m_physScale);
				}
				break;
			case b2Shape.e_polyShape:
				{
					var poly:b2PolyShape = shape as b2PolyShape;
					var tV:b2Vec2 = b2Math.AddVV(poly.m_position, b2Math.b2MulMV(poly.m_R, poly.m_vertices[i]));
					graphics.beginFill(0x999999);
					graphics.lineStyle(1,0xffffff,1);
					graphics.moveTo(tV.x * m_physScale, tV.y * m_physScale);
					
					for (i = 0; i < poly.m_vertexCount; ++i)
					{
						v = b2Math.AddVV(poly.m_position, b2Math.b2MulMV(poly.m_R, poly.m_vertices[i]));
						graphics.lineTo(v.x * m_physScale, v.y * m_physScale);
					}
					graphics.lineTo(tV.x * m_physScale, tV.y * m_physScale);
				}
				break;
			}
		}
	}
}
