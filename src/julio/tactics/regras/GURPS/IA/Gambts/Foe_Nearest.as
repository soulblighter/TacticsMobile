package julio.tactics.regras.GURPS.IA.Gambts
{
	import julio.tactics.regras.GURPS.Personagem;
	import julio.tactics.regras.GURPS.IA.EIA_Target;
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class Foe_Nearest implements IBaseGambit
	{
		private var _target:EIA_Target;		// alvo
		
		public function Foe_Nearest()
		{
			
		}
		
		public function test( target:EIA_Target, subject:Personagem, objects:Array ):Boolean
		{
			return false;
		}
		
	}

}
