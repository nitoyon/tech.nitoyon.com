package
{
	import flash.filesystem.*;
	import flash.utils.*;
	import flash.display.*;
	import flash.text.*;
	import flash.filters.*;
	import flash.events.*;

	public class niconico extends Sprite
	{
		private var filename:String;
		private var prevId:String;
		private var prevSize:int;
		private var texts:Array;

		public function niconico():void
		{
			stage.displayState = "fullScreen";
			stage.window.alwaysInFront = true;
			prevId = "";
			prevSize = 0;
			texts = [];
			addEventListener("enterFrame", polling, false);
		}

		private function polling(e:Event):void
		{
			checkNew();
			moveTexts();
		}

		private function parseLine(line:String):Object
		{
			if(line == "")
			{
				return null;
			}

			var id:String = line.substr(0, line.indexOf(","));
			var val:String = line.substr(line.indexOf(",") + 1);

			if(val == "")
			{
				return null;
			}

			return {id : (id != "" ? id : val), value : val};
		}

		private function checkNew():void
		{
			var file:File = File.documentsDirectory.resolve("niconico.txt");
			try
			{
				if(file.size == prevSize)
				{
					return;
				}
				prevSize = file.size;

				var stream:FileStream = new FileStream()
				stream.open(file, FileMode.READ);
				var str:String = stream.readMultiByte(file.size, File.systemCharset);
				stream.close();
			}
			catch(e:Error)
			{
				return;
			}

			str = str.replace(/\r/g, "\n").replace(/\n\n+/g, "\n");
			var lines:Array = str.split(/\n/g);
			var startIndex:int = 0;
			for(var i:int = lines.length - 1; i >= 0; i--)
			{
				if(parseLine(lines[i]) && parseLine(lines[i]).id == prevId)
				{
					startIndex = i + 1;
					break;
				}
			}

			var n:Boolean = false;
			for(i = startIndex; i < lines.length; i++)
			{
				var line:Object = parseLine(lines[i]);
				if(!line) continue;

				prevId = line.id;
				createText(line.value);
			}
		}

		private function createText(text:String):void
		{
			var fontSize:int = 40;
			var maxLength:int = int(2880 / stage.stageWidth * loaderInfo.width / fontSize);

			var createTextFieldObject:Function = function(text:String):TextField
			{
				var tf:TextField = new TextField();
				var format:TextFormat = new TextFormat();
				format.color = 0xffffff;
				format.size = fontSize;
				tf.defaultTextFormat = format;
				tf.text = text;
				tf.autoSize = TextFieldAutoSize.LEFT;

				var shadow:DropShadowFilter = new DropShadowFilter();
				shadow.angle = 0;
				shadow.distance = 0;
				tf.filters = [shadow];
				return tf;
			}

			var i:int = 0;
			var x:int = 0;
			var textSprite:Sprite = new Sprite();
			while(i < text.length)
			{
				var tf:TextField = createTextFieldObject(text.substr(i, maxLength));
				tf.x = x;
				textSprite.addChild(tf);

				i += maxLength;
				x += tf.width;
			}

			textSprite.x = loaderInfo.width;
			textSprite.y = checkY();
			addChild(textSprite);
			texts.push(textSprite);
		}

		private function checkY():int
		{
			var check:Object = {};
			for each(var t:DisplayObject in texts)
			{
				if(t.x + t.width > loaderInfo.width)
				{
					check[int(t.y / 50)] = true;
				}
			}

			var index:int = 0;
			for(var i:int = 0; i < 15; i++)
			{
				if(!check[i])
				{
					return i * 50;
				}
			}
			return int(Math.random() * 15) * 40;
		}

		private function moveTexts():void
		{
			for(var i:int = texts.length - 1; i >= 0; i--)
			{
				var t:DisplayObject  = texts[i] as DisplayObject;
				if(t != null)
				{
					t.x -= (t.width / 160) + 5;
				}

				if(!t || t.x + t.width < 0)
				{
					removeChild(t);
					texts.splice(i, 1);
				}
			}
		}
	}
}
