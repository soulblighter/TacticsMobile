package julio.tactics.regras.GURPS
{
	import julio.tactics.regras.GURPS.enuns.EDefesaAtiva;
	/**
	 * ...
	 * @author ...
	 */
	public class Defesa
	{
		private var _tipo:EDefesaAtiva;
		private var _NH:uint;
		
		public function Defesa( tipo:EDefesaAtiva, NH:uint )
		{
			this._tipo = tipo;
			this._NH = NH;
		}
		
		public function get tipo():EDefesaAtiva { return this._tipo; }
		public function get NH():uint { return this._NH; }
	}
}
