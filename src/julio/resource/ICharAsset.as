package julio.resource 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Soulblighter
	 */
	public interface ICharAsset 
	{
		
		function isCached():Boolean;
		function cache():void;
		function sizeX():int;
		function sizeY():int;
		function desc():XML;
		function data(name:String, dir:String, frame:int):Bitmap;
		
	}

}