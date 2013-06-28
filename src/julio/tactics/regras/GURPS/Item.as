package julio.tactics.regras.GURPS
{
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class Item
	{
		private var _id:int;			// Instance number (precisa ser unica para cada item no jogo!)
		private var _nome:String;
		private var _valor:int;			// valor da escudo
		private var _peso:Number;		// em kg
		
		public function Item(id:int, nome:String, valor:int, peso:Number)
		{
			this._id = id;
			this._nome = nome;
			this._valor = valor;
			this._peso = peso;
		}
		
		// getters
		public function get id():int { return this._id; }
		public function get nome():String { return this._nome; }
		public function get valor():int { return this._valor; }
		public function get peso():Number { return this._peso; }
		
		// setters
		public function set nome(value:String):void { this._nome = value; }
		public function set valor(value:int):void { this._valor = value; }
		public function set peso(value:Number):void { this._peso = value; }
	}
}
