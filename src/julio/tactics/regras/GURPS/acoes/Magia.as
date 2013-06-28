package julio.tactics.regras.GURPS.acoes
{
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class Magia extends Acao
	{
		public static const MAGIA_COMUM:String = "Comum";
		public static const MAGIA_AREA:String = "Área";
		public static const MAGIA_INFORMACAO:String = "Informação";
		public static const MAGIA_ESPECIAL:String = "Especial";
		public static const MAGIA_ENCANTAMENTO:String = "Encantamento";
		public static const MAGIA_PROJETIL:String = "Projétil";
		public static const MAGIA_BLOQUEIO:String = "Bloqueio";
		
		// modificador de longa distancia basico utilizado por algumas magias, algumas tem o modificador próprio
		private var modificadoresLongaDistancia:Array =
		[
			{max:100, red:0},
			{max:800, red:-1},
			{max:1500, red:-2},
			{max:5000, red:-3},
			{max:15000, red:-4},
			{max:80000, red:-5},
			{max:150000, red:-6},
			{max:500000, red:-7},
			{max:1500000, red:-8}
		];
		private var modificadoresLongaExtra:Object = { max:1500000, red:-1};
		
		
		private var _tags:Array;				// array de strings dos consts acima
		
		private var _textoDescricao:String;
		private var _textoCusto:String;
		private var _textoTempoOperacao:String;
		private var _textoObjeto:String;
		
		private var _tr:int = 0;				// tiro rapido
		private var _prec:int = 0;				// precisao
		private var _halfDamage:int = 0;		// distacia q o dano diminui pela metade
		private var _distanciaMax:int = 0;		// distacia maxima q o projeti alcança (+modificador de altura)
		
		private var _danoBasico:Dados;
		
		private var _duracao:Date;				// 1 segundo eh igual a 1 turno, 1 hora eh uma batalha, 1 dia eh um dia
		private var _contraMagica:Array;		// array de objects com id e nome ex.: {id:"67" nome:"Medo"}
		private var _resistivel:Array;			// array de objects com nome do atributo e redutor ex.: {id:"IQ", red:"-1"}
		
		private var _custoBasico:int;			// custo minimo para soltar a magia
		private var _custoDanoExtra:int;		// esse valor eh multiplicado pela potencia e somado ao custo basico para calcular o custo total da magia
		private var _potenciaDanoMax:int;		// quantas vezes o poder da magia pode ser almentado multiplicando pelo seu custo
		private var _tempoOperacaoBasico:int;	// tempo de operação basico a ser multiplicado pela potencia
		
		private var _sutentarMax:int;			// numero de vezes q a magia pode ser sustentada seguidamente (-1 seginifica inifinitamente, zero siginifica q nao pode ser sustentada)
		private var _sustentarAcao:EAcao;		// ação gasta para manter a ação
		private var _sutentarDuracao:Date;		// tempo q dura para a ação sustentada acabar novamente
		private var _sutentarResistivel:Array;	// tests de ressistencia dos alvo em q a magia vai ser mantida
		private var _sutentarCustoFixo:int;		// custo para manter, sempre eh fixo
		
		private var _tempoOperacao:Date;		// 1 segundo eh igual a 1 turno, 1 hora eh uma batalha, 1 dia eh um dia
		private var _requisitos:Array;			// array de objects com tipo, id e nome ex.: {tipo:"magia", id:"67", nome:"Medo"}
		
		// exemplos
		/*
			<magia id="56" regra="GURPS" nome="Bola de fogo" tipo="projetil" acao="padrao">
				<texto>
					<descricao>Permite ao operador atirar uma bola de fogo com a mão. Quando atinge alguma coisa, ela desaparece numa lufada de chamas que pode incendiar material inflamável. Seus dados são TR 13, prec. +1, ½D 25, Max 50.</descricao>
					<custo>Qualquer um entre 1 e 3; a bola de fogo provocará 1D de dano para cada ponto de energia gasto.</custo>
					<tempoOperacao>1 a 3 segundos.</tempoOperacao>
					<objeto>Cajado ou vara de condão (a chama é lançada a partir da extremidade do objeto). Custo em energia: 800. Deve incluir um rubi no valor de $ 400. Só pode ser usado por um mago.</objeto>
				</texto>
				<tipo>projetil</tipo>
				<tr>13</tr>
				<prec>+1</prec>
				<halfDamage>25</halfDamage>
				<distanciaMax>50</distanciaMax>
				<potenciaMax>3</potenciaMax>
				<custoBasico>1</custoBasico>
				<danoBasico dados="d6">1</danoBasico>
				<tempoOperacao><segundos>1</segundos></tempoOperacao>
				<pre-requisitos>
					<vantagem id="32" nivel="1">Aptidão Mágica</vantagem>	// 32 eh o id da vantagem
					<magia id="27">Criar Fogo</magia>						// 27 eh o id da magia
					<magia id="28">Moldar Fogo</magia>						// 28 eh o id da magia
				</pre-requisitos>
				
				<exectionOrder>
					<select target="block"/>					// apartir do usuario tem alcance 4, afeta 2 blocks de area, ou seja: 5 blocks no total, pode ser usado em um tile vazio do mapa
					<annimation subj="self" type="magic"/>
					<fx id="15" subj="self" obje="target"/>		// exibe animação numero 15 a partir dos conjurador ateh o alvo
					<resolve>
						<hit>
							<annimation subj="target" type="hit"/>
						<hit>
					</resolve>
					
				</exectionOrder>
			</magia>;
			
			<magia id="86" regra="GURPS" nome="Bravura" tipo="area" acao="padrao">
				<texto>
					<descricao>Torna o(s) objetivo(s) destemido(s). Qualquer personagem sob o efeito desta mágica deverá fazer um teste de IQ para evitar a bravura quando a situação exigir cautela.</descricao>
					<duracao>Uma hora, a menos que seja contraposta pela mágica Medo.</duracao>
					<custo>2; não pode ser mantida.</custo>
				</texto>
				<tipo>area</tipo>
				<duracao><horas>1</horas></duracao>
				<contraMagica id="67">Medo</contraMagica>
				<resistivel><IQ>-1</IQ></resistivel>
				<custoBasico>2</custoBasico>
				<sustentar acao="livre">
					<duracao><horas>1</horas></duracao>
					<resistivel><IQ>-1</IQ></resistivel>
					<custo tipo="fadiga" fixo="1">
				</sustentar>
				<tempoOperacao><segundos>1</segundos></tempoOperacao>
				<pre-requisitos>
					<magia id="67">Medo</magia>
				</pre-requisitos>
				
				<exectionOrder>
					<select target="block"/>					// alcance e area sao calculados na hora da execução da magia, baseados nos atributos do personagem
					<annimation subj="self" type="magic"/>
					<fx id="94" obje="target"/>					// exibe animação numero 94 na alvo
				</exectionOrder>
			</magia>;
		*/
		public function Magia( id:String, nome:String, tipo:EAcao )
		{
			super(id, nome, tipo);
			
			modificadoresLongaDistancia =
			[
				{max:100, red:0},
				{max:800, red:-1},
				{max:1500, red:-2},
				{max:5000, red:-3},
				{max:15000, red:-4},
				{max:80000, red:-5},
				{max:150000, red:-6},
				{max:500000, red:-7},
				{max:1500000, red:-8}
			];
			
			modificadoresLongaExtra = { max:1500000, red: -1 };
			
			_tags = [Magia.MAGIA_COMUM];
			
			_textoDescricao = "Sem descrição.";
			_textoCusto = "Sem texto custo.";
			_textoTempoOperacao = "Sem texto tempo de operação.";
			_textoObjeto = "Sem texto objeto.";
			
			_tr = 0;
			_prec = 0;
			_halfDamage = 0;
			_distanciaMax = 0;
			
			_danoBasico = new Dados;
			
			_duracao = new Date(0, 0, 0, 0, 0, 1, 0);
			_contraMagica = [];		// nenhuma contramagica especifica
			_resistivel = [];		// nao pode ser ressistido
			
			_custoBasico = 0;
			_custoDanoExtra = 0;
			_potenciaDanoMax = 1;
			_tempoOperacaoBasico = 1;
			
			_sutentarMax = 0;
			_sustentarAcao = EAcao.STD_MAGIC;
			_sutentarDuracao =  new Date(0, 0, 0, 0, 0, 1, 0);
			_sutentarResistivel = [];
			_sutentarCustoFixo = 0;
			
			_tempoOperacao = new Date(0, 0, 0, 0, 0, 1, 0);
			_requisitos = [];		// sem pre-requisitos
			
		}
		
		// exemplos de execução
		//
		// variaveis...
		// actionID					-> guarda a ação escolhida atualmente (readOnly)
		// subj:Object				-> guarda o personagem q esta agindo (readOnly)
		// subj.dir:String			-> guarda a direcao de quem estah agindo
		// subjPos:Number2D			-> eh a posição no mapa do subj antes de executar a ação
		// obje:Array				-> eh um array vazio, mas todos q forem afetados pela ação deve ser colocados aki
		// obje[...].dir:String		-> guarda a direção de cada alvo
		// targetPos:Number2D		-> eh a posição no mapa que foi escolhido para realizar a ação
		// dirSubj2Target:String	-> qual direção o subj deve virar pra ficar olhando para o targetPos
		// dirTarget2Subj:String	-> qual direção q alguem no targetPos deve virar pra ficar olhando para o subj
		// (o obje pode ter o mesmo valor de subj, no caso em o usuario seleciona o proprio personagem, executor da ação, como alvo)
		//
		// tags... (com * sao atributos opcionais)
		// select ->	pede para o usuário selecionar um tile no mapa, respeitando a alcance max, se o tile tem inimigo/aliado ou esta vazio
		//				resolve somente depois do usuario selecionar um tile valido
		//		result:* -> onde o resultado vai ser guardado
		//		type:String -> se o alvo valido eh um aliado, inimigo, aliado/inimigo ou tile vazio
		// 			tipos de target
		// 			enemy = inimigos, nao pode ser utilizado em aliados ou espaços vazios, somente inimigos!
		// 			ally = aliados, nao pode ser utilizado em inimigos ou espaços vazios, somente aliados!
		// 			any = qualquer alvo, pode ser aliado ou inimigos soh nao pode ser utilizado em espaços vazios
		// 			block = qualquer lugar, pode ser aliado ou inimigos, inclusive pode ser utilizado em espaços vazios
		// 			desoccupied = qualquer espaço q naum esteja ocupado por outros inimigos/aliados ou objetos do cenario...
		//		aclcance:int -> tiles  a partir do subj q podem ser selecionados
		//		*texto:String -> texto de ajuda q vai ser exibido
		//
		// addchar ->	cria um novo personagem
		//		id:String -> id do char
		//		module:String -> nome do módulo que possui as animações do personagem
		//		position:String -> id da posição no grafo
		//		*direction:String -> direção q o personagem deve aparecer
		//		*animatiin:String -> animação inicial do personagem
		//		*stoped:Boolean -> se a animação deve correr ou ficar parada
		//		*visible:Boolean -> se o personagem deve aparacer visivel ou nao
		//
		// visible ->	muda a propriedade visible do displaiObject
		//		target:[Personagem] -> quem vai ter sua animação mudada (nao pode se direcionada a um block vazio)
		//		value:Boolean -> se false o personagem fica invisivel
		//
		//
		// animation ->	muda a animação de um personagem, ou varios
		//		target:[Personagem] -> quem vai ter sua animação mudada
		//		value:String -> nome da animação
		//		*loop:Boolean -> caso true a animação "loopa", soh pode ser utilizado em conjunção com o atributo time
		//		*time:Number -> tempo de execução da animação (caso esse valor nao seja definido entao executa ateh o fim da animação)
		//
		// fx -> 		executa um efeito especial (ainda nao implementado, soh conceito)
		//		id:String -> identificação unica do efeito
		//		target:[Personagem] ou String -> posição onde o efeito vai ser exibido (no caso de efeito q afetam area), ou alvo do efeito (no caso de efeitos q afetam personagens)
		//
		// parallel ->	executa todos dentro do tag em paralelo
		//		waitAll:Boolean -> se true soh continua a execução quando todas as tags internas terminarem, se false quando qualquer um das tags internas acabar, continua a execução
		//		as tags [select, talk(sem time), ] nao sao permitidas dento do tag parallel
		//
		// changeDir ->	Muda a direção de um ao mais alvos
		//		target:[Personagem] -> quem vai ter sua direção alterada
		//		value:String -> nova direção ("se", "sw", "ne", "nw")
		//
		// move ->		faz um personagem andar
		//		target:Personagem -> quem vai ter sua posição alterada (nao pode ser varios)
		//		value:String -> nova posição
		//
		// teleport ->	muda a posição de um personagem
		//		target:Personagem -> quem vai ter sua posição alterada
		//		value:String -> nova posição (id do nó do grafo)
		//
		// talk ->		faz um personagem falar
		//		target:Personagem -> quem vai falar
		//		value:String -> texto a ser exibido
		//		*time:Number -> tempo de exibição do texto (quando o tempo acabar o texto some automaticamente e a execução continua, caso contrario somente quando o usuário clicar no botao pra continuar)
		//
		// camera ->	altera a posição da camera
		//		*target -> personagem ou posição q a camera deve focalizar
		//		*rotate -> rotação da camera em radianos
		//		time -> tempo para mover/rotacionar a camera
		//
		// instruções q sao processadas internamente e não sao passadas para cenaBatalha ou seja nao sao renderizadas
		//
		// random ->	as tag dentro seram executadas dependendo de uma chance
		//		value -> chance das tags internas serem executadas
		//
		// roll ->		joga um teste de dados
		//		dice:String -> tipo de dado (d2, d3, d4, d6, d8, d10, d12, d20, d% ou d100)
		//		number:Number -> numero de dados
		//		result:Number -> nome da variavel para armazenar o resultado
		// <roll dice="d6" number="3" result="acerto"/>	// jogar 3d6 e armazena resultado em "acerto"
		//
		// if ->		somente executa as tags internas se "value1 [type] value2" for verdadeiro
		//		type:String -> tipo de operação de teste (>, >=, <, <=, ==, !=)
		//		value1:Number -> nome da variavel onde contem o numero a ser comparado
		//		value2:Number -> nome da variavel onde contem o segundo numero a ser comparado
		// <if type=">" value1="acerto" value2="esquiva"/>
		//
		// end ->		termina a execução da acao (nao necessário colocar essa tag no final do script)
		// <end/>
		//
		// var ->		cria nova variavel se nao existir ou muda valor de uma jah existente
		// <var name="obje" value="subj"/>
		//
		//
		//
		//
		//
		//
		//
		// araque normal
		//	<action id="11" name="BAL">		// golpe de corte com a espada
		//		<execucao>
		//			<select result="obje" type="enemy" alcance="1" text="Selecione inimigo a ser atingido"/>	// espera o usuario selecionar um inimigo e poe na variavel obje
		//			<changeDir target="subj" value="dirSubj2Target"/>	// muda a direção do subj para o alvo
		//			<resolve>		// pega o resultado da ação
		//				<hit>
		//					<parallel waitAll="true">							// todas a ações q estao aki dentro devem ser executadas ao mesmo tempo
		//						<annimation target="subj" value="attack"/>		// muda a animação do atacante para "attack"
		//						<annimation target="obje" value="hit"/>			// muda a animação do defensor para hit
		//					</parallel>
		//				</hit>
		//				<miss>
		//					<changeDir target="obje" value="dirTarget2Subj"/>	// muda a direção do alvo para o subj
		//					<parallel waitAll="true">							// todas a ações q estao aki dentro devem ser executadas ao mesmo tempo
		//						<annimation target="subj" value="attack"/>		// muda a animação do atacante para "attack"
		//						<fx target="obje" id="12"/>						// faz o efeito do personagem esquivando
		//					</parallel>
		//				</miss>
		//			</resolve>
		//		</execucao>		// fim da execução -> restaura as animações normais
		//	</action>
		//
		// explicando a execução do ataque normal
		// primeiro eh perguntado para o usuário selecionar um inimigo no alcace do ataque, no caso 1.
		// quando o alvo eh selecionado entao o ataque eh resolvido
		// 		se acertou entao começa a execução em paralelo de duas animações ao mesmo tempo
		// 		quando as duas animações terminarem a execução acaba
		// 		se errou entao começa a execução em paralelo da animação do personagem atacando e de efeito do alvo esquivando
		// 		quando as duas animações terminarem a execução acaba
		//
		//	<action id="31" name="Primeiros Socorros">	// pericia para se curar na batalha
		//		<execucao>	// como nao tem nenhuma tah select executa imediatamente sem perguntar pra selecionar nada
		//			<fx id="94" target="subj"/>					// exibe animação numero 94 np usuario da acao
		//		</execucao>
		//	</action>
		//
		// explicando a execução do Primeiros Socorros
		// Não eh feita nenhuma pergunta ao usuario para selecionar o alvo, nem a animação do personagem muda
		// eh executado o efeito numero 94 no usuário (subj)
		// no final da execução do efeito, a execução acaba
		//
		//	<action id="31" name="Cura superficial">	// cura leve em um alvo
		//		<execucao>
		//			<select result="obje" target="any" alcance="2"/>	// apartir do usuario tem alcance 1, somente afeta um aliado ou inimigo a 1 block
		//			<annimation target="subj" type="magic"/>
		//			<fx id="94" target="obje"/>					// exibe animação numero 94 no alvo da acao
		//		</execucao>
		//	</action>
		//
		// explicando a execução do Cura superficial
		// primeiro eh perguntado para o usuário selecionar um inimigo no alcace da magia, no caso 2.
		// a animação do subj muda para magic
		// no fim da execucaçõ da animação eh executado o efeito numero 94 no alvo (obje)
		// no final da execução do efeito, a execução acaba
		//
		//	<action id="31" name="Teleporte">	// teleporta a um tile nao ocupado
		//		<execucao>
		//			<select result="targetPos" target="desoccupied" alcance="10"/>	// apartir do usuario tem alcance 10, nao pode ser escolhido um lugar ocupado por outros personagens/objetos, a posição do tile selecionado eh colocado na variavel targetPos
		//			<annimation target="subj" type="magic"/>
		//			<fx id="12" target="subjPos"/>					// exibe animação numero 12 na posição atual do
		//			<annimation subj="self" type="magic"/>
		//		</execucao>
		//	</action>
		//
		// explicando a execução do Cura superficial
		// primeiro eh perguntado para o usuário selecionar um inimigo no alcace da magia, no caso 2.
		// a animação do subj muda para magic
		// no fim da execucaçõ da animação eh executado o efeito numero 94 no alvo (obje)
		// no final da execução do efeito, a execução acaba
		//

		
//		public override function toXML():XML
//		{
//			return <magia/>;
//		}
		
//		public override function fromXML( xml:XML ):void
//		{
//
//		}
	}
}
