package {
	import flash.events.*;
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.system.*;
	import flash.ui.Keyboard;
	import flash.utils.setInterval;
	import com.google.maps.*;
	import com.google.maps.controls.*;
	import caurina.transitions.Tweener;

	public class GoogleRacing extends Sprite {
		private const SIZE:int = 300;
		private const MAP_SIZE:int = SIZE * Math.sqrt(2);
		private const MAX_VELOCITY:Number = 0.000020;

		private var map:Map;
		private var mapContainer:Sprite;
		private var speed:TextField;

		[Embed(source="car.gif")]
		private var Car:Class;

		private var angle:Number = -140;
		private var velocity:Number = 0;
		private var accelerating:Boolean = false;
		private var handle:int = 0;

		public function GoogleRacing() {
			super();

			stage.scaleMode = "noScale";
			stage.align = "TL";

			map = new Map();
			map.key = "ABQIAAAA6de2NwhEAYfH7t7oAYcX3xRWPxFShKMZYAUclLzloAj2mNQgoRQZnk8BRyG0g_m2di3bWaT-Ji54Lg";
			map.setSize(new Point(MAP_SIZE, MAP_SIZE));
			map.addEventListener(MapEvent.MAP_READY, function(event:Event):void{
				map.setCenter(new LatLng(34.84339127807875, 136.54028131980896), 17, MapType.NORMAL_MAP_TYPE);
				map.disableDragging();
				addEventListener("enterFrame", function(event:Event):void{update()});
			});
			map.x = map.y = -MAP_SIZE / 2;
			mapContainer = new Sprite();
			mapContainer.x = mapContainer.y = SIZE / 2;
			mapContainer.addChild(map);
			addChild(mapContainer);

			var mask:Sprite = new Sprite();
			mask.graphics.beginFill(0);
			mask.graphics.drawRect(0, 0, SIZE, SIZE);
			mask.graphics.endFill();
			addChild(mask);
			mapContainer.mask = mask;

			speed = new TextField();
			speed.x = speed.y = 5;
			speed.background = speed.border = true;
			speed.backgroundColor = 0xffffff;
			speed.borderColor = 0x000000;
			speed.height = 16;
			speed.width = 50;
			addChild(speed);

			var car:Bitmap = new Car();
			car.x = car.y = (SIZE  - car.width) / 2
			addChild(car);;

			mapContainer.addEventListener("keyDown", function(event:KeyboardEvent):void{keyHandler(event, true)});
			mapContainer.addEventListener("keyUp", function(event:KeyboardEvent):void{keyHandler(event, false)});
		}

		private function keyHandler(e:KeyboardEvent, f:Boolean):void{
			switch(e.keyCode){
				case Keyboard.SPACE:
					accelerating = f;
					break;
				case Keyboard.LEFT:
				case Keyboard.RIGHT:
					handle = (!f ? 0 : e.keyCode == Keyboard.LEFT ? 1 : -1);
					break;
			}
			e.stopPropagation();
		}

		private function update():void{
			stage.focus = mapContainer;
			if(Capabilities.hasIME){
				IME.enabled = false;
			}

			var prevVelocity:Number = velocity;
			velocity += (accelerating ? 1 : -2) * 0.0000001;
			velocity = Math.max(0, Math.min(MAX_VELOCITY, velocity));
			if(prevVelocity == MAX_VELOCITY && prevVelocity == velocity){
				velocity = MAX_VELOCITY - 0.0000001;
			}

			if(velocity != 0){
				angle += handle * (accelerating + 1) * velocity / MAX_VELOCITY;
				var pos:LatLng = map.getCenter();
				map.setCenter(new LatLng(
					pos.lat() + velocity * Math.sin((angle + 90) * Math.PI / 180),
					pos.lng() + velocity * Math.cos((angle + 90) * Math.PI / 180)));
			}
			mapContainer.rotation = angle;
			speed.htmlText = "<p align='right'>" + Math.floor(velocity * 8200000) + "km/h</p>";
		}
	}
}