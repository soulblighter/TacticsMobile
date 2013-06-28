package julio.tactics.regras.GURPS
{
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class Armadura extends Item
	{
		private var _DP:int;			// bonus de defesa passiva da armadura
		private var _RD:int;			// bonus de resistencia a dano da armadura
		
		private var _ST_min:int;		// ST minimo para utilizar a armadura (se o personagem tiver ST menor q esse entao ele usa a armadura com redutor no NH de [Arma.ST_min - Personagem.ST] )
		
		public function Armadura(id:int, nome:String, valor:int, peso:Number, DP:int, RD:int, redutor:int, ST_min:int)
		{
			super(id, nome, valor, peso);
			
			this._DP =  DP;
			this._RD = RD;
			
			this._ST_min = ST_min;
		}
		
		// getters
		public function get DP():int { return this._DP; }
		public function get RD():int { return this._RD; }
		
		public function get ST_min():int { return this._ST_min; }
		
		// setters
		public function set DP(value:int):void { this._DP = value; }
		public function set RD(value:int):void { this._RD = value; }
		
		public function set ST_min(value:int):void { this._ST_min = value; }
	}
}
