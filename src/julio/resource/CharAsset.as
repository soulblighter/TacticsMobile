package julio.resource 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Soulblighter
	 */
	public class CharAsset 
	{
		public var cacheData:Object;
		public var isCachedValue:Boolean = false;
		
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
			
			var tempDesc:XML = desc();
			
			for each( var s:XML in tempDesc.anim )
			{
				var name:String = s.@name;
				var size:int = int(s.@size);
				
				cacheData[name] = new Object;
				
				for ( var b:int = 0; b < aniDir.length; b++ )
				{
					cacheData[name][aniDir[b]] = new Vector.<Bitmap>;
					
					for ( var c:int = 0; c < size; c++ )
					{
//						trace("RedKnight::cache() "+ name + "_" + aniDir[b] + addZeros(c, 4));
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
			var description:XML = <desc />;
			return description;
		}
		
		public function data(name:String, dir:String, frame:int):Bitmap
		{
			//trace("RedKnight::data() "+ name + "/" + dir + "/" + frame);
			return cacheData[name][dir][frame];
		}

	}

}