package julio.tactics
{
	import flash.utils.Timer;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class GameTimer
	{
		private var	_time:int;		// Tempo atual em milessegundos
		private var	_lastTime:int;	// Tempo anterior
		private var	_timeDelta:int;	// Diferença de tempo enre Tempo atual e anterior
		private var	_pause:Boolean;		// Se for verdadeiro pausa o timer
		
		public function GameTimer()
		{
			this._time = getTimer();
			this._lastTime = this._time;
			this._pause = false;
		};

		public function refresh():Boolean
		{
			if(!this._pause)
			{
				this._time  = getTimer();
			}

			this._timeDelta = (this._time - this._lastTime);
			this._lastTime  = this._time;
			return true;
		}
		
		public function get timeDelta():int
		{
			return this._timeDelta;
		}
		
		public function pause( pause:Boolean ):void
		{
			// se ja estava pausado
			if( this._pause )
			{
				// tenta continuar
				if( !pause )
				{
					this._pause = pause;
					this._lastTime = getTimer();
					return;
				}
				// se tentar pausar novamente nao faz nada
			}
			//se nao estava pausado
			if( !this._pause )
			{
				// tenta pausar
				if( pause )
				{
					this._pause = pause;
					return;
				}
				// se tentar continuar denovo, nao faz nada
			}
		}
	}
}