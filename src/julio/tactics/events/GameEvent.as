package julio.tactics.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class GameEvent extends Event
	{
		public static const FINISHED_LOADING:String = "FINISHED_LOADING";
		
		public function GameEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
		
		public override function clone():Event
		{
			return new GameEvent( type, bubbles, cancelable );
		}
		
		public override function toString():String
		{
			return formatToString( "GameEvent", "type", "bubbles", "cancelable", "eventPhase" );
		}
	}
}
