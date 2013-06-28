package julio.tactics.events
{
	import adobe.utils.CustomActions;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class TurnEvent extends Event
	{
		public static const TURN_SELECT:String = "TURN_SELECT";
		public static const TURN_ANIMATION:String = "TURN_ANIMATION";
		public static const TURN_FX:String = "TURN_FX";
		public static const TURN_PARALLEL:String = "TURN_PARALLEL";
		public static const TURN_CHANGEDIR:String = "TURN_CHANGEDIR";
		public static const TURN_TELEPORT:String = "TURN_TELEPORT";
		public static const TURN_TALK:String = "TURN_TALK";
/*
		public static const STANDART_ACTION:String = "STANDART_ACTION";
		public static const MOVE_ACTION:String = "MOVE_ACTION";
		public static const END_ACTION:String = "END_ACTION";
		public static const CANCEL_ACTION:String = "CANCEL_ACTION";
*/
		public static const TURN:String = "TURN";
		
		public static const ACTION_SELECT:String = "ACTION_SELECT";
		public static const ACTION_SELECTED:String = "ACTION_SELECTED";
		public static const ACTION_CANCELED:String = "ACTION_CANCELED";
//		public static const TILE_CLICK:String = "TILE_CLICK";
//		public static const TILE_OVER:String = "TILE_OVER";

//		private var _x:int;				//
//		private var _z:int;				//
//		private var _actionId:String;	//
//		private var _actionType:String;	//
//		private var _subj:Object;		// kem faz a ação
//		private var _obje:Object;		// kem sofre a ação
		private var _data:XML;			// dados extras
		
		public function TurnEvent( /*subj:Object, obje:Object, actionId:String,*/ type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
//			this._actionId = actionId;
//			this._subj = subj;
//			this._obje = obje;
			this._data = <data/>;
		}
		
		public override function clone():Event
		{
			return new TurnEvent( /*_subj, _obje, _actionId,*/ type, bubbles, cancelable );
		}
		
		public override function toString():String
		{
			return formatToString( "TurnEvent", "type", "bubbles", "cancelable", "eventPhase" );
		}
		
//		public function get data():XML { return _data; }
//		public function set data(value:XML):void { _data = value; }
		
//		public function get actionType():String { return _actionType; }
//		public function get actionId():String { return _actionId; }
//		public function get subj():Object { return _subj; }
//		public function get obje():Object { return _obje; }
//		public function get x():int { return _x; }
//		public function get z():int { return _z; }
		
//		public function set actionType(value:String):void { _actionType = value; }
//		public function set actionId(value:String):void { _actionId = value; }
//		public function set subj(value:Object):void { _subj = value; }
//		public function set obje(value:Object):void { _obje = value; }
//		public function set x(value:int):void { _x = value; }
//		public function set z(value:int):void { _z = value; }
	}
}