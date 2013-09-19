package
{
	import com.nitoyon.potras.*;
	import flash.display.*;
	import flash.text.*;
	import flash.net.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;


	[SWF(width="480", height="360", backgroundColor="#ffffff")]
	public class Slide extends Sprite
	{
		[Embed(source="assets/techni.jpg")]
		private var TechniImage:Class;

		[Embed(source="assets/marubiru1.jpg")]
		private var Marubiru1:Class;

		[Embed(source="assets/marubiru2.jpg")]
		private var Marubiru2:Class;

		private var page:Array = 
		[
			{size : 50, scale : 1.5, color : 0x006600, lineColor: 0x66cc66, text : "今日\n７時間で\n作ったもの"},
			{size : 30, scale : 3.5, color : 0xff0000, text : "自己紹介\nIntro"},
			{size : 40, scale : 1.0, color : 0x000066, text : "にとよんです。\nMy name is nitoyon."},
			{size : 40, scale : 1.4, color : 0x000066, text : "「てっく煮」\nやってます。\ntech.nitoyon.com"},
			{image : TechniImage},
			{size : 30, scale : 2.0, color : 0x660066, text : "今日のネタ\nToday's topic"},
			{size : 50, scale : 1.0, color : 0x006600, lineColor: 0x66cc66, text : "今日\n７時間で\n作ったもの"},
			{size : 30, scale : 4.0, color : 0x000080, lineColor : 0x6666ff, text : "丸ビル\nRSS\nリーダー"},
			{size : 30, scale : 2.5, color : 0xff0000, text : "10:00～11:00\n(1/7)"},
			{size : 30, scale : 2.5, color : 0x000000, text : "写真探し"},
			{image : Marubiru1},
			{size : 30, scale : 1.5, color : 0x000000, text : "見つかった\n(@wikipedia)"},
			{size : 30, scale : 2.5, color : 0xff0000, text : "11:00～13:00\n(3/7)"},
			{size : 30, scale : 2.5, color : 0x000000, text : "写真加工"},
			{image : Marubiru2},
			{size : 30, scale : 2.5, color : 0xff0000, text : "13:00～14:00\n(4/7)"},
			{size : 30, scale : 2.5, color : 0x000000, text : "位置あわせ"},
			{size : 30, scale : 2.5, color : 0xff0000, text : "14:00～15:00\n(5/7)"},
			{size : 30, scale : 2.5, color : 0x000000, text : "ライトっぽく"},
			{size : 30, scale : 2.5, color : 0xff0000, text : "15:00～16:00\n(6/7)"},
			{size : 30, scale : 2.5, color : 0x000000, text : "文字を表示\n＋\nアニメーション"},
			{size : 30, scale : 2.5, color : 0xff0000, text : "16:00～17:00\n(7/7)"},
			{size : 30, scale : 2.5, color : 0x000000, text : "RSS読み込み"},
			{size : 30, scale : 4.4, color : 0xffffff, lineColor : 0x003399, text : "Thank\nyou!"}
		];

		private var index:int = 0;
		private var so:SharedObject;
		private var typingNumber:int;

		public function Slide()
		{
			stage.align = "TL";
			stage.scaleMode = "showAll";

			so = SharedObject.getLocal("marubiru_slide");
			index = so.data.index;

			stage.addEventListener("keyDown", keyDownHandler);
			setTimeout(function():void{show()}, 0);
		}

		private function keyDownHandler(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.RIGHT:
					next();
					break;
				case Keyboard.LEFT:
					prev();
					break;
				case Keyboard.ENTER:
					if(typingNumber != -1)
					{
						index = typingNumber;
						show();
					}
					break;
			}

			if(48 <= event.keyCode && event.keyCode < 58)
			{
				if(typingNumber == -1) typingNumber = 0;
				typingNumber = typingNumber * 10 + event.keyCode - 48;
			}
			else
			{
				typingNumber = -1;
			}
		}

		private function prev():void
		{
			if(index >= 0) index--;
			show();
		}

		private function next():void
		{
			if(index < page.length - 1) index++;
			show(index);
		}

		private function show(index:int = -1):void
		{
			if(index == -1)
			{
				index = this.index;
			}
			index = Math.max(0, index);
			index = Math.min(index, page.length - 1);

			so.data.index = index;
			so.flush();

			clear();

			if(page[index].title)
			{
				createTitle();
			}
			else if(page[index].image)
			{
				createImage(index);
			}
			else
			{
				createText(index);
			}
		}

		private function createText(index:int):void
		{
			var w:int = loaderInfo.width;
			var h:int = loaderInfo.height;
			var text:String = page[index].text;
			var size:int = page[index].size;
			var scale:Number = page[index].scale;
			var color:int = page[index].color || 0;
			var lineColor:int = page[index].lineColor != null ? page[index].lineColor : color;
			var lines:Array = text.split(/\n/);

			for(var i:int = 0; i < lines.length; i++)
			{
				var line:String = lines[i];
				var lineSprite:Sprite = new Sprite();
				var x:int = 0;
				var y:int = (h - lines.length * size * scale) / 2;

				var list:ClosedPathList = PotrAs.traceLetter(line, size);
				var sprite:Sprite = new Sprite();
				sprite.graphics.beginFill(color);
				sprite.graphics.lineStyle(1, lineColor);
				list.draw(sprite.graphics);
				sprite.graphics.endFill();
				sprite.scaleX = sprite.scaleY = scale;
				sprite.y = y;
				center(sprite);
				addChild(sprite).y = y + size * i * scale;
			}
		}

		private function createImage(index:int):void
		{
			var w:int = loaderInfo.width;
			var h:int = loaderInfo.height;

			if(page[index].image is Class)
			{
				var img:DisplayObject = new page[index].image;
				center(img, true);
				addChild(img);
			}
			else if(page[index].image is String)
			{
				var url:String = page[index].image;
				var loader:Loader = new Loader();
				var req:URLRequest = new URLRequest(url);
				loader.load(req);
				loader.contentLoaderInfo.addEventListener("complete", function(event:*):void
				{
					center(loader, true);
				});
				addChild(loader);
			}
		}

		private function center(s:DisplayObject, vertical:Boolean = false):void
		{
			var w:int = loaderInfo.width;
			var x:Number = (w - s.width) / 2;
			s.x = x;

			if(vertical)
			{
				var h:int = loaderInfo.height;
				var y:Number = (h - s.height) / 2;
				s.y = y;
			}
		}

		private function clear():void
		{
			while(numChildren)
			{
				removeChildAt(0);
			}
		}

		private function createTitle():void
		{
			var list:ClosedPathList;
			var sprite:Sprite;

			var box:Sprite = new Sprite();

			list = PotrAs.traceLetter("超", 30);
			sprite = new Sprite();
			sprite.graphics.beginFill(0xcc99cc);
			sprite.graphics.lineStyle(1, 0x000000);
			list.draw(sprite.graphics);
			sprite.graphics.endFill();
			box.addChild(sprite);

			list = PotrAs.traceLetter("絶", 30);
			sprite = new Sprite();
			sprite.graphics.beginFill(0xff0000);
			sprite.graphics.lineStyle(1, 0x000000);
			list.draw(sprite.graphics);
			sprite.graphics.endFill();
			sprite.x = 35;
			sprite.y = -2;
			sprite.rotation = 10;
			box.addChild(sprite);

			list = PotrAs.traceLetter("Ａ", 30);
			sprite = new Sprite();
			sprite.graphics.beginFill(0x006699);
			sprite.graphics.lineStyle(1, 0x000000);
			list.draw(sprite.graphics);
			sprite.graphics.endFill();
			sprite.x = 5;
			sprite.y = 30;
			box.addChild(sprite);

			list = PotrAs.traceLetter("Ｓ", 30);
			sprite = new Sprite();
			sprite.graphics.beginFill(0x006699);
			sprite.graphics.lineStyle(1, 0x000000);
			list.draw(sprite.graphics);
			sprite.graphics.endFill();
			sprite.x = 35;
			sprite.y = 30;
			box.addChild(sprite);

			addChild(box);
			box.scaleX = box.scaleY = 6;
			center(box);
		}
	}
}