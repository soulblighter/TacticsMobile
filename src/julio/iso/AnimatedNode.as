package julio.iso
{
	import away3d.core.math.Number2D;
	import away3d.core.math.Number3D;
	import away3d.core.math.Matrix3D;
	import away3d.core.math.Quaternion;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.hexagonstar.display.FrameRateTimer;
	import com.hexagonstar.env.event.FrameEvent;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import julio.iso.events.AnimationNodeEvent;
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class AnimatedNode extends DisplayNode
	{
		protected var _dispatcher:EventDispatcher;
		protected var _timer:FrameRateTimer;	// temporizador da animação
		protected var _isPlaying:Boolean;		// determina se a animação esta funcionando ou parada
		protected var _loop:int;			// marca quantas vezes a animação deve repetir, valor negativo repete infinitamente
		protected var _enableEvents:Boolean;
		protected var _baseAnimTime:uint;		// marca quanto tempo deve durar cada animação em mileseconds
		
		private var _frameNr:uint;			// frame atual da animação
		private var _frameAmount:uint;		// quantidade de frames de animação

//		private var _from:uint;				// porcentagem q a animação deve começar (0-100)
//		private var _to:uint;				// porcentagem q a animação deve terminar (0-100) & to>from
//		private var _atualPorc:uint;		// porcentagem atual da animação
		private var _frameStart:uint;		// frame q a animação deve começar
		private var _frameEnd:uint;			// frame q a animação deve terminar
		
		public function AnimatedNode( displayType:Class, pos:Number3D, rot:Quaternion, size:Number3D, nodeName:String, renderPriority:uint = 0, onlyDefaultRender:Boolean = true )
		{
			super(displayType, pos, rot, size, nodeName, renderPriority, onlyDefaultRender);
			
			_baseAnimTime = 2000;		// 0,5 segundos 
			
			_frameNr = 0;
			_frameAmount = 0;
			
//			_from = 0;
//			_to = 100;
//			_atualPorc = 0;
			_frameStart = 0;
			_frameEnd = 0;
			
			_loop = -1;
			_isPlaying = false;
			_timer = new FrameRateTimer();
			_enableEvents = false;
//			_dispatcher = new EventDispatcher;
		}
		
		public function get dispatcher():EventDispatcher { return this._dispatcher; }
		public function set dispatcher(value:EventDispatcher):void { this._dispatcher = value; }
		public function get enableEvents():Boolean { return this._enableEvents; }
		public function set enableEvents(value:Boolean):void { this._enableEvents = value; }
		
		public function set aninPosStop( value:uint ):void { gotoAndStop( value ) };
		public function set aninPosPlay( value:uint ):void { gotoAndPlay( value ) };
		public function get aninPos():uint { return getCurrentFrame(); }
		
//		public function get from():uint { return this._from; };
//		public function set from( value:uint ):void { if (value > 100) value = 100; this._from = value; };
//		public function get to():uint { return this._to; };
//		public function set to( value:uint ):void { if (value > 100) value = 100; this._to = value; };
//		public function get atualPorc():uint { return this._atualPorc; };
//		public function set atualPorc( value:uint ):void { if (value > 100) value = 100; this._atualPorc = value; };
		
		public function get loop():int { return this._loop; };
		public function set loop( value:int ):void { this._loop = value; };
		
		protected function get frameAmount():uint { return this._frameAmount; };
		protected function set frameAmount( value:uint ):void { this._frameAmount = value; if (value > 0) setFrameRateTimer( AnimTime / value); };
		
		protected function get lastFrame():uint { if (frameAmount > 0) { return frameAmount - 1; } else return 0; }
		
		protected function get frameNr():uint { return this._frameNr; };
		protected function set frameNr( value:uint ):void { if (value >= frameAmount) value = frameAmount - 1; this._frameNr = value; };
		
		public function get AnimTime():uint { return this._baseAnimTime; };
		public function set AnimTime( value:uint ):void { this._baseAnimTime = value; if (frameAmount > 0) setFrameRateTimer( AnimTime / frameAmount); };
		
		public function gotoAndPlay( value:uint ):void
		{
			frameNr = value;
			play();
		}
		
		public function resetAnim():void
		{
			frameNr = _frameStart;
		}
		
		public function gotoAndStop( value:uint ):void
		{
			frameNr = value;
			stop();
		}
		
		protected function setFrameRateTimer( value:Number ):void // timer:FrameRateTimer
		{
//			if (_isPlaying)
//			{
//				stop();
				_timer.delay = value;// = timer;
//				play();
//			}
//			else
//			{
//				_timer.delay =  value;// = timer;
//			}
		}
		
		public function getFrameRate():int
		{
			return _timer.getFrameRate();
		}
		
		public function getCurrentFrame():int
		{
			return frameNr;
		}
		
		public function isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		public function play( loop:int = 0 ):void
		{
			if (!_isPlaying)
			{
				this.loop = loop;
				_isPlaying = true;
				_timer.addEventListener(TimerEvent.TIMER, playForward);
				_timer.start();
			}
			else
			{
				stop();
				play(loop);
			}
		}
		
		public function stop():void
		{
			if (_isPlaying)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, playForward);
				_isPlaying = false;
			}
		}
		
		private function playForward(event:TimerEvent = null):void
		{
			if (frameNr == lastFrame)
			{
				if (loop > 0 || loop < 0)
				{	resetAnim(); this.loop--; }
				else
				{ frameNr = lastFrame; stop();	}
				
				if (_dispatcher != null && enableEvents)
				{
					_dispatcher.dispatchEvent( new AnimationNodeEvent( AnimationNodeEvent.ANIMATION_END ) );// new Event( Event.COMPLETE ) );//
				}
			}
			
//			else if (frameNr < 0) frameNr = 0;
			redraw();
			frameNr++;
		}
		
		public function redraw():void
		{
			
		}
	}
}
