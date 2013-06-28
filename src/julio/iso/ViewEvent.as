package julio.iso
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class ViewEvent extends Event
	{
		public static const NEW_ADDED:String = "NEW_ADDED";
		
		public function ViewEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
		
		public override function clone():Event
		{
			return new ViewEvent( type, bubbles, cancelable );
		}
		
		public override function toString():String
		{
			return formatToString( "ViewEvent", "type", "bubbles", "cancelable", "eventPhase" );
		}
	}
}