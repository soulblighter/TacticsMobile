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
	import julio.tactics.regras.GURPS.enuns.EMove;
	import julio.tactics.regras.GURPS.enuns.EAcao;
	
	/**
	 * Classe de ação de ataque customizável
	 * @author Júlio Cézar
	 */
	public class Ataque extends Acao
	{
		private var subject:Personagem;				// quem executa a ação
		private var objects:Array;					// lista de alvos
		
		public var baseNH:int = 9;					// NH da pericia
		
		public var bonusAcerto:int = 0;				// Bonus na jogada de acerto
		public var bonusAparar:int = 0;				// Bonus na jogada de Aparar
		public var bonusBloquear:int = 0;			// Bonus na jogada de Bloquear
		public var bonusEsquivar:int = 0;			// Bonus na jogada de Esquivar
		
		public var podeAparar:Boolean = false;		// Marca se eh possivel aparar a ação
		public var podeBloquear:Boolean = false;	// Marca se eh possivel bloquear a ação
		public var podeEsquivar:Boolean = false;	// Marca se eh possivel esquivar a ação
		public var dano:Dados = new Dados;			// Quantidade de dano que o ataque dah
		public var tipoDano:EDano = EDano.NONELEMENTAL;	// tipo do dano (ex.: EDano.HEAL para skils de cura)
		
		public function Ataque( /*id:String,*/ nome:String, tipoAcao:EAcaoTipo, classe:EAcao, magico:Boolean, alcance:uint = 1, area:uint = 1 )
		{
			super(/*id,*/ nome, tipoAcao, classe, magico, alcance, area, MoveType.FLOAT, MoveType.FLOAT);
		}
		
		
		// TODO: Deifinições de area de acerto
		
		
		// subject -> o personagem q faz a ação
		// objects -> alvo o alvos da ação (pode ser nulo se a ação eh pessoal i.e. soh afeta o proprio usuário
		// return -> alvos atingidos na ação
		public function testarAcerto( subject:Personagem, objects:Array ):Array
		{
			var atingidos:Array = [];
			
			// acerto
			var dados:Dados = new Dados( 3 );
			var rollAcerto:int = dados.roll;
			var acertoPersonagem:int = subject.acerto + this.bonusAcerto;
			var margemAcerto:int = acertoPersonagem - rollAcerto;
			
			trace("AtaqueGDP:");
			trace("\t"+subject+" : NH ["+rollAcerto+"/"+acertoPersonagem+"]");
			
			// margem de acerto fulminante
			var margemFulminante:int = 4;	// 3 e 4 sempre sao fuliminanes
			if ( acertoPersonagem == 15 ) // 5 eh fulminante se o NH for 15
				margemFulminante = 5;
			if ( acertoPersonagem >= 16 ) // 6 eh fulminante se o NH for 16+
				margemFulminante = 6;
			
			// margem de erro critico
			var margemCritico:int = 18;
			if ( acertoPersonagem < 16 ) // 17 eh erro critico se o NH for menor q 16
				margemCritico = 17;
			if ( acertoPersonagem + 10 <= 16 ) // qualquer resultado 10 pontos acima q o NH eh um erro critico
				margemCritico = acertoPersonagem + 10;
			
			if ( rollAcerto >= margemCritico )
			{
				// falha crítica
				trace("\tFalha crítica!");
			} else
			if ( rollAcerto <= margemFulminante )
			{
				// acerto fulminante
				trace("\tAcerto fulminante!");
				// ignora defesas
			} else
			if ( (rollAcerto > acertoPersonagem) || (rollAcerto == 17) ) // 17 não eh erro critico mas eh erro normal se o NH for 16+
			{
				// erro comum
				trace("\tErrou!");
			} else
			if ( rollAcerto <= acertoPersonagem )
			{
				// acerto comum
				trace("\tAcertou");
				
				for each( var obj:Personagem in objects )
				{
					// escolha a defesa ativa que vai ser utilizada ( a maior sempre eh utilizada, somente se estiver disponivel )
					var bTemp:int = obj.bloquear *	 (((obj.numBloqueiosDisponiveis == 0)&&	 this.podeAparar)?	 0 : 1);
					var aTemp:int = obj.aparar *	 (((obj.numApararDisponiveis == 0) &&	 this.podeAparar)?	 0 : 1);
					var eTemp:int = obj.esquivar *	 (((obj.numEsquivasDisponiveis == 0) &&	 this.bonusEsquivar)? 0 : 1);
					
					// Tenta Bloqueio se tiver bloqueios restantes e o bloquei for a maior defesa disponivel
					if ( (bTemp > aTemp) && (bTemp > eTemp) && (obj.numBloqueiosDisponiveis > 0) )
					{
						var rollBloqueio:int = dados.roll;
						var bloqueioObjeto:int = obj.bloquear;
						
						// se conseguio bloquear ( aplica margem de acerto como redutor
						if ( (rollBloqueio + margemAcerto) <= bloqueioObjeto + this.bonusBloquear )
						{
							obj.usaBloquear();
							trace("\t\tConseguio Bloquear: ", obj+" : NH ["+rollBloqueio+"/"+bloqueioObjeto+"-"+margemAcerto+"]");
							// fim da ação
							continue;
						}
						obj.usaBloquear();
						trace("\t\tNao conseguio Bloquear: ", obj+" : NH ["+rollBloqueio+"/"+bloqueioObjeto+"-"+margemAcerto+"]");
						// TODO: Acerto fulminante e erro critico no bloquear
					} else
					
					// Tenta Aparar
					if ( (aTemp > bTemp) && (aTemp > eTemp) && (obj.numApararDisponiveis > 0) )
					{
						var rollAparar:int = dados.roll;
						var apararObjeto:int = obj.aparar;
						
						// se conseguio aparar
						if ( (rollAparar + margemAcerto) <= apararObjeto + this.bonusAparar )
						{
							obj.usaAparar();
							trace("\t\tConseguio Aparar: ", obj+" : NH ["+rollAparar+"/"+apararObjeto+"-"+margemAcerto+"]");
							// fim da ação
							continue;
						}
						trace("\t\tNao conseguio Aparar: ", obj+" : NH ["+rollAparar+"/"+apararObjeto+"-"+margemAcerto+"]");
						obj.usaAparar();
						// TODO: Acerto fulminante e erro critico no Aparar
					} else
					
					// Tenta Esquivar
					if ( obj.numEsquivasDisponiveis > 0 )
					{
						var rollEsquivar:int = dados.roll;
						var esquivarObjeto:int = obj.esquivar;
						
						// se conseguio esquivar
						if ( (rollEsquivar + margemAcerto) <= esquivarObjeto + this.bonusEsquivar )
						{
							obj.usaEsquivar();
							trace("\t\tConseguio Esquivar: ", obj+" : NH ["+rollEsquivar+"/"+esquivarObjeto+"-"+margemAcerto+"]");
							// fim da ação
							continue;
						}
						trace("\t\tNao conseguio Esquivar: ", obj+" : NH ["+rollEsquivar+"/"+esquivarObjeto+"-"+margemAcerto+"]");
						obj.usaEsquivar();
						// TODO: Acerto fulminante e erro critico no Esquivar
					}
					atingidos.push(obj);
					
				}
			}
			
			return atingidos;
		}
		
		public function execute( subject:Personagem, objects:Array ):void
		{
			var atingidos:Array = testarAcerto( subject, objects );
			
			for each( var obj:Personagem in atingidos )
			{
				// Não conseguiu defender, entao leva o dano/effeito da ação
				var rollDano:int = this.dano.roll;
				if ( rollDano < 0 ) rollDano = 0;	// dano n pode ser negativo
				
				var danoTotal:Number = obj.levaDano( new Dano( rollDano, tipoDano ) );
				trace("\t"+obj+" Levou: ", danoTotal + " de dano "+tipoDano.name);
			}
			
		}
		
		
//		public override function execute( table:Object, skillTable:Object ):void
//		{
			// pega alcance da arma
			// pega 1 alvo dentro do alcance
			// pega o acerto do atacante
			// joga o NH da arma do atacante+bonus e pega margem de acerto
			//	-> se errou (margem de acerto < 0)
			//		*atacante errou o alvo* fim da ação
			//	-> se acertou (margem de acerto >= 0)
			//		pega as defesas disponiveis do alvo
			//		-> para cada defesa do alvo (i.e. Bloquear, Aparar, Esquiva, Translocação, etc. [ordem de prioridades a definir])
			//			diminui o numero de utilizações dessa defesa (caso nao sejam ilimitadas)
			//			joga defesa menos margem de acerto
			//			-> se acertou (margem defesa >= 0)
			//				*alvo evitou ataque* fim da ação
			//		*as defesas disponiveis acabaram -> atacante acertou o alvo*
			//		pega dano do atacante
			//		alvo sofre o dano
			//		fim da ação
			
//			trace("executing bal atack...\nsubj: ", table["subj"]);
//			_table = table;
			
//			GlobalDispatcher.addEventListener( BattleEvent.RETURN, executeP2, false, 0, false );
			
//			var be:DisplayEvent = new DisplayEvent( DisplayEvent.SELECT );
//			be.data = <select result="obje" x={table["subj"].x} z={table["subj"].z} type="enemy" alcance="1" text="Selecione inimigo a ser atingido"/>;
//			GlobalDispatcher.dispatchEvent( be );
//		}
		
	}
}
