package julio.tactics.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class BattleEvent extends Event
	{
		public static const BATTLE_TURN_START:String = "BATTLE_TURN_START";
		public static const CHAR_TURN:String = "CHAR_TURN";
		
		public static const ACTION_SELECTED:String = "ACTION_SELECTED";
		public static const TARGET_SELECTED:String = "TARGET_SELECTED";
		
		
		private var _data:XML;
		
		public function BattleEvent( type:String, data:XML = null )
		{
			super( type, false, false );
			this._data = data;
		}
		
		public override function clone():Event
		{
			return new BattleEvent( type );
		}
		
		public override function toString():String
		{
			return formatToString( "BattleEvent", "type", "bubbles", "cancelable", "eventPhase" );
		}
		
		public function get data():XML { return this._data; }
	}
}
