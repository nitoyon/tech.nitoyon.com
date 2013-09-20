package {
import Box2D.Dynamics.*;
import Box2D.Dynamics.Joints.*;
import Box2D.Collision.*;
import Box2D.Collision.Shapes.*;
import Box2D.Common.Math.*;
import flash.events.Event
import flash.display.*;
import flash.text.TextField;
import flash.external.ExternalInterface;
import flash.utils.*;
import flash.system.Security;
import flash.geom.Rectangle;

public class Meltdown extends Sprite {
	private var m_world:b2World;
	private var m_mouseJoint:b2MouseJoint;
	private var m_room:b2Body;
	private var m_physScale:Number = 20;
	private var m_acc:b2Vec2;
	private var list:ImageLoader;
	private var initialized:Boolean = false;

	private const m_restitution:Number = 0.8;
	private const m_friction:Number = 0.1;
	private const WALL:Number = 100;

	public function Meltdown() {
		stage.scaleMode = "noScale";
		stage.align = "TL";
		Security.allowDomain("*");

		// notify js
		ExternalInterface.addCallback("ready", function():Boolean { return true });

		// init
		initialized = false;
		ExternalInterface.addCallback("init", init);
	}

	private function init(size:Array, imgs:Array, scroll:Array):void
	{
		if(initialized) return;
		initialized = true;

		// init resize handler
		var prevPos:Array = scroll;
		m_acc = new b2Vec2();
		ExternalInterface.addCallback("scrollHandler", function(p:*):void
		{
			m_acc.Add(new b2Vec2((prevPos[0] - p[0]) / 10, (prevPos[1] - p[1]) / 10));
			prevPos = p;
		});

		// load all images
		list = new ImageLoader();
		for(var i:int = 0; i < imgs.length; i++)
		{
			list.add(Image(addChild(new Image(imgs[i]))));
		}
		list.load();

		// handler
		list.addEventListener("load", function(event:Event):void
		{
			// images loaded!!
			addEventListener("enterFrame", function(event:*):void{Update()});
			stage.addEventListener("mouseDown", mouseDown);

			hideHtmlImages();

			initBox2d(size);
		});
	}

	private function hideHtmlImages():void
	{
		var f:String = <><![CDATA[
			function(){
				var imgs = document.getElementsByTagName('img');
				for(var i = 0; i < imgs.length; i++){
					imgs[i].style.visibility = 'hidden';
				}
			}]]></>;
		ExternalInterface.call(f);
	}

	// create Box2d world
	private function initBox2d(size:Array):void {
		var w:Number = size[0], h:Number = size[1];

		// Construct a world object
		var worldAABB:b2AABB = new b2AABB();
		worldAABB.minVertex.Set(-100.0, -100.0);
		worldAABB.maxVertex.Set(100.0, 1000.0);
		m_world = new b2World(worldAABB, new b2Vec2(0.0, 50.0), true);

		function createBox(rect:Rectangle, fixed:Boolean):b2ShapeDef {
			var box:b2BoxDef = new b2BoxDef();
			box.density = fixed ? 0 : 1;
			box.friction = m_friction;
			box.restitution = m_restitution;

			box.extents.Set(rect.width  / 2 / m_physScale, 
			                rect.height / 2 / m_physScale);
			box.localPosition.Set((rect.x + (rect.width  / 2)) / m_physScale, 
			                      (rect.y + (rect.height / 2)) / m_physScale);
			return box;
		}

		// create room
		var room:b2BodyDef = new b2BodyDef();
		room.AddShape(createBox(new Rectangle(-WALL, h, w + WALL * 2, WALL), true));
		room.AddShape(createBox(new Rectangle(-WALL, -WALL, w + WALL * 2, WALL), true));
		room.AddShape(createBox(new Rectangle(-WALL, 0, WALL, h), true));
		room.AddShape(createBox(new Rectangle(w, 0, WALL, h), true));
		m_room = m_world.CreateBody(room);

		// Add bodies
		var sd:b2BoxDef = createBox(new Rectangle(), false);
		var bd:b2BodyDef = new b2BodyDef();
		bd.AddShape(sd);
		for (var i:int = 0; i < list.length; i++) {
			var img:Image = list.getAt(i);
			if(!img) continue;
			sd.extents.Set(img.width / 2 / m_physScale, img.height / 2 / m_physScale);
			bd.position.Set(img.x / m_physScale, img.y / m_physScale);
			img.body = m_world.CreateBody(bd);
			img.body.m_angularVelocity = Math.PI * (Math.random() - .5);
			img.body.m_linearVelocity = new b2Vec2((Math.random() - .5) * 10, (Math.random() - .5) * 10);
		}
	}

	// enterFrame Handler
	public function Update():void {
		if(!m_world) {
			return;
		}

		if(m_acc.x != m_world.m_gravity.x || m_acc.y != m_world.m_gravity.y + 50){
			m_world.m_gravity.Set(m_acc.x * 10, m_acc.y * 10 + 50);
			m_acc.Set(0, 0);
			wakeUpAll();
		}

		// Update physics
		m_world.Step(1 / 30, 10);

		// Render
//		graphics.clear();
		for (var i:int = 0; i < list.length; i++) {
			var img:Image = list.getAt(i);
			img.x = img.body.m_position.x * m_physScale;
			img.y = img.body.m_position.y * m_physScale;
			img.rotation = img.body.m_rotation * 180 / Math.PI;
		}
	}

	private function wakeUpAll():void{
		for (var i:int = 0; i < list.length; i++) {
			var img:Image = list.getAt(i);
			img.body.WakeUp();
		}
	}

	// drag handler
	private function mouseDown(event:Event):void
	{
		if (m_mouseJoint) return;
		if (!m_world) return;

		var body:b2Body = GetBodyAtMouse();
		if (body)
		{
			var mouseXWorldPhys:Number = mouseX / m_physScale;
			var mouseYWorldPhys:Number = mouseY / m_physScale;

			var md:b2MouseJointDef = new b2MouseJointDef();
			md.body1 = m_world.m_groundBody;
			md.body2 = body;
			md.target.Set(mouseXWorldPhys, mouseYWorldPhys);
			md.maxForce = 30000.0 * body.m_mass;
			md.timeStep = 1 / 30;
			m_mouseJoint =  m_world.CreateJoint(md) as b2MouseJoint;
			body.WakeUp();

			stage.addEventListener("mouseMove", mouseMove);
			stage.addEventListener("mouseUp", mouseUp);

			body.m_linearVelocity = new b2Vec2(0, -10);
		}
	}

	private function mouseUp(event:Event):void
	{
		// mouse release
		if (m_mouseJoint)
		{
			m_world.DestroyJoint(m_mouseJoint);
			m_mouseJoint = null;

			stage.removeEventListener("mouseMove", mouseMove);
			stage.removeEventListener("mouseUp", mouseUp);
		}
	}

	private function mouseMove(event:Event):void
	{
		// mouse move
		if (m_mouseJoint)
		{
			var mouseXWorldPhys:Number = mouseX / m_physScale;
			var mouseYWorldPhys:Number = mouseY / m_physScale;

			var p2:b2Vec2 = new b2Vec2(mouseXWorldPhys, mouseYWorldPhys);
			m_mouseJoint.SetTarget(p2);
		}
	}

	//======================
	private var mousePVec:b2Vec2 = new b2Vec2();
	public function GetBodyAtMouse(includeStatic:Boolean=false):b2Body{
		var mouseXWorldPhys:Number = mouseX / m_physScale;
		var mouseYWorldPhys:Number = mouseY / m_physScale;
		
		// Make a small box.
		mousePVec.Set(mouseXWorldPhys, mouseYWorldPhys);
		var aabb:b2AABB = new b2AABB();
		aabb.minVertex.Set(mouseXWorldPhys - 0.001, mouseYWorldPhys - 0.001);
		aabb.maxVertex.Set(mouseXWorldPhys + 0.001, mouseYWorldPhys + 0.001);
		
		// Query the world for overlapping shapes.
		var k_maxCount:int = 10;
		var shapes:Array = new Array();
		var count:int = m_world.Query(aabb, shapes, k_maxCount);
		var body:b2Body = null;
		for (var i:int = 0; i < count; ++i)
		{
			if (shapes[i].m_body.IsStatic() == false || includeStatic)
			{
				var inside:Boolean = shapes[i].TestPoint(mousePVec);
				if (inside)
				{
					body = shapes[i].m_body;
					break;
				}
			}
		}
		return body;
	}
}
}

import flash.display.*;
import flash.events.*;
import flash.net.URLRequest;
import Box2D.Dynamics.*;
import flash.utils.*;

internal class Image extends Sprite
{
	public var param:Object;
	private var loader:Loader;
	public var body:b2Body;

	public function Image(obj:Object)
	{
		param = obj;

		loader = new Loader();
		loader.contentLoaderInfo.addEventListener("complete", completeHandler);
		loader.contentLoaderInfo.addEventListener("ioError", ioErrorHandler);
	}

	public function load():void
	{
		var req:URLRequest = new URLRequest(param.url);
		loader.load(req);
	}

	private function completeHandler(event:Event):void
	{
		x = param.pos[0] + param.size[0] / 2;
		y = param.pos[1] + param.size[1] / 2;
		loader.x = -param.size[0] / 2;
		loader.y = -param.size[1] / 2;
		loader.width = param.size[0];
		loader.height = param.size[1];
		addChild(loader);

		dispatchEvent(event);
	}

	private function ioErrorHandler(event:Event):void
	{
		dispatchEvent(new Event("complete"));
	}
}

internal class ImageLoader extends EventDispatcher
{
	private var list:Array;
	private var loading:Boolean;

	public function get length():int
	{
		return list.length;
	}

	public function ImageLoader()
	{
		list = [];
		loading = false;
	}

	public function add(image:Image):void
	{
		list.push(image);
	}

	public function getAt(index:int):Image
	{
		return list[index] as Image;
	}

	public function load():Boolean
	{
		if(loading) return false;
		loading = true;

		var notLoaded:Array = list.concat();
		for each(var img:Image in list)
		{
			img.load();
			img.addEventListener("complete", function(event:Event):void
			{
				var img:Image = event.target as Image;
				var index:int = notLoaded.indexOf(img);
				if(index != -1)
				{
					notLoaded.splice(index, 1);
					if(notLoaded.length == 0 && loading)
					{
						loading = false;
						dispatchEvent(new Event("load"));
					}
				}
				img.removeEventListener("complete", arguments.callee);
			});
		}

		setTimeout(function():void
		{
			if(loading)
			{
				loading = false;
				dispatchEvent(new Event("load"));
			}
		}, 3000);
		return true;
	}
}