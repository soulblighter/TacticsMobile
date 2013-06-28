package
{
	import julio.tactics.regras.GURPS.acoes.BaseAction;
	import julio.tactics.regras.GURPS.Personagem;
	
	/**
	 * Essa classe resolve uma jogada de dados
	 * Ela é iniccialmente modificada pelo atacante, onde sao pegos os modificadoes
	 * de acerto dele, depois eh modificada pelo defensor.
	 * Quando o atacante/defensor modifica o objeto, ele veririca informações sobre
	 * o tipo de ação e o oponente, dependendo de seus talentos/pericias ele pode
	 * vir a ter bonus ou poder realizar uma defesa / resistencia
	 *
	 * Ex.: AtaqueBAL
	 * O personagem atacante modifica a classe colocando seu NH de acerto, dano
	 * verifica o alvo e adiciona algum bonus contra aquele tipo de oponente se tiver
	 * esse tipo de ação permite aparar, bloquear e eskivar
	 *
	 * O defensor verifica o tipo de ação (no caso AtaqueBAL), e o atacante
	 * ele escolhe um tipo de defesa para utilizar e diz qual seu NH nela
	 * se fosse um mago, poderia utilizar a magia translocação
	 *
	 * -- depois da classe modificada a ação é resolvida
	 * faz o teste de acerto do atacante
	 * faz o teste de defesa do alvo
	 * oq tiver maior margem de acerto vence a disputa
	 * no caso do atacante o alvo leva o dano
	 * se o defensor vencer ele consegue utilizar sua defesa escolhida
	 *
	 *
	 * Ex.: Teste da pericia "Sex Apeal"
	 * Atacante: Humano "Ladino" -x- Defensor: Elfa Maga
	 * O atacante tem as vantagens "Empatia com Animais" e "Carisma +2"
	 * o NH do atacante eh 12
	 * a ação será mosificada pelo atacante, ele possui 2 vantagens q modificam
	 * testes de reação (no caso a pericia Sex Apeal eh um teste de reação)
	 * a vantagem Empatia com Animais terá a oportunidade de verificar a situção
	 * e verá q o defensor (a elfa) não é um animal e não dará bonus nenhum
	 * a vantagem Carisma +2 verifica q esse teste eh influenciado por ela e adiciona
	 * +2 no NH.
	 * entao o NH final eh 14
	 *
	 * O defensor verifica a ação e ver se possui alguma vantagem/desvantagem/buff/debuff
	 * que a altere. não tendo, nenhuma defesa eh possível.
	 *
	 * A ação eh resolvida e o resultado eh conferido na tabela de reação
	 *
	 *
	 *
	 * Ex.: Magia "Bola de fogo"
	 * Subject: Mago		-x-		Object Paladino
	 * O subjec precisa criar a magia, entao hitTestSimple(subjet) eh utilizado
	 * 	-> o hitTestSimple faz o teste para quando não existem alvos
	 * 	-> ele pode ser modificado por vantagens/desvantagens/buffs/debuffs
	 *  -> o mago faz o teste usando seu NH de criar a magia
	 * se ele não conseguir fazer a magia a ação acaba
	 * se ele conseguir então começa um hitTest(subject, object)
	 * o subject faz o teste usando sua pericia de arremesso de projetil
	 * o object tem direito a somente esquivar
	 * se o subject vencer a disputa
	 * damage( subject, object ) resolve o dano
	 * nessa etapa resistencias a elemeno/magia se aplicam
	 * se o personaem tiver um bonus de dano contra determinado inimigo,
	 * essa eh a hora do bonus ser aplicado
	 *
	 *
	 *
	 *
	 *
	 * tipos de ataque:
	 * 		Fisica
	 * 		magica
	 * 		social		(inclui reação)
	 *
	 *
	 *
	 * tipos de defesa:
	 * 		aparar				// aparar com arma ou mãos
	 * 		bloquear			// bloquear com arma
	 * 		esquivar			// esquivar
	 * 		magic_block			// blocquar com magia (ex.:?)
	 * 		magic_evade			// esquivar com magia (ex.: translocação)
	 * 		psi_block			// blocquar com psi (ex.:?)
	 * 		pis_evade			// esquivar com psi (ex.:?)
	 *
	 * tipos de resistencias:
	 * 		resistencia a dano
	 * 		resistencia a magia
	 * 		resistencias especificas	(ex.: imunidade a paralizia)
	 * 		resistido por IQ	(ex.: magia sono)
	 * 		resistido por DX
	 * 		resistido por ST	(ex.: tentar empurrar outra pessoa)
	 * 		resistido por HT
	 *
	 *
	 *
	 * Durante o teste de acerto
	 * 		Dados determinados pelo atacante:
	 * 			Objeto ação/ataque		ex.: AtaqueBAL, Bola de Fogo Explosiva, etc
	 * 			NH
	 * 			lista de defesas permitidas
	 * 		Dados determinados pelo defensor:
	 * 			Objecto ação/defesa		ex.: Esquiva, Translocação, Aparar
	 * 			NH
	 * 			defesa escolhida (esse dado por vir altomaticamente no objeto ação/defesa)
	 *
	 *
	 *
	 * @author Júlio Cézar
	 */
	public class ActionSolver
	{
		
		function ActionSolver( action:BaseAction, subject:Personagem, objects:Array )
		{
			// o jogador/AI jah escolheu o lugar onde executar a skill, o ActionSolver soh recebe os alvos que estao na area de feito
			
			// pega lista de testes de action
			// para cada Teste t em action.teste
				// se t.base == "simple"
					// chama subject.doBaseTeste( t );
					// o subject deve colocar seu NH no teste, etc.
					// testa NH
				// se t.base == "resisted"
					// para cada
					// chame subject.doResistedTes( t, object )
			
			// executa cada uma em ordem
			
		}
		
		
		// realiza uma jogada de acerto
		// pode ser uitilizada para qualquer tipo de jogada
		// ataque, pericia, etc.
		// defesa e resistencias possiveis são possiveis se definidas
		// subject -> quem está realizando o teste
		// object -> kem sofre a ação
		// return -> true se bem sucedido ou false em falha
		public function hitTest( subject:Personagem, object:Personagem ):Boolean
		{
			
		}
		
		
		// realiza uma jogada de acerto sem openente (i.e.: jogada de sorte)
		// pode ser uitilizada para qualquer tipo de jogada
		// ataque, defesa, pericia, resistido, etc.
		// subject -> quem está realizando o teste
		// return -> true se bem sucedido ou false em falha
		public function hitTestSimple( subject:Personagem ):Boolean
		{
			
		}
		
		
		
		public function damage( subject:Personagem, object:Personagem ):Boolean
		{
			
		}
		
	}
	
}
