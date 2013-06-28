package julio.tactics.regras.GURPS
{
	import julio.tactics.regras.GURPS.enuns.EDano;
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class Dano
	{
		private var _valor:Number;
		private var _tipo:EDano;
		private var _ignoraRD:Boolean;
		
		public function Dano( valor:Number, tipo:EDano, ignoraRD:Boolean = false )
		{
			this._valor = valor;
			this._tipo = tipo;
			this._ignoraRD = ignoraRD;
		}
		
		public function get valor():Number { return this._valor; }
		public function get tipo():EDano { return this._tipo; }
		public function get ignoraRD():Boolean { return this._ignoraRD; }
		
		public function soma( dano:Dano ):Dano
		{
			return new Dano( this.valor + dano.valor, this._tipo );
		}
	}
}
