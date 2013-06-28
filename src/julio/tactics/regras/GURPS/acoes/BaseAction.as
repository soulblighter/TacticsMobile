package julio.tactics.regras.GURPS.acoes
{
	import julio.tactics.regras.GURPS.Dados;
	import julio.tactics.regras.GURPS.Dano;
	import julio.tactics.regras.GURPS.enuns.*;
	import julio.tactics.regras.GURPS.MoveType;
	import julio.tactics.regras.GURPS.Personagens.*;
	import julio.tactics.regras.GURPS.Personagem;
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class BaseAction
	{
		private var _id:String;					// identificação única
		private var _nome:String;
		private var _tipoAcao:EAcaoTipo;
		
		protected var _testes:Array;			// lista de Testes a serem realizadas pela ação
		
		private var _selection:ESelectionType;	// tipo de seleção
		private var _selectionMin:uint;			// distancia minima de area da seleção
		private var _selectionMax:uint;			// distancia maxima de area da seleção
		
		private var _area:ESelectionType;		// area de efeito
		private var _areaMin:uint;				// distancia minima de area de efeito
		private var _areaMax:uint;				// distancia maxima de area de efeito
		
		public function BaseAction( id:String, nome:String, tipoAcao:EAcaoTipo, selection:ESelectionType, selectionMin:uint, selectionMax:uint, area:ESelectionType, areaMin:uint, areaMax:uint )
		{
			this._id = id;
			this._nome = nome;
			this._tipoAcao = tipoAcao;
			this._selection = selection;
			this._selectionMin = selectionMin;
			this._selectionMax = selectionMax;
			this._area = area;
			this._areaMin = areaMin;
			this._areaMax = areaMax;
			this._testes = [];
		}
		
//		public function get id():String { return this._id; }
//		public function set id(value:String):void { this._id = value; }
		
//		public function get nome():String { return this._nome; }
//		public function set nome(value:String):void { this._nome = value; }
		
//		public function get tipoAcao():EAcaoTipo { return this._tipoAcao; }
//		public function set tipoAcao(value:EAcaoTipo):void { this._tipoAcao = value; }
		
		public function get selection():ESelectionType { return this._selection; }
		public function set selection(value:ESelectionType):void { this._selection = value; }
		
		public function get area():ESelectionType { return this._area; }
		public function set area(value:ESelectionType):void { this._area = value; }
		
		public function get selectionMin():uint { return this._selectionMin; }
		public function set selectionMin(value:uint):void { this._selectionMin = value; }
		
		public function get selectionMax():uint { return this._selectionMax; }
		public function set selectionMax(value:uint):void { this._selectionMax = value; }
		
		public function get areaMin():uint { return this._areaMin; }
		public function set areaMin(value:uint):void { this._areaMin = value; }
		
		public function get areaMax():uint { return this._areaMax; }
		public function set areaMax(value:uint):void { this._areaMax = value; }
	}
}
