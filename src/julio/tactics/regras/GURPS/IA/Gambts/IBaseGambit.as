package julio.tactics.regras.GURPS.IA.Gambts
{
	import julio.tactics.regras.GURPS.IA.*;
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public interface IBaseGambit
	{
		function test( target:EIA_Target, subject:Personagem, objects:Array ):Boolean;
	}

}
