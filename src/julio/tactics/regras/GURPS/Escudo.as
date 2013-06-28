package julio.tactics.regras.GURPS
{
	import julio.tactics.regras.GURPS.enuns.*;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class Escudo extends Item
	{
		private var _pericia:EPericia;		// Tipo da peria para usar o escudo
		
		private var _DP:int;			// bonus de defesa passiva da escudo
		private var _RD:int;			// bonus de resistencia a dano da escudo
		
		private var _redutor:int;		// penalidade no NH para utlizar a escudo (i.e. escudo faceis e dificeis de usar de GURPS)
		private var _ST_min:int;		// ST minimo para utilizar a escudo (se o personagem tiver ST menor q esse entao ele usa a escudo com redutor no NH de [Arma.ST_min - Personagem.ST] )
		
		public function Escudo(id:int, nome:String, valor:int, peso:Number, pericia:EPericia, DP:int, RD:int, redutor:int, ST_min:int)
		{
			super(id, nome, valor, peso);
			
			this._pericia =  pericia;
			
			this._DP =  DP;
			this._RD = RD;
			
			this._redutor = redutor;
			this._ST_min = ST_min;
		}
		
		// getters
		public function get pericia():EPericia { return this._pericia; }
		
		public function get DP():int { return this._DP; }
		public function get RD():int { return this._RD; }
		
		public function get ST_min():int { return this._ST_min; }
		public function get redutor():int { return this._redutor; }
		
		// setters
		public function set DP(value:int):void { this._DP = value; }
		public function set RD(value:int):void { this._RD = value; }
		
		public function set ST_min(value:int):void { this._ST_min = value; }
		public function set redutor(value:int):void { this._redutor = value; }
	}
}
