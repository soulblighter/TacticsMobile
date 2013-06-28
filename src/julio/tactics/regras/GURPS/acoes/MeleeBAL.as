package julio.tactics.regras.GURPS.acoes
{
	import julio.tactics.regras.GURPS.enuns.EAcaoTipo
	import julio.tactics.regras.GURPS.enuns.ETeste;
	import julio.tactics.regras.GURPS.enuns.EDefesaAtiva;
	/**
	 * ...
	 * @author ...
	 */
	public class MeleeBAL extends BaseAction
	{
		public function MeleeBAL( id:String )
		{
			super( id, "BAL", EAcaoTipo.STD, ESelectionType.SQUARE, 1, 1, ESelectionType.SQUARE, 0, 0 );
			this._testes = [
							{	base:"resisted",
								teste:ETeste.MELEE,
								baseDefs:[EDefesaAtiva.APARAR, EDefesaAtiva.BLOQUEAR, EDefesaAtiva.ESQUIVA, EDefesaAtiva.MAGIC_BLOCK, EDefesaAtiva.MAGIC_EVADE]
							}
						];
		}
		
	}

}
