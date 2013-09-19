package {
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.text.TextField;
	import flash.net.*;
	import flash.events.Event;

	[SWF(backgroundColor="#ffffff")]
	public class EmbedFontTest extends Sprite {
		[Embed(source='アニトＭ-教漢.TTF', fontName='anito', unicodeRange='U+000A,U+0020,U+0046,U+0062,U+0064,U+0065,U+006D,U+006E,U+006F,U+0074,U+3002,U+304C,U+3059,U+3067,U+306A,U+306B,U+306D,U+306E,U+307E,U+3084,U+308A,U+30A1,U+30A2,U+30D5,U+30EB,U+56DE,U+5728,U+5B9A,U+7531,U+81EA,U+8A2D,U+8EE2')]
		private var font:Class;

		public function EmbedFontTest(){
			stage.align = "TL";
			stage.scaleMode = "noScale";

			var textField:TextField = new TextField();
			textField.embedFonts = true;
			textField.width = 400;
			textField.height = 300;
			textField.x = 50;
			textField.wordWrap = true;
			textField.htmlText = "<font face='anito' size='30'>embedFont で回転やアルファの設定が自由自在になりますね。</font>";
			textField.rotation = 10;
			addChild(textField);
		}
	}
}
