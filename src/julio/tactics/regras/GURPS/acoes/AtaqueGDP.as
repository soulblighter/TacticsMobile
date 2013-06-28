package julio.tactics.regras.GURPS.acoes
{
	import julio.tactics.regras.GURPS.acoes.*;
	import julio.tactics.regras.GURPS.Dano;
	import julio.tactics.regras.GURPS.Dados;
	import julio.tactics.regras.GURPS.enuns.EAcaoTipo;
	import julio.tactics.regras.GURPS.enuns.EAcaoAlcance;
	import julio.tactics.regras.GURPS.Personagem;
	import julio.tactics.regras.GURPS.enuns.EDano;
	import julio.tactics.regras.GURPS.enuns.EAcao;
	import julio.tactics.regras.GURPS.MoveType;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AtaqueGDP extends Ataque
	{
		
		public function AtaqueGDP(/*id:String*/)
		{
			super(/*id,*/ "Ataque GDP", EAcaoTipo.STD, EAcao.MELEE, false, 1, 0);
		}
		
		
		public override function execute( subject:Personagem, objects:Array ):void
		{
			this.podeAparar = true;
			this.podeBloquear = true;
			this.podeEsquivar = true;
			this.baseNH = subject.acerto;
			this.tipoDano = EDano.GDP;
			this.dano = subject.danoGDP;
			
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
		
		
/*
		// subject -> o personagem q faz a ação
		// objects -> alvo o alvos da ação (pode ser nulo se a ação eh pessoal i.e. soh afeta o proprio usuário
		public override function execute( subject:Personagem, objects:Array ):void
		{
			// acerto
			var dados:Dados = new Dados( 3 );
			var rollAcerto:int = dados.roll;
			var acertoPersonagem:int = subject.acerto;
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
				// return
			}
			if ( rollAcerto <= margemFulminante )
			{
				// acerto fulminante
				trace("\tAcerto fulminante!");
				// ignora defesas
				// return
			}
			if ( (rollAcerto > acertoPersonagem) || (rollAcerto == 17) ) // 17 não eh erro critico mas eh erro normal se o NH for 16+
			{
				// erro comum
				trace("\tErrou!");
			}
			
			if ( rollAcerto <= acertoPersonagem )
			{
				// acerto comum
				trace("\tAcertou");
				
				for each( var obj:Personagem in objects )
				{
					// escolha a defesa ativa que vai ser utilizada na defesa ( a maior sempre eh utilizada )
					var bTemp:int = obj.bloquear * (obj.numBloqueiosDisponiveis == 0? 0 : 1);
					var aTemp:int = obj.aparar * (obj.numApararDisponiveis == 0? 0 : 1);
					var eTemp:int = obj.esquivar * (obj.numEsquivasDisponiveis == 0? 0 : 1);
					
					// Tenta Bloqueio se tiver bloqueios restantes e o bloquei for a maior defesa disponivel
					if ( (bTemp > aTemp) && (bTemp > eTemp) && (obj.numBloqueiosDisponiveis > 0) )
					{
						var rollBloqueio:int = dados.roll;
						var bloqueioObjeto:int = obj.bloquear;
						
						// se conseguio bloquear ( aplica margem de acerto como redutor
						if ( (rollBloqueio + margemAcerto) <= bloqueioObjeto )
						{
							obj.usaBloquear();
							trace("\t\tConseguio Bloquear: ", obj+" : NH ["+rollBloqueio+"/"+bloqueioObjeto+"-"+margemAcerto+"]");
							// fim da ação
							return;
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
						if ( (rollAparar + margemAcerto) <= apararObjeto )
						{
							obj.usaAparar();
							trace("\t\tConseguio Aparar: ", obj+" : NH ["+rollAparar+"/"+apararObjeto+"-"+margemAcerto+"]");
							// fim da ação
							return;
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
						if ( (rollEsquivar + margemAcerto) <= esquivarObjeto )
						{
							obj.usaEsquivar();
							trace("\t\tConseguio Esquivar: ", obj+" : NH ["+rollEsquivar+"/"+esquivarObjeto+"-"+margemAcerto+"]");
							// fim da ação
							return;
						}
						trace("\t\tNao conseguio Esquivar: ", obj+" : NH ["+rollEsquivar+"/"+esquivarObjeto+"-"+margemAcerto+"]");
						obj.usaEsquivar();
						// TODO: Acerto fulminante e erro critico no Esquivar
					}
					
					// Não conseguiu defender, entao leva o dano/effeito da ação
					var rollDano:int = subject.danoGDP.roll;
					if ( rollDano < 0 ) rollDano = 0;	// dano n pode ser negativo
					
					var danoTotal:Number = obj.levaDano( new Dano( rollDano, EDano.GDP ) );
					trace("\t"+obj+" Levou: ", danoTotal + " de dano "+EDano.GDP.name);
				}
			}
		}
		*/
	}
}
