package julio.tactics.regras.GURPS
{
	import julio.tactics.regras.GURPS.enuns.*;
	import julio.tactics.regras.GURPS.Personagens.IModListaAcoes;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class Arma extends Item
	{
		private var _pericia:EPericia;	// Pericia para usar a amra
		
		private var _BAL:Dados;			// Dano extra quando a arma eh utilizanda em balanço
		private var _GDP:Dados;			// Dano extra quando a arma eh utilizanda em perfuração
		
		private var _maxBAL:Dados;		// Dano maximo quando a arma eh utilizanda em balanço
		private var _maxGDP:Dados;		// Dano maximo quando a arma eh utilizanda em perfuração
		
		private var _cortante:Boolean	// marca se a arma pode ser utilizada para um araque de BAL
		private var _perfurante:Boolean	// marca se a arma pode ser utilizada para um araque de GDP
		
		private var _redutor:int;		// penalidade no NH para utlizar a arma (i.e. armas faceis e dificeis de usar de GURPS)
		private var _ST_min:int;		// ST minimo para utilizar a arma (se o personagem tiver ST menor q esse entao ele usa a arma com redutor de [Arma.ST_min - Personagem.ST] )
		
		private var _breakMod:Number;	// Chance da arma quebar em um aparar (ex.: 0.0 significa q a arma eh indestruitivel, 1.0 significa q a arma segue a chance de kebra padrao (ou seja 1/6% chance)
		
		public function Arma(	id:int, nome:String, valor:int, peso:Number, pericia:EPericia,
								BAL:Dados, GDP:Dados, maxBAL:Dados, maxGDP:Dados,
								redutor:int, ST_min:int, breakMod:Number )
		{
			super(id, nome, valor, peso);
			
			this._pericia =  pericia;
			
			this._cortante =  true;
			this._perfurante = true;
			
			this._BAL =  BAL;
			this._GDP = GDP;
			
			this._maxBAL =  maxBAL;
			this._maxGDP = maxGDP;
			
			this._redutor = redutor;
			this._ST_min = ST_min;
			this._breakMod = breakMod;
		}
		
		// getters
		public function get pericia():EPericia { return this._pericia; }
		
		public function get BAL():Dados { return this._BAL; }
		public function get GDP():Dados { return this._GDP; }
		
		public function get maxBAL():Dados { return this._maxBAL; }
		public function get maxGDP():Dados { return this._maxGDP; }
		
		public function get cortante():Boolean { return this._cortante; }
		public function get perfurante():Boolean { return this._perfurante; }
		
		public function get redutor():int { return this._redutor; }
		public function get ST_min():int { return this._ST_min; }
		public function get breakMod():Number { return this._breakMod; }
		
		// setters
		public function set BAL(value:Dados):void { this._BAL = value; }
		public function set GDP(value:Dados):void { this._GDP = value; }
		
		public function set maxBAL(value:Dados):void { this._maxBAL = value; }
		public function set maxGDP(value:Dados):void { this._maxGDP = value; }
		
		public function set cortante(value:Boolean):void { this._cortante = value; }
		public function set perfurante(value:Boolean):void { this._perfurante = value; }
		
		public function set redutor(value:int):void { this._redutor = value; }
		public function set ST_min(value:int):void { this._ST_min = value; }
		public function set breakMod(value:Number):void { this._breakMod = value; }
		
	}
}
