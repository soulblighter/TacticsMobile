package julio.tactics
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class InstructionInterpreter
	{
		public var instruction:Function;
		public var endExecution:Function;
		
		private var _d:DisplayInstruction;
		private var _timer:Timer
		
		public function InstructionInterpreter( d:DisplayInstruction )
		{
			this._d = d;
		}
		
		public function startExecution():void
		{
			if ( _d.prefixPadding > 0 )
				executePrefix( _d.prefixPadding );
			else
				executeInstruction( _d );
		}
		
		private function executePrefix( time:Number ):void
		{
			_timer = new Timer( time );
			_timer.addEventListener( TimerEvent.TIMER, endPrefix );
			_timer.start();
		}
		
		private function endPrefix( e:TimerEvent ):void
		{
			_timer.stop();
			_timer = null;
			executeInstruction(_d);
		}
		
		private function executeInstruction( d:DisplayInstruction ):void
		{
			instruction(_d.data, this);
/*			switch( d.tipo )
			{
//				case DisplayInstruction.START:		turnStart( e ); break;
				case DisplayInstruction.ADD_CHAR:	instruction(d.data, this); break;
//				case DisplayInstruction.ANIMATION:	actionAnimation( e ); break;
//				case DisplayInstruction.CHANGEDIR:	actionChangeDir( e ); break;
//				case DisplayInstruction.FX:			actionFx( e ); break;
//				case DisplayInstruction.TALK:		actionTalk( e ); break;
//				case DisplayInstruction.TELEPORT:	actionTeleport( e ); break;
//				case DisplayInstruction.MOVE:		actionMove( e ); break;
				default:	throw new Error("\"" + d.tipo +"\" não eh um tipo de DisplayInstruction válido!");
			}*/
		}
		
		private function endInstruction():void
		{
			if ( _d.sufixPadding > 0 )
				executeSufix( _d.sufixPadding );
			else
				endExecution();
		}
		
		private function executeSufix( time:Number ):void
		{
			_timer = new Timer( time );
			_timer.addEventListener( TimerEvent.TIMER, endSufix );
			_timer.start();
		}
		
		private function endSufix( e:TimerEvent ):void
		{
			_timer.stop();
			_timer = null;
			endExecution();
		}

	}
}
