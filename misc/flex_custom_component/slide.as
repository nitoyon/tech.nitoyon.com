package
{
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.setTimeout;
	import flash.utils.getDefinitionByName;

	[SWF(width="360", height="269", backgroundColor="#ffffff")]
	public class slide extends Sprite
	{
		[Embed(source="image001.jpg")]
		private var img001:Class;
		[Embed(source="image002.jpg")]
		private var img002:Class;
		[Embed(source="image003.jpg")]
		private var img003:Class;
		[Embed(source="image004.jpg")]
		private var img004:Class;
		[Embed(source="image005.jpg")]
		private var img005:Class;
		[Embed(source="image006.jpg")]
		private var img006:Class;
		[Embed(source="image007.jpg")]
		private var img007:Class;
		[Embed(source="image008.jpg")]
		private var img008:Class;
		[Embed(source="image009.jpg")]
		private var img009:Class;
		[Embed(source="image010.jpg")]
		private var img010:Class;
		[Embed(source="image011.jpg")]
		private var img011:Class;
		[Embed(source="image012.jpg")]
		private var img012:Class;
		[Embed(source="image013.jpg")]
		private var img013:Class;
		[Embed(source="image014.jpg")]
		private var img014:Class;
		[Embed(source="image015.jpg")]
		private var img015:Class;
		[Embed(source="image016.jpg")]
		private var img016:Class;
		[Embed(source="image017.jpg")]
		private var img017:Class;
		[Embed(source="image018.jpg")]
		private var img018:Class;
		[Embed(source="image019.jpg")]
		private var img019:Class;
		[Embed(source="image020.jpg")]
		private var img020:Class;
		[Embed(source="image021.jpg")]
		private var img021:Class;
		[Embed(source="image022.jpg")]
		private var img022:Class;
		[Embed(source="image023.jpg")]
		private var img023:Class;
		[Embed(source="image024.jpg")]
		private var img024:Class;
		[Embed(source="image025.jpg")]
		private var img025:Class;
		[Embed(source="image026.jpg")]
		private var img026:Class;
		[Embed(source="image027.jpg")]
		private var img027:Class;
		[Embed(source="image028.jpg")]
		private var img028:Class;
		[Embed(source="image029.jpg")]
		private var img029:Class;
		[Embed(source="image030.jpg")]
		private var img030:Class;
		[Embed(source="image031.jpg")]
		private var img031:Class;
		[Embed(source="image032.jpg")]
		private var img032:Class;
		[Embed(source="image033.jpg")]
		private var img033:Class;
		[Embed(source="image034.jpg")]
		private var img034:Class;
		[Embed(source="image035.jpg")]
		private var img035:Class;
		[Embed(source="image036.jpg")]
		private var img036:Class;
		[Embed(source="image037.jpg")]
		private var img037:Class;
		[Embed(source="image038.jpg")]
		private var img038:Class;
		[Embed(source="image039.jpg")]
		private var img039:Class;
		[Embed(source="image040.jpg")]
		private var img040:Class;
		[Embed(source="image041.jpg")]
		private var img041:Class;
		[Embed(source="image042.jpg")]
		private var img042:Class;
		[Embed(source="image043.jpg")]
		private var img043:Class;
		[Embed(source="image044.jpg")]
		private var img044:Class;
		[Embed(source="image045.jpg")]
		private var img045:Class;
		[Embed(source="image046.jpg")]
		private var img046:Class;
		[Embed(source="image047.jpg")]
		private var img047:Class;
		[Embed(source="image048.jpg")]
		private var img048:Class;
		[Embed(source="image049.jpg")]
		private var img049:Class;
		[Embed(source="image050.jpg")]
		private var img050:Class;
		[Embed(source="image051.jpg")]
		private var img051:Class;
		[Embed(source="image052.jpg")]
		private var img052:Class;
		[Embed(source="image053.jpg")]
		private var img053:Class;
		[Embed(source="image054.jpg")]
		private var img054:Class;
		[Embed(source="image055.jpg")]
		private var img055:Class;
		[Embed(source="image056.jpg")]
		private var img056:Class;
		[Embed(source="image057.jpg")]
		private var img057:Class;
		[Embed(source="image058.jpg")]
		private var img058:Class;
		[Embed(source="image059.jpg")]
		private var img059:Class;
		[Embed(source="image060.jpg")]
		private var img060:Class;
		[Embed(source="image061.jpg")]
		private var img061:Class;
		[Embed(source="image062.jpg")]
		private var img062:Class;
		[Embed(source="image063.jpg")]
		private var img063:Class;
		[Embed(source="image064.jpg")]
		private var img064:Class;
		[Embed(source="image065.jpg")]
		private var img065:Class;
		[Embed(source="image066.jpg")]
		private var img066:Class;
		[Embed(source="image067.jpg")]
		private var img067:Class;
		[Embed(source="image068.jpg")]
		private var img068:Class;
		[Embed(source="image069.jpg")]
		private var img069:Class;
		[Embed(source="image070.jpg")]
		private var img070:Class;
		[Embed(source="image071.jpg")]
		private var img071:Class;
		[Embed(source="image072.jpg")]
		private var img072:Class;
		[Embed(source="image073.jpg")]
		private var img073:Class;
		[Embed(source="image074.jpg")]
		private var img074:Class;
		[Embed(source="image075.jpg")]
		private var img075:Class;
		[Embed(source="image076.jpg")]
		private var img076:Class;
		[Embed(source="image077.jpg")]
		private var img077:Class;
		[Embed(source="image078.jpg")]
		private var img078:Class;
		[Embed(source="image079.jpg")]
		private var img079:Class;
		[Embed(source="image080.jpg")]
		private var img080:Class;
		[Embed(source="image081.jpg")]
		private var img081:Class;
		[Embed(source="image082.jpg")]
		private var img082:Class;
		[Embed(source="image083.jpg")]
		private var img083:Class;
		[Embed(source="image084.jpg")]
		private var img084:Class;
		[Embed(source="image085.jpg")]
		private var img085:Class;
		[Embed(source="image086.jpg")]
		private var img086:Class;
		[Embed(source="image087.jpg")]
		private var img087:Class;
		[Embed(source="image088.jpg")]
		private var img088:Class;
		[Embed(source="image089.jpg")]
		private var img089:Class;
		[Embed(source="image090.jpg")]
		private var img090:Class;
		[Embed(source="image091.jpg")]
		private var img091:Class;
		[Embed(source="image092.jpg")]
		private var img092:Class;
		[Embed(source="image093.jpg")]
		private var img093:Class;
		[Embed(source="image094.jpg")]
		private var img094:Class;
		[Embed(source="image095.jpg")]
		private var img095:Class;
		[Embed(source="image096.jpg")]
		private var img096:Class;
		[Embed(source="image097.jpg")]
		private var img097:Class;
		[Embed(source="image098.jpg")]
		private var img098:Class;
		[Embed(source="image099.jpg")]
		private var img099:Class;
		[Embed(source="image100.jpg")]
		private var img100:Class;
		[Embed(source="image101.jpg")]
		private var img101:Class;
		[Embed(source="image102.jpg")]
		private var img102:Class;
		[Embed(source="image103.jpg")]
		private var img103:Class;
		[Embed(source="image104.jpg")]
		private var img104:Class;
		[Embed(source="image105.jpg")]
		private var img105:Class;
		[Embed(source="image106.jpg")]
		private var img106:Class;
		[Embed(source="image107.jpg")]
		private var img107:Class;
		[Embed(source="image108.jpg")]
		private var img108:Class;
		[Embed(source="image109.jpg")]
		private var img109:Class;
		[Embed(source="image110.jpg")]
		private var img110:Class;
		[Embed(source="image111.jpg")]
		private var img111:Class;
		[Embed(source="image112.jpg")]
		private var img112:Class;
		[Embed(source="image113.jpg")]
		private var img113:Class;
		[Embed(source="image114.jpg")]
		private var img114:Class;
		[Embed(source="image115.jpg")]
		private var img115:Class;
		[Embed(source="image116.jpg")]
		private var img116:Class;
		[Embed(source="image117.jpg")]
		private var img117:Class;
		[Embed(source="image118.jpg")]
		private var img118:Class;

		private var page:Array = [
		img001,
		img002,
		img003,
		img004,
		img005,
		img006,
		img007,
		img008,
		img009,
		img010,
		img011,
		img012,
		img013,
		img014,
		img015,
		img016,
		img017,
		img018,
		img019,
		img020,
		img021,
		img022,
		img023,
		img024,
		img025,
		img026,
		img027,
		img028,
		img029,
		img030,
		img031,
		img032,
		img033,
		img034,
		img035,
		img036,
		img037,
		img038,
		img039,
		img040,
		img041,
		img042,
		img043,
		img044,
		img045,
		img046,
		img047,
		img048,
		img049,
		img050,
		img051,
		img052,
		img053,
		img054,
		img055,
		img056,
		img057,
		img058,
		img059,
		img060,
		img061,
		img062,
		img063,
		img064,
		img065,
		img066,
		img067,
		img068,
		img069,
		img070,
		img071,
		img072,
		img073,
		img074,
		img075,
		img076,
		img077,
		img078,
		img079,
		img080,
		img081,
		img082,
		img083,
		img084,
		img085,
		img086,
		img087,
		img088,
		img089,
		img090,
		img091,
		img092,
		img093,
		img094,
		img095,
		img096,
		img097,
		img098,
		img099,
		img100,
		img101,
		img102,
		img103,
		img104,
		img105,
		img106,
		img107,
		img108,
		img109,
		img110,
		img111,
		img112,
		img113,
		img114,
		img115,
		img116,
		img117,
		img118];

		[Embed(source="left.png")]
		private var Left:Class;
		[Embed(source="right.png")]
		private var Right:Class;

		private var index:int = 0;
		private var typingNumber:int;

		private var left:Bitmap  = Bitmap(new Left());
		private var right:Bitmap = Bitmap(new Right());
		private var curPage:Bitmap;

		public function slide()
		{
			stage.align = "TL";
			stage.scaleMode = "noScale";

			Mouse.hide();
			addChild(left); left.visible = false;
			addChild(right);right.visible = false;

			stage.addEventListener("keyDown", keyDownHandler);
			stage.addEventListener("mouseMove", mouseMoveHandler);
			stage.addEventListener("mouseOut", mouseMoveHandler);
			stage.addEventListener("click", clickHandler);
			setTimeout(function():void{show()}, 0);
		}

		private function mouseMoveHandler(event:MouseEvent):void
		{
			if(event.stageX < 360 && event.stageY < 269)
			{
				Mouse.hide();

				var s:Bitmap = (event.localX < 180 ? left : right);
				var h:Bitmap = (event.localX < 180 ? right : left);

				s.visible = true;
				s.x = event.stageX - 16;
				s.y = event.stageY - 16;
				h.visible = false;
			}
			else
			{
				Mouse.show();
				left.visible = right.visible = false;
			}
		}

		private function clickHandler(event:MouseEvent):void
		{
			if(event.stageX < 360 && event.stageY < 269)
			{
				if(event.stageX < 180)
				{
					prev();
				}
				else
				{
					next();
				}
			}
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
				case Keyboard.SPACE:
					(event.shiftKey ? prev() : next());
					break;
				case Keyboard.HOME:
					index = 0;
					show();
					break;
				case Keyboard.END:
					index = page.length - 1;
					show();
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

			clear();

			curPage = new page[index];
			addChildAt(curPage, 0);
		}

		private function clear():void
		{
			if(curPage)
			{
				removeChild(curPage);
				curPage = null;
			}
		}
	}
}