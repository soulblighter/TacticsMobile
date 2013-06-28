package julio.tactics.regras.GURPS.acoes
{
	import julio.tactics.regras.GURPS.acoes.*;
	import julio.tactics.regras.GURPS.Dano;
	import julio.tactics.regras.GURPS.Dados;
	import julio.tactics.regras.GURPS.enuns.EAcaoTipo;
	import julio.tactics.regras.GURPS.enuns.EAcaoAlcance;
	import julio.tactics.regras.GURPS.MoveType;
	import julio.tactics.regras.GURPS.Personagem;
	import julio.tactics.regras.GURPS.enuns.EDano;
	import julio.tactics.regras.GURPS.enuns.EAcao;
	
	/**
	 * Classe de ação de ataque customizável
	 * @author Júlio Cézar
	 */
	public class Movimento extends Acao
	{
		
		public function Movimento( /*id:String,*/ nome:String, magico:Boolean, alcance:uint, movetype:MoveType )
		{
			super(/*id,*/ nome, EAcaoTipo.MOV, EAcao.MOVE, magico, alcance, 0, movetype, movetype);
		}
		
	}
}
