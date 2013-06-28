package julio.tactics.regras
{
	import away3d.blockers.ConvexBlock;
	import julio.tactics.regras.GURPS.acoes.AtaqueGDP;
	import julio.tactics.regras.GURPS.batalha.ArcData;
	import julio.tactics.regras.GURPS.batalha.Batalha;
	import julio.tactics.regras.GURPS.batalha.Grafo2;
	import julio.tactics.regras.GURPS.batalha.Grafo3;
	import julio.tactics.regras.GURPS.batalha.GrafoSimples;
	import julio.tactics.regras.GURPS.batalha.ObjetoAtivo;
	import julio.tactics.regras.GURPS.batalha.SimpleBattle;
	import julio.tactics.regras.GURPS.Arma;
	import julio.tactics.regras.GURPS.acoes.Ataque;
	import julio.tactics.regras.GURPS.batalha.TileData;
	import julio.tactics.regras.GURPS.Dados;
	import julio.tactics.regras.GURPS.Pericia;
	import julio.tactics.regras.GURPS.Pericias.*;
	import julio.tactics.regras.GURPS.*;
	import julio.tactics.regras.GURPS.Personagens.*;
	import julio.tactics.regras.GURPS.enuns.*;
	import mx.effects.Move;
	import flash.utils.getTimer;
	
	/**
	 * Testa toda as regras da batalha em modo linha de texto
	 * assim, certificando q o modulo das regras eh modularizado
	 * e independente da interface gráfica
	 * além de testar seu correto funcionamento
	 * @author Julio Cézar
	 */
	public class BattleTester
	{
		private var skillTable:Object = new Object;
		private var actionTable:Object = new Object;
		private var itemTable:Object = new Object;
		
		// ultiliza "trace()" para mostrar informações ao usuário
		public function BattleTester()
		{
//			actionTable["1"] = new Ataque("1", "BAL", EAcaoTipo.STD, EAcaoAlcance.MELEE, false, 1);
			actionTable["2"] = new  AtaqueGDP("2");
			
			skillTable[EPericia.LIGHT_SWORD] = new PericiaCombate( 	EPericia.LIGHT_SWORD, "Espadas Curtas (Física/Média)", "Esta é a perícia no uso de qualquer tipo de arma balanceada com 30 a 60 cm de comprimento, incluindo o terçado, o gládio e o bastão.",
													-5, EAtributo.DX, -2, 8, 0.0, 0.5, 1, 2, 1 );
			skillTable[EPericia.BRIGA] = new PericiaCombate( 	EPericia.BRIGA, "Briga (Física/Fácil)", "Esta é a perícia, nada científica, de sair-no-tapa num combate de perto. Faça um teste de Briga sempre que atacar o adversário com as mãos ou pés para ver se consegue atingi-lo. Some 1/10 de seu NH em Briga (arredondado para baixo) ao dano provocado. É possível aparar duas vezes por turno (um para cada mão) quando você se defende com as mãos limpas, e seu parâmetro Aparar será igual a 2/3 de seu NH em Briga. Com esta perícia só é possível aparar ataques de mãos, pés e armas usadas em combate de perto.",
													-5, EAtributo.DX, -1, 8, 1.0/10.0, 2.0/3.0, 2, 2, 2, true );
			skillTable[EPericia.ESCUDO] = new PericiaEscudo( 	EPericia.ESCUDO, "Escudo (Física/Fácil)", "Esta é a perícia no uso de um escudo do tipo medieval ou daqueles usados pelas tropas de choque. Esta perícia é necessária para atacar com o Escudo. No entanto a defesa passiva oferecida pelo escudo (1 a 4 pontos) protege quem o carrega, mesmo que ele não saiba como usá-lo. A defesa ativa de um escudo (no Bloqueio) é 1/2 de seu NH com o Escudo. Logo, você será capaz de bloquear muito melhor se tiver estudado a perícia do que se usar seu nível pré-definido. O atributo DX de uma pessoa média é 10, ou seja o nível prédefinido de sua habilidade com o Escudo é 6 e seu Bloqueio será 3.",
													-4, EAtributo.DX, -1, 8, 0, 0, 1/2, 1, 2 );
			
			itemTable["1"] = new  Arma( 1, "Gládio", 400, 1, EPericia.LIGHT_SWORD, new Dados(0,1), new Dados(0,1), null, null, 0, 7, 1.0/6.0 );
			itemTable["2"] = new  Escudo( 2, "Escudo Pequeno", 40, 4, EPericia.ESCUDO, 2, 0, 0, 11 );
			
			var p1:Personagem = new Personagem( "João", 14, 12, 14, 12 );
			var p2:Personagem = new Personagem( "Maria", 10, 18, 10, 10 );
			
			
			
			
			for each( var p:Pericia in skillTable )
			{
//				if ( p is PericiaCombate )
//				{
					p1.pushPericia( p, 0 );
					p2.pushPericia( p, 0 );
//				}
			}
			p1.selectPericiaCombateDesarmado( EPericia.BRIGA );
			p2.selectPericiaCombateDesarmado( EPericia.BRIGA );
			
			p1.addPontosEmPericia(EPericia.LIGHT_SWORD, 1 );
			p1.addPontosEmPericia(EPericia.LIGHT_SWORD, 2 );
			p1.addPontosEmPericia(EPericia.LIGHT_SWORD, 4 );
			p1.addPontosEmPericia(EPericia.ESCUDO, 1 );
			p1.addPontosEmPericia(EPericia.ESCUDO, 2 );
			p1.addPontosEmPericia(EPericia.ESCUDO, 4 );
			p1.addPontosEmPericia(EPericia.ESCUDO, 8 );
			p1.equiparArma( itemTable["1"] );
			p1.equiparEscudo( itemTable["2"] );
			
			p2.addPontosEmPericia(EPericia.BRIGA, 1 );
			p2.addPontosEmPericia(EPericia.BRIGA, 2 );
			p2.addPontosEmPericia(EPericia.BRIGA, 4 );
			p2.addPontosEmPericia(EPericia.BRIGA, 8 );
			p2.addPontosEmPericia(EPericia.BRIGA, 16 );
			
//			var per:Pericia = skillTable[EPericia.BRIGA];
//			trace( "NH2Allpoints: ", per.NH2Allpoints( 2 ) );
//			trace( "NH2points: ", per.NH2points( 1 ) );
//			trace( "points2NextNH: ", per.points2NextNH( 1 ) );
//			trace( "Points2NH: ", per.Points2NH( 1 ) );
			
			p1.restauraDefesasAtivas();
			p1.refresh();
			p2.restauraDefesasAtivas();
			p2.refresh();
//			p1.moveType.setBasic( EMove.FLOAT );
/*
			for ( var i:int = 1; i < 11; i++ )
			{
				trace("Turno ", i, " -----------------------------");
				actionTable["2"].execute( p1, [p2] );
				actionTable["2"].execute( p2, [p1] );
				p1.restauraDefesasAtivas();
				p1.refresh();
				p2.restauraDefesasAtivas();
				p2.refresh();
				if ( p1.isDead() || p2.isDead() ) break;
			}
			
			trace( "Final Joao: ", p1.PV_Atual );
			trace( "Final Maria: ", p2.PV_Atual );
*/
/*			var g:Grafo2 = new Grafo2;
			g.criarMapa( 4, 4 );
			g.inserirVertice(0, 0, 0, new TileData);
			g.inserirVertice(0, 0, 1, new TileData);
			g.inserirObjeto(0, 0, p1);
			g.inserirArco(0, 0, 0, 1);
			trace( g.grau( 0, 0 ) );*/
			
			var g:Grafo3 = new Grafo3;
			var v:Array = new Array;
			v[0]  = g.inserirVertice( new TileData( 0, 0, 0, 1, ETile.PLAIN ) );
			v[1]  = g.inserirVertice( new TileData( 0, 0, 1, 1, ETile.LAVA ) );
			v[2]  = g.inserirVertice( new TileData( 0, 0, 2, 1, ETile.PLAIN ) );
			v[3]  = g.inserirVertice( new TileData( 0, 0, 3, 1, ETile.PLAIN ) );
			v[4]  = g.inserirVertice( new TileData( 0, 0, 4, 1, ETile.PLAIN ) );
			v[5]  = g.inserirVertice( new TileData( 0, 0, 5, 1, ETile.PLAIN ) );
			
			v[6]  = g.inserirVertice( new TileData( 1, 0, 0, 1, ETile.PLAIN ) );
			v[7]  = g.inserirVertice( new TileData( 1, 0, 1, 1, ETile.LAVA ) );
			v[8]  = g.inserirVertice( new TileData( 1, 0, 2, 1, ETile.PLAIN ) );
			v[9]  = g.inserirVertice( new TileData( 1, 0, 3, 1, ETile.PLAIN ) );
			v[10] = g.inserirVertice( new TileData( 1, 0, 4, 1, ETile.PLAIN ) );
			v[11] = g.inserirVertice( new TileData( 1, 0, 5, 1, ETile.PLAIN ) );
			
			v[12] = g.inserirVertice( new TileData( 2, 0, 0, 1, ETile.PLAIN ) );
			v[13] = g.inserirVertice( new TileData( 2, 0, 1, 1, ETile.LAVA ) );
			v[14] = g.inserirVertice( new TileData( 2, 0, 2, 1, ETile.PLAIN ) );
			v[15] = g.inserirVertice( new TileData( 2, 0, 3, 2, ETile.PLAIN ) );
			v[16] = g.inserirVertice( new TileData( 2, 0, 4, 2, ETile.PLAIN ) );
			v[17] = g.inserirVertice( new TileData( 2, 0, 5, 2, ETile.PLAIN ) );
			
			v[18] = g.inserirVertice( new TileData( 3, 0, 0, 1, ETile.PLAIN ) );
			v[19] = g.inserirVertice( new TileData( 3, 0, 1, 1, ETile.LAVA ) );
			v[20] = g.inserirVertice( new TileData( 3, 0, 2, 1, ETile.PLAIN ) );
			v[21] = g.inserirVertice( new TileData( 3, 0, 3, 1, ETile.PLAIN ) );
			v[22] = g.inserirVertice( new TileData( 3, 0, 4, 1, ETile.PLAIN ) );
			v[23] = g.inserirVertice( new TileData( 3, 0, 5, 1, ETile.PLAIN ) );
			
			v[24] = g.inserirVertice( new TileData( 4, 0, 0, 1, ETile.PLAIN ) );
			v[25] = g.inserirVertice( new TileData( 4, 0, 1, 1, ETile.LAVA ) );
			v[26] = g.inserirVertice( new TileData( 4, 0, 2, 1, ETile.PLAIN ) );
			v[27] = g.inserirVertice( new TileData( 4, 0, 3, 1, ETile.LAVA ) );
			v[28] = g.inserirVertice( new TileData( 4, 0, 4, 1, ETile.PLAIN ) );
			v[29] = g.inserirVertice( new TileData( 4, 0, 5, 1, ETile.PLAIN ) );
			
			v[30] = g.inserirVertice( new TileData( 5, 0, 0, 1, ETile.PLAIN ) );
			v[31] = g.inserirVertice( new TileData( 5, 0, 1, 1, ETile.PLAIN ) );
			v[32] = g.inserirVertice( new TileData( 5, 0, 2, 1, ETile.PLAIN ) );
			v[33] = g.inserirVertice( new TileData( 5, 0, 3, 1, ETile.LAVA ) );
			v[34] = g.inserirVertice( new TileData( 5, 0, 4, 1, ETile.PLAIN ) );
			v[35] = g.inserirVertice( new TileData( 5, 0, 5, 1, ETile.PLAIN ) );
			
			// linha 0
			g.inserirArco( v[0], v[1], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[0], v[6], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[1], v[2], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[1], v[7], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[2], v[3], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[2], v[8], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[3], v[4], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[3], v[9], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[4], v[5], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[4], v[10], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[5], v[11], new ArcData( EArc.SIMPLE ) );
			
			// linha 1
			g.inserirArco( v[6], v[7], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[6], v[12], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[7], v[8], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[7], v[13], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[8], v[9], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[8], v[14], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[9], v[10], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[9], v[15], new ArcData( EArc.HJUMP ) );
			
			g.inserirArco( v[10], v[11], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[10], v[16], new ArcData( EArc.HJUMP ) );
			
			g.inserirArco( v[11], v[17], new ArcData( EArc.HJUMP ) );
			
			// linha 2
			g.inserirArco( v[12], v[13], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[12], v[18], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[13], v[14], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[13], v[19], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[14], v[15], new ArcData( EArc.HJUMP ) );
			g.inserirArco( v[14], v[20], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[15], v[16], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[15], v[21], new ArcData( EArc.HJUMP ) );
			
			g.inserirArco( v[16], v[17], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[16], v[22], new ArcData( EArc.HJUMP ) );
			
			g.inserirArco( v[17], v[23], new ArcData( EArc.HJUMP ) );
			
			// linha 3
			g.inserirArco( v[18], v[19], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[18], v[24], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[19], v[20], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[19], v[25], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[20], v[21], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[20], v[26], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[21], v[22], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[21], v[27], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[22], v[23], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[22], v[28], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[23], v[29], new ArcData( EArc.SIMPLE ) );
			
			// linha 4
			g.inserirArco( v[24], v[25], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[24], v[30], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[25], v[26], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[25], v[31], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[26], v[27], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[26], v[32], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[27], v[28], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[27], v[33], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[28], v[29], new ArcData( EArc.SIMPLE ) );
			g.inserirArco( v[28], v[34], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[29], v[35], new ArcData( EArc.SIMPLE ) );
			
			// linha 5
			g.inserirArco( v[30], v[31], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[31], v[32], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[32], v[33], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[33], v[34], new ArcData( EArc.SIMPLE ) );
			
			g.inserirArco( v[34], v[35], new ArcData( EArc.SIMPLE ) );
			
			// extra jumps
			g.inserirArco( v[12], v[14], new ArcData( EArc.DJUMP ) );
			g.inserirArco( v[32], v[34], new ArcData( EArc.DJUMP ) );
			
			var moveProjetil:MoveType = new MoveType( EMove.FLOAT );
			moveProjetil.maxJumpD = 0;
			moveProjetil.maxJumpDown = 0;
			moveProjetil.maxJumpUp = 0;
			
			var bolaDeFogo:ObjetoAtivo = new ObjetoAtivo;
			bolaDeFogo.canBePlayerControlled = false;
			bolaDeFogo.showInit = false;
			bolaDeFogo.baseMoveType = moveProjetil;
			
			
			g.inserirObjeto(v[18], p1);
			g.inserirObjeto(v[29], p2);
//			g.distanciasDijkstra(v0);
			var timerAntes:int;
			timerAntes = getTimer();
			g.caminhosDijkstra(v[0], calculaCusto, podePassar, podeFicar, p1);
			g.alcanceDijkstra( 14, 2, calculaCusto, bolaDeFogo );
			g.search(14, 2, 1, caomparadorAlcance, calculaCusto, bolaDeFogo, false );
			trace( "tempo: ", getTimer() - timerAntes );
			
//			var bat:Batalha = new Batalha(g);
//			bat.pushTeam("PlayerTeam");
//			bat.pushTeam("EnemyTeam");
//			bat.pushObject( p1, "PlayerTeam", 0 );
//			bat.pushObject( p2, "EnemyTeam", 29 );
			
//			bat.updateFila();
			//trace( bat.ordemAcoes );
			
			
		}
		
		public function caomparadorAlcance( id:uint ):Boolean
		{
			return true;
		}
		
		
		// origem: dados do vertice de origem
		// destino: dados do vertice de destino
		// arco: dados da coneção entre os vertices
		// extra: a definir (possivelmente o personagem ou dados do tipo de movimento)
		public function calculaCusto( origem:TileData, destino:TileData, arco:ArcData, extra:ObjetoAtivo ):Number
		{
			var move:MoveType = extra.moveType;
			var custoBase:Number = move.modTerreno[destino.type];
			
			// se for SIMPLE
			if ( arco.type == EArc.SIMPLE )
			{
				// Float n toca o chao, portanto n leva penalidade do terreno
				if ( move.type == EMove.FLOAT )
					return 1.0;
				if ( move.type == EMove.FLOAT_FLY )
					return 1.0;
				if ( move.type == EMove.WARP )
					return 1.0;
				
				// kem n flutua leva penalidade do terreno
				return custoBase;
				
			} else if ( arco.type == EArc.HJUMP )
			{
				
				// se altura for maior que o personagem pode subir/descer
				var alturaOrigem:Number = origem.h - origem.y;
				var alturaDestino:Number = destino.h - destino.y;
				var altura:uint = Math.abs(alturaDestino - alturaOrigem);	// aproximado para inteiro
				
				if ( altura == 0 )		// esse if n deve ser executado EArc.HJUMP deve soh ser utilizado em conexoes com alturas diferentes
					throw new Error("HJUMP com altura igual a \""+altura+"\" em ::calculaCusto(...), valor deve ser maior q zero");
				
				// se for subida
				if ( alturaOrigem < alturaDestino )
				{
					if ( move.maxJumpUp >= altura )
						return custoBase * altura;
					else
						return 999;
				}
				
				// se for descida
				if ( alturaOrigem > alturaDestino )
				{
					if ( move.maxJumpUp >= altura )
						return custoBase * altura;
					else
						return 999;
				}
				
				
			} else if ( arco.type == EArc.DJUMP )
			{
				var distancia:Number =	Math.abs(destino.x - origem.x) +
										Math.abs(destino.z - origem.z);
				
				if ( distancia < 2 )	// esse if n deve ser executado EArc.DJUMP deve soh ser utilizado em conexoes com distancias maior ou igual a 2
					throw new Error("DJUMP com distancia igual a \""+distancia+"\" em ::calculaCusto(...), valor deve ser maior ou igual a 2");
				
				return custoBase * distancia;
			}
			
			return 1.0;
		}
		
		// tile: dados do tile
		// objs: lista de objetos no tile
		// extra: a definir (possivelmente o personagem ou dados do tipo de movimento)
		public function podePassar( tile:TileData, objs:Array, extra:ObjetoAtivo ):Boolean
		{
			var move:MoveType = extra.moveType;
			var result:Boolean = true;
			
			// se for água e o personagem n flutua, voa nem teleporta
			if ( (tile.type == ETile.WATER) && (move.type == EMove.WALK) )
			{
				// verifica se pode nadar ou andar sobre a agua
				result = move.onWater || move.underWater;
			}
			
			// se for lava e o personagem n flutua, voa nem teleporta
			if ( (tile.type == ETile.LAVA) && (move.type == EMove.WALK) )
			{
				// verifica se pode nadar ou andar sobre a agua
				result = move.onLava || move.underLava;
			}
			
			// se nao puder passar pelos tiles retorn logo
			if ( !result ) return result;
			
			// se puder passar entao testa contra os objetos no local
			if ( objs.length == 0 )
			{
				// se o tile estiver vazio entao pode passar
				return true;
			}else {
				// se o tile n estiver vazio tb pode passar.. ( fazer o codigo final depois...)
				return true;
			}
			
			return true;
		}
		
		// tile: dados do tile
		// objs: lista de objetos no tile
		// extra: a definir (possivelmente o personagem ou dados do tipo de movimento)
		public function podeFicar( tile:TileData, objs:Array, extra:ObjetoAtivo ):Boolean
		{
			var move:MoveType = extra.moveType;
			var result:Boolean = true;
			
			// se for água e o personagem n flutua, voa nem teleporta
			if ( tile.type == ETile.WATER )
			{
				// verifica se pode nadar ou andar sobre a agua
				result = move.onWater || move.underWater;
				// ou se flutua
				result = (move.type == EMove.FLOAT) || (move.type == EMove.FLOAT_FLY) || (move.type == EMove.FLOAT_WARP);
			}
			
			// se for lava e o personagem n flutua, voa nem teleporta
			if ( tile.type == ETile.LAVA )
			{
				// verifica se pode nadar ou andar sobre a agua
				result = move.onWater || move.underWater;
				// ou se flutua
				result = (move.type == EMove.FLOAT) || (move.type == EMove.FLOAT_FLY) || (move.type == EMove.FLOAT_WARP);
			}
			
			// se nao puder ficar no tile retorna logo
			if ( !result ) return result;
			
			// se puder ficar entao testa contra os objetos no local
			if ( objs.length == 0 )
			{
				// se o tile estiver vazio entao pode ficar
				return true;
			}else {
				// se o tile n estiver vazio n pode ficar... ( fazer o codigo final depois...)
				return false;
			}
			
			return true;
		}
	}
}
