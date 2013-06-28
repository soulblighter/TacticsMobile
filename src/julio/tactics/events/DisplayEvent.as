package julio.tactics.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class DisplayEvent extends Event
	{
		// new events (ConsoleView)
		public static const CONSOLE:String = "CONSOLE";
		public static const TURN_START:String = "TURN_START";
		public static const GET_ACTION:String = "GET_ACTION";
		public static const ADD_CHAR:String = "ADD_CHAR";
		public static const MAP:String = "MAP";
		public static const ACTION:String = "ACTION";
		public static const MOVE:String = "MOVE";
		
		// old events (CenaBatalha)
/*		private static const END_INSTRUCTION:String = "END_INSTRUCTION";
		
		public static const START:String = "START";
		
		public static const SELECT:String = "SELECT";
		public static const ANIMATION:String = "ANIMATION";
		public static const FX:String = "FX";
//		public static const PARALLEL:String = "PARALLEL";
		public static const CHANGEDIR:String = "CHANGEDIR";
		public static const TELEPORT:String = "TELEPORT";
		public static const MOVE:String = "MOVE";
		public static const TALK:String = "TALK";
		*/
		public var data:*;			// dados extras

		public function DisplayEvent( type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
			this.data = data;
		}
		
		public override function clone():Event
		{
			return new DisplayEvent( type, bubbles, cancelable );
		}
		
		public override function toString():String
		{
			return formatToString( "DisplayEvent", "type", "bubbles", "cancelable", "eventPhase" );
		}
	}
}
