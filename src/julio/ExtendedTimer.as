package julio
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author fjakobs
	 */
	public class ExtendedTimer extends Timer
	{
		private var _startTime : Number;
		private var _initialDelay : Number;
		private var _paused : Boolean = false;

		public function ExtendedTimer(delay : Number, repeatCount : int = 0)
		{
			super(delay, repeatCount);
			_initialDelay = delay;
			addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
		}

		private function onTimer(event : TimerEvent) : void
		{
			_startTime = new Date().time;
			delay = _initialDelay;
		}

		// timer gets reset
		override public function start() : void
		{
			if((currentCount < repeatCount) || (repeatCount == 0))
			{
				delay = _initialDelay; // added to “reset” timer
				_paused = false;
				_startTime = new Date().time;
				super.start();
			}
		}

		public function pause() : void
		{
			if(running)
			{
				_paused = true;
				stop();
				var newDelay:Number = delay - (new Date().time - _startTime);
				super.delay = (newDelay < 0) ? 0 : newDelay;
			}
		}

		// timer continues from where it left off
		public function resume() : void
		{
			if((currentCount < repeatCount) || (repeatCount == 0))
			{
				_paused = false;
				_startTime = new Date().time;
				super.start();
			}
		}

		override public function set delay(n:Number):void {
			super.delay = _initialDelay = n;
		}

		public function get paused() : Boolean
		{
			return _paused;
		}

		public function get initialDelay() : Number
		{
			return _initialDelay;
		}
	}
}