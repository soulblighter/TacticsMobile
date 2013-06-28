﻿package julio.iso.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class TerrainBlockEvent extends Event
	{
		public static const TILE_CLICK:String = "TILE_CLICK";
		public var id:uint;
		public var x:int;
		public var z:int;
		
		public function TerrainBlockEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
		
		public override function clone():Event
		{
			return new TerrainBlockEvent( type, bubbles, cancelable );
		}
		
		public override function toString():String
		{
			return formatToString( "TerrainBlockEvent", "type", "bubbles", "cancelable", "eventPhase" );
		}
	}
}
	
