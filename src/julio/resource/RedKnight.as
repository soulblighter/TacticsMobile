package julio.resource 
{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.globalization.NumberFormatter;
	/**
	 * ...
	 * @author Soulblighter
	 */
	public class RedKnight implements ICharAsset 
	{
		
		
		[Embed(source = '../../../assets/red_knight/paused_e0000.png')]	private var paused_e0000:Class;
		[Embed(source = '../../../assets/red_knight/paused_e0001.png')]	private var paused_e0001:Class;
		[Embed(source = '../../../assets/red_knight/paused_e0002.png')]	private var paused_e0002:Class;
		[Embed(source = '../../../assets/red_knight/paused_e0003.png')]	private var paused_e0003:Class;
		[Embed(source = '../../../assets/red_knight/paused_e0004.png')]	private var paused_e0004:Class;
		[Embed(source = '../../../assets/red_knight/paused_e0005.png')]	private var paused_e0005:Class;
		[Embed(source = '../../../assets/red_knight/paused_e0006.png')]	private var paused_e0006:Class;
		[Embed(source = '../../../assets/red_knight/paused_e0007.png')]	private var paused_e0007:Class;
		[Embed(source = '../../../assets/red_knight/paused_e0008.png')]	private var paused_e0008:Class;
		
		[Embed(source = '../../../assets/red_knight/paused_n0000.png')]	private var paused_n0000:Class;
		[Embed(source = '../../../assets/red_knight/paused_n0001.png')]	private var paused_n0001:Class;
		[Embed(source = '../../../assets/red_knight/paused_n0002.png')]	private var paused_n0002:Class;
		[Embed(source = '../../../assets/red_knight/paused_n0003.png')]	private var paused_n0003:Class;
		[Embed(source = '../../../assets/red_knight/paused_n0004.png')]	private var paused_n0004:Class;
		[Embed(source = '../../../assets/red_knight/paused_n0005.png')]	private var paused_n0005:Class;
		[Embed(source = '../../../assets/red_knight/paused_n0006.png')]	private var paused_n0006:Class;
		[Embed(source = '../../../assets/red_knight/paused_n0007.png')]	private var paused_n0007:Class;
		[Embed(source = '../../../assets/red_knight/paused_n0008.png')]	private var paused_n0008:Class;
		
		[Embed(source = '../../../assets/red_knight/paused_ne0000.png')]	private var paused_ne0000:Class;
		[Embed(source = '../../../assets/red_knight/paused_ne0001.png')]	private var paused_ne0001:Class;
		[Embed(source = '../../../assets/red_knight/paused_ne0002.png')]	private var paused_ne0002:Class;
		[Embed(source = '../../../assets/red_knight/paused_ne0003.png')]	private var paused_ne0003:Class;
		[Embed(source = '../../../assets/red_knight/paused_ne0004.png')]	private var paused_ne0004:Class;
		[Embed(source = '../../../assets/red_knight/paused_ne0005.png')]	private var paused_ne0005:Class;
		[Embed(source = '../../../assets/red_knight/paused_ne0006.png')]	private var paused_ne0006:Class;
		[Embed(source = '../../../assets/red_knight/paused_ne0007.png')]	private var paused_ne0007:Class;
		[Embed(source = '../../../assets/red_knight/paused_ne0008.png')]	private var paused_ne0008:Class;
		
		[Embed(source = '../../../assets/red_knight/paused_nw0000.png')]	private var paused_nw0000:Class;
		[Embed(source = '../../../assets/red_knight/paused_nw0001.png')]	private var paused_nw0001:Class;
		[Embed(source = '../../../assets/red_knight/paused_nw0002.png')]	private var paused_nw0002:Class;
		[Embed(source = '../../../assets/red_knight/paused_nw0003.png')]	private var paused_nw0003:Class;
		[Embed(source = '../../../assets/red_knight/paused_nw0004.png')]	private var paused_nw0004:Class;
		[Embed(source = '../../../assets/red_knight/paused_nw0005.png')]	private var paused_nw0005:Class;
		[Embed(source = '../../../assets/red_knight/paused_nw0006.png')]	private var paused_nw0006:Class;
		[Embed(source = '../../../assets/red_knight/paused_nw0007.png')]	private var paused_nw0007:Class;
		[Embed(source = '../../../assets/red_knight/paused_nw0008.png')]	private var paused_nw0008:Class;
		
		[Embed(source = '../../../assets/red_knight/paused_s0000.png')]	private var paused_s0000:Class;
		[Embed(source = '../../../assets/red_knight/paused_s0001.png')]	private var paused_s0001:Class;
		[Embed(source = '../../../assets/red_knight/paused_s0002.png')]	private var paused_s0002:Class;
		[Embed(source = '../../../assets/red_knight/paused_s0003.png')]	private var paused_s0003:Class;
		[Embed(source = '../../../assets/red_knight/paused_s0004.png')]	private var paused_s0004:Class;
		[Embed(source = '../../../assets/red_knight/paused_s0005.png')]	private var paused_s0005:Class;
		[Embed(source = '../../../assets/red_knight/paused_s0006.png')]	private var paused_s0006:Class;
		[Embed(source = '../../../assets/red_knight/paused_s0007.png')]	private var paused_s0007:Class;
		[Embed(source = '../../../assets/red_knight/paused_s0008.png')]	private var paused_s0008:Class;
		
		[Embed(source = '../../../assets/red_knight/paused_se0000.png')]	private var paused_se0000:Class;
		[Embed(source = '../../../assets/red_knight/paused_se0001.png')]	private var paused_se0001:Class;
		[Embed(source = '../../../assets/red_knight/paused_se0002.png')]	private var paused_se0002:Class;
		[Embed(source = '../../../assets/red_knight/paused_se0003.png')]	private var paused_se0003:Class;
		[Embed(source = '../../../assets/red_knight/paused_se0004.png')]	private var paused_se0004:Class;
		[Embed(source = '../../../assets/red_knight/paused_se0005.png')]	private var paused_se0005:Class;
		[Embed(source = '../../../assets/red_knight/paused_se0006.png')]	private var paused_se0006:Class;
		[Embed(source = '../../../assets/red_knight/paused_se0007.png')]	private var paused_se0007:Class;
		[Embed(source = '../../../assets/red_knight/paused_se0008.png')]	private var paused_se0008:Class;
		
		[Embed(source = '../../../assets/red_knight/paused_sw0000.png')]	private var paused_sw0000:Class;
		[Embed(source = '../../../assets/red_knight/paused_sw0001.png')]	private var paused_sw0001:Class;
		[Embed(source = '../../../assets/red_knight/paused_sw0002.png')]	private var paused_sw0002:Class;
		[Embed(source = '../../../assets/red_knight/paused_sw0003.png')]	private var paused_sw0003:Class;
		[Embed(source = '../../../assets/red_knight/paused_sw0004.png')]	private var paused_sw0004:Class;
		[Embed(source = '../../../assets/red_knight/paused_sw0005.png')]	private var paused_sw0005:Class;
		[Embed(source = '../../../assets/red_knight/paused_sw0006.png')]	private var paused_sw0006:Class;
		[Embed(source = '../../../assets/red_knight/paused_sw0007.png')]	private var paused_sw0007:Class;
		[Embed(source = '../../../assets/red_knight/paused_sw0008.png')]	private var paused_sw0008:Class;
		
		[Embed(source = '../../../assets/red_knight/paused_w0000.png')]	private var paused_w0000:Class;
		[Embed(source = '../../../assets/red_knight/paused_w0001.png')]	private var paused_w0001:Class;
		[Embed(source = '../../../assets/red_knight/paused_w0002.png')]	private var paused_w0002:Class;
		[Embed(source = '../../../assets/red_knight/paused_w0003.png')]	private var paused_w0003:Class;
		[Embed(source = '../../../assets/red_knight/paused_w0004.png')]	private var paused_w0004:Class;
		[Embed(source = '../../../assets/red_knight/paused_w0005.png')]	private var paused_w0005:Class;
		[Embed(source = '../../../assets/red_knight/paused_w0006.png')]	private var paused_w0006:Class;
		[Embed(source = '../../../assets/red_knight/paused_w0007.png')]	private var paused_w0007:Class;
		[Embed(source = '../../../assets/red_knight/paused_w0008.png')]	private var paused_w0008:Class;
		
		public var cacheData:Object;
		public var isCachedValue:Boolean;
		
		public var description:XML = <desc>
				<anim name="paused" size="9"/>
				<anim name="run" size="9"/>
				<anim name="attack" size="9"/>
			</desc>;
		
		public function RedKnight() 
		{
			isCachedValue = false;
		}
		
		/* INTERFACE julio.resource.ICharAsset */
		
		public function isCached():Boolean
		{
			return isCachedValue;
		}
		
		private function addZeros(inputNumber:int, stringLength:int):String
		{
			var ret:String = String(inputNumber);
			while (ret.length < stringLength)
			{
				ret = "0" + ret;
			}
			return ret;
		}
		
		public function cache():void 
		{
			
			cacheData = new Object;
			
			var aniDir:Array = ["ne", "nw", "se", "sw", "s", "w", "n", "e"];
			
			for each( var s:XML in description.anim )
			{
				var name:String = s.@name;
				var size:int = int(s.@size);
				
				cacheData[name] = new Object;
				
				for ( var b:int = 0; b < aniDir.length; b++ )
				{
					cacheData[name][aniDir[b]] = new Vector.<Bitmap>;
					
					for ( var c:int = 0; c < size; c++ )
					{
						// paused_e0000
						cacheData[name][aniDir[b]].push( Bitmap(new this[name + "_" + aniDir[b] + addZeros(c, 4)]()) );
					}
				}
			}
			
			isCachedValue = true;
		}
		
		public function sizeX():int 
		{
			return 96;
		}
		
		public function sizeY():int 
		{
			return 96;
		}
		
		public function desc():XML 
		{
			return description;
		}
		
		public function data(name:String, dir:String, frame:int):Bitmap
		{
			trace("RedKnight::data() "+ name + "/" + dir + "/" + frame);
			return cacheData[name][dir][frame];
		}
	}

}