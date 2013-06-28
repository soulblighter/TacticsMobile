package 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class CenaEvent extends Event 
	{
		public static const START_SCENE:String = "START_SCENE";
		public static const LOADING:String = "LOADING";
		public static const RENDERING:String = "RENDERING";
		public static const END_SCENE:String = "END_SCENE";
		
		public function CenaEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
		
		public override function clone():Event
		{
			return new CenaEvent( type, bubbles, cancelable );
		}
		
		public override function toString():String
		{
			return formatToString( "CenaEvent", "type", "bubbles", "cancelable", "eventPhase" );
		}
	}
	
}