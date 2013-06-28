package julio.tactics.regras.GURPS
{
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class Dados
	{
		private var _nDados:uint;
		private var _bonus:int;
		
		public function Dados( nDados:uint = 0, bonus:int = 0 )
		{
			this._nDados = nDados;
			this._bonus = bonus;
		}
		
		public function add( dados:Dados ):void
		{
			this._nDados += dados.nDados;
			this._bonus += dados.bonus;
		}
		
		public function get roll():int
		{
			var resultado:int = _bonus;
			for ( var i:int = 0; i < _nDados; i++ )
				resultado += (Math.random() * 5)+1;
			return resultado;
		}
		
		public function get half():int
		{
			var resultado:Number = _bonus;
			for ( var i:int = 0; i < _nDados; i++ )
				resultado += 3.5;
			return resultado;
		}
		
		public function get nDados():uint { return this._nDados; }
		public function get bonus():int { return this._bonus; }
	}
}
