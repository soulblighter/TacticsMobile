package julio.display 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Júlio Cézar M Menezes
	 */
	public class FpsDisplay extends Sprite 
	{
		// fps display
		public var _fpsText:TextField;
		public var _fpsLastTime:Number;
		public var _frameCount:Number;
		public var _FPS:Number;
		public var _fpsTimeElapsed:Number;
		public var _fpsCurrentTime:Number;
		public var _fpsTimeDelta:Number;
		
		public function FpsDisplay() 
		{
			// FPS
			_frameCount = 0;
			_FPS = 0;
			_fpsTimeElapsed = 0;
			_fpsLastTime = getTimer();
			_fpsText = new TextField();
			_fpsText.text = "0";
			_fpsText.selectable = false;
			_fpsText.textColor = 0xFF0000;
			
			this.addChild(_fpsText);
		}
		
		public function update():void
		{
			this._fpsCurrentTime = getTimer();
			this._fpsTimeDelta = this._fpsCurrentTime - this._fpsLastTime;
			var fps:Number  = calcFPS(this._fpsTimeDelta);
			this._fpsText.text = "FPS: " + String(Math.round(calcFPS(this._fpsTimeDelta) * 1000));
			//trace(_fpsTimeDelta + "/" + fps);
			this._fpsLastTime = this._fpsCurrentTime;
		}
		
		public function calcFPS(fpsTimeDelta:Number):Number
		{
			_frameCount++;
			_fpsTimeElapsed += _fpsTimeDelta
			if (_fpsTimeElapsed >= 1000.0)
			{
				_FPS = _frameCount / _fpsTimeElapsed;
				_fpsTimeElapsed = 0.0;
				_frameCount = 0;
			}
			return _FPS;
		}
	}

}