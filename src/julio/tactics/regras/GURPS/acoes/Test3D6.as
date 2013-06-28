package julio.tactics.regras.GURPS.acoes
{
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	
	/**
	 * Ordem normal dos evento da batlha
	 *
	 *
	 * Pre-battle [	// informação necessária para começar a batalha
	 * 		Mapa (grafo, eventos, resouuces)
	 * 		Lista de personagens de cada time (dados do sheet, resources)
	 * 		posição inicial de cada personagem
	 * ]
	 *
	 * Battle [
	 * 		Eventos iniciais
	 * 			Atualiza fila de ações
	 *
	 * 		while(true)
	 * 		{ // Loop da batalha
	 * 			testa lista de [StartBattleEvents]
	 *
	 * 			pega o primeiro peronagem da fila
	 *
	 * 			// inicia o turno do personagem
	 * 			while(persongem atual tem ações retantes livre/padrao/movimento )
	 * 			{ // loop do turno
	 * 				testa lista de [StartTurnEvents]
	 *
	 * 				se for personagem do jogador
	 * 					mostra lista de ações disponivel
	 * 				se for NPC
	 * 					AI escolhe ação automaticamente
	 *
	 * 				[ação escolhida]
	 *
	 * 				[executa ação no alvo] {teste 3d6 resitido}
	 * 				{	// exemplo: ação Ataque BAL
	 * 					// tipo: basicMeleeAtack
	 * 					// base defs: [evade, block, parry, magicBlock, magicEvade]
	 * 					// dados de entrada:
	 * 					// subject:		[João st 14, dx 12, iq 10, ht 14]
	 * 					// objects(1):	[[Maria st 12, dx 16, iq 10, ht 10]]
	 *
	 * 					// 1ª fase, dados do atacante
	 * 					subjectNH = subject.skills[subj.getWeapon().getSkillid()].NH;
	 *
	 * 					// passa por todas as vantagens/desvantagens que modificam "basicMeleeAtack"
	 * 					// nesse exemplo nenhuma modifica...
	 *
	 * 					// 2º fase, dados do(s) alvo(s)
	 * 					object escolhe a melhor defesa disponivel entre uma dessa lista: [evade, block, parry, magicBlock, magicEvade]
	 * 					[esolhido: parry, NH 14]
	 *
	 * 					// 3ª fase, resolução
	 * 					alvo perde uma utilização de aparar por tuno
	 * 					joga o NH de acerto do atacante
	 * 					joga o NH da defesa do alvo
	 * 					verifica qual possui o maior margem de acerto
	 * 					reolve acerto, erro, falha critica, acerto critico
	 * 					distribui o dano/efeito se for o caso
	 * 				}
	 *
	 *
	 * 				testa lista de [EndTurnEvents]
	 * 			}
	 *
	 * 			testa lista de [Battle events]
	 * 			se algum evento resultar em endbattle
	 * 				break;
	 *
	 * 		} // fim do loop da batalha
	 *
	 *
	 *
	 * ] // End Battle
	 *
	 *
	 *
	 */
	
	
	
	
	
	
	
	
	
	
	
	
	public class Test3D6
	{
		private var _type:Array;		// reação, melee, ranged, fire magic, wind magic
		private var _NH:uint;			//
		private var _defenses:Array;	// lista de defesas permitidas: esquiva, bloquear, aparar, magic_block, magic_evade, psi_block, psi_evade
		
		public function Test3D6(NH:uint, type:Array, defenses:Array)
		{
			this._NH = NH;
			this._type = type;
			this._defenses = defenses;
		}
		
		public function get NH():uint { return this._NH; }
		public function get type():Array { return this._type; }
		public function get defenses():Array { return this._defenses; }
	}
}
