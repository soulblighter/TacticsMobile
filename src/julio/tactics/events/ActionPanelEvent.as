package julio.tactics.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class ActionPanelEvent extends Event
	{
		public static const MOUSE_TILE_CLICK:String = "MOUSE_TILE_CLICK";
		public static const ACTION_CANCELED:String = "ACTION_CANCELED";
		public static const ACTION_SELECTED:String = "ACTION_SELECTED";
		
		public var actionId:String;
		
		public function ActionPanelEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
		
		public override function clone():Event
		{
			return new ActionPanelEvent( type, bubbles, cancelable );
		}
		
		public override function toString():String
		{
			return formatToString( "MouseBattleEvent", "type", "bubbles", "cancelable", "eventPhase" );
		}
	}
}