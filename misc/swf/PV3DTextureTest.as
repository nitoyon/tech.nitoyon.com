package {
import flash.display.*;
import flash.events.Event;
import flash.utils.ByteArray;
import org.papervision3d.objects.primitives.*;
import org.papervision3d.view.*;
import org.papervision3d.materials.*;
import org.papervision3d.materials.utils.MaterialsList;
import mx.utils.Base64Decoder;

[SWF(backgroundColor="#000000", width="475", height="475")]
public class PV3DTextureTest extends BasicView {
	// 表示する立方体
	private var cube:Cube;

	// 画像を BASE64 エンコードしたもの
	private static var ImageBase64:String = "R0lGODlhEAAQAJkAAOdfEwAAAPDQsAAAACH5BAAAAAAALAAAAAAQABAAAAI2hI4XhgYPXxBxxkqhvTJ33i0fuATm4l1TsnEt8GIymZ5uCiviqFG6ictBEDGhCmeCnZKCZbIAADs=";

	public function PV3DTextureTest(){
		// 画像をロードして BitmapData に変換する
		// 変換後、loadComplete 関数が呼ばれる
		base64ToBitmapData(ImageBase64, loadComplete);
	}

	private function loadComplete(bmd:BitmapData):void{
		// 表示するテクスチャを右上に表示
		addChild(new Bitmap(bmd));

		// BitmapMaterial に BitmapData を渡す
		var m:BitmapMaterial = new BitmapMaterial(bmd, true);

		// tiled を true に、maxU, maxV に敷き詰める数を渡す
		m.tiled = true;
		m.maxU = 5;
		m.maxV = 5;

		// Cube の面に貼り付ける
		cube = new Cube(new MaterialsList({all:m}));
		scene.addChild(cube);

		// 描画を開始する
		startRendering();
	}

	protected override function onRenderTick(e:Event = null):void{
		cube.rotationX += 1;
		cube.rotationY += .8;
		super.onRenderTick(e);
	}

	private function base64ToBitmapData(base64:String, callback:Function):void{
		var decoder:Base64Decoder = new Base64Decoder();
		decoder.decode(base64);

		var bytes:ByteArray = decoder.toByteArray();
		bytes.position = 0;
		var loader:Loader = new Loader();
		loader.loadBytes(bytes);
		var bmd:BitmapData = new BitmapData(16, 16);
		loader.contentLoaderInfo.addEventListener("complete", function(event:Event):void{
			var bmd:BitmapData = new BitmapData(loader.width, loader.height);
			bmd.draw(loader);
			callback(bmd);
		});
	}
}
} 