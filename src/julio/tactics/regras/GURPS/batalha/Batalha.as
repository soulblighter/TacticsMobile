package julio.tactics.regras.GURPS.batalha
{
	import flash.events.EventDispatcher;
	import julio.tactics.regras.GURPS.*;
	import julio.tactics.regras.GURPS.acoes.*;
	import julio.tactics.regras.GURPS.enuns.*;
	import julio.tactics.regras.GURPS.IA.EIA_Condition;
	import julio.tactics.regras.GURPS.IA.EIA_Target;
	import julio.tactics.regras.GURPS.IA.Gambit;
	import julio.tactics.regras.GURPS.Pericias.*;
	import julio.tactics.DisplayInstruction;
	import julio.tactics.events.BattleEvent;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class Batalha
	{
		private const MAX_ORDEM_SIZE:int = 20;		// tamanho maximo da fila de ordem de personnagens
		private var _numObjetos:uint;				// Numero de personagens da batalha
		private var _grafo:Grafo3;					// grafo do cenário
		private var _objetos:Array;		 			// Lista de personagens da batalha
		private var _ordemAcoes:Array; 				// Lista com a ordem dos ids dos personagem a agir
		private var _turnoAtual:uint;				// numero do turno atual
		
		private var _teams:Object;
		
		private var skillTable:Object = new Object;
		private var actionTable:Object = new Object;
		private var itemTable:Object = new Object;
		private var gambitTable:Object = new Object;
		
		// communicator
		private var _comm:EventDispatcher;
		private var _internalComm:EventDispatcher;
		
		// data
		private var _battleData:XML;
		
		
		// variaveis do turno
		private var subject:Personagem;
		private var subjActionList:Array;
		private var subjActionListXML:XML;
		private var subjSelectionArea:XML;
		private var subjSelectedTarget:XML;
		private var subjAction:Acao;
		private var objects:Array;
		private var objeDefensesTestes:Array;
		
		public function Batalha( comm:EventDispatcher, battleData:XML )
		{
			this._comm = comm;
			this._internalComm = new EventDispatcher;
			
			this._battleData = battleData;
			
			this._grafo = null;
			this._turnoAtual = 0;
			this._ordemAcoes = new Array;
			this._objetos = new Array;
			this._numObjetos = 0;
			this._teams = new Object;
			
			initDB();
		}
		
		private function initDB():void
		{
//			actionTable["1"] = new Ataque("1", "BAL", EAcaoTipo.STD, EAcaoAlcance.MELEE, false, 1);
//			actionTable["1"] = new  AtaqueGDP("1");
//			actionTable["2"] = new  AtaqueBAL("2");
			
			// pericias de combate/armas
			skillTable[EPericia.LIGHT_SWORD] = new PericiaCombate( EPericia.LIGHT_SWORD, "Espadas Curtas (Física/Média)", "Esta é a perícia no uso de qualquer tipo de arma balanceada com 30 a 60 cm de comprimento, incluindo o terçado, o gládio e o bastão.",
													-5, EAtributo.DX, -2, 8, 0.0, 0.5, 1, 2, 1 );
			skillTable[EPericia.BRIGA] = new PericiaCombate( EPericia.BRIGA, "Briga (Física/Fácil)", "Esta é a perícia, nada científica, de sair-no-tapa num combate de perto. Faça um teste de Briga sempre que atacar o adversário com as mãos ou pés para ver se consegue atingi-lo. Some 1/10 de seu NH em Briga (arredondado para baixo) ao dano provocado. É possível aparar duas vezes por turno (um para cada mão) quando você se defende com as mãos limpas, e seu parâmetro Aparar será igual a 2/3 de seu NH em Briga. Com esta perícia só é possível aparar ataques de mãos, pés e armas usadas em combate de perto.",
													-5, EAtributo.DX, -1, 8, 1.0/10.0, 2.0/3.0, 2, 2, 2, true );
			skillTable[EPericia.ESCUDO] = new PericiaEscudo( EPericia.ESCUDO, "Escudo (Física/Fácil)", "Esta é a perícia no uso de um escudo do tipo medieval ou daqueles usados pelas tropas de choque. Esta perícia é necessária para atacar com o Escudo. No entanto a defesa passiva oferecida pelo escudo (1 a 4 pontos) protege quem o carrega, mesmo que ele não saiba como usá-lo. A defesa ativa de um escudo (no Bloqueio) é 1/2 de seu NH com o Escudo. Logo, você será capaz de bloquear muito melhor se tiver estudado a perícia do que se usar seu nível pré-definido. O atributo DX de uma pessoa média é 10, ou seja o nível prédefinido de sua habilidade com o Escudo é 6 e seu Bloqueio será 3.",
													-4, EAtributo.DX, -1, 8, 0, 0, 1/2, 1, 2 );
			
			// magias
			skillTable[EPericia.CURA_SUPERFICIAL] = new PericiaMagicaD( EPericia.CURA_SUPERFICIAL, "Cura Superficial / Comum", "Restitui até 3 pontos de HT ao objetivo. Esta mágica não elimina a doença mas curará o dano já causado por ela. ",
													"4" );
			skillTable[EPericia.CURA_PROFUNDA] = new PericiaMagicaMD( EPericia.CURA_PROFUNDA, "Cura Profunda (MD) / Comum", "Restitui até 8 pontos de HT ao objetivo. Não elimina a doença mas curará o dano já causado por ela.",
													"5" );
			
			// lista de itens
			itemTable["1"] = new  Arma( 1, "Gládio", 400, 1, EPericia.LIGHT_SWORD, new Dados(0,1), new Dados(0,1), null, null, 0, 7, 1.0/6.0 );
			itemTable["2"] = new  Escudo( 2, "Escudo Pequeno", 40, 4, EPericia.ESCUDO, 2, 0, 0, 11 );
			
		}
		
		// adiciona um time na lógica da batalha
		public function pushTeam( name:String ):void
		{
			if ( this._teams[name] )
				throw new Error("Team jah existe em Batalha::pushTeam( "+name+" )");
			this._teams[name] = new Array;
		}
		
		// adiciona um personagem na lógica da batalha
		public function pushObject( obj:Personagem, team:String, idPos:uint ):uint
		{
			if ( this._objetos.indexOf( obj ) != -1 )
				throw new Error("Objeto jah existe em Batalha::pushObject( "+obj+", "+team+", "+idPos+" )");
			
			if ( !podeFicar( this._grafo.getData( idPos ), this._grafo.getObjects( idPos ), obj ) )
				throw new Error("Vertice \""+idPos+"\" jah esta ocupado em Batalha::pushObject( "+obj+", "+team+", "+idPos+" )");
			
			var id:uint = this._numObjetos;
			
			this._teams[team].push(id);
			this._objetos[id] = obj;
			
			obj.ID = id;
			obj.idPos = idPos;
			obj.teamID = team;
			obj.init = 100.0 / obj.velocidade;
			obj.realInit = 100.0 / obj.velocidade;
			
			this._numObjetos++;
			
			return id;
		}
		
		public function removeTeam( team:String ):void
		{
			delete this._teams[team];
		}
		
		public function removeChar( id:uint ):void
		{
			var teamID:String = this._objetos[id].teamID;
			
			this._teams[teamID].splice( this._teams[teamID].indexOf( id ), 1 );
			delete this._objetos[id];
		}
		
		
		
		
		// origem: dados do vertice de origem
		// destino: dados do vertice de destino
		// arco: dados da coneção entre os vertices
		// extra: a definir (possivelmente o personagem ou dados do tipo de movimento)
		public function calculaCusto( origem:TileData, destino:TileData, arco:ArcData, extra:MoveType ):Number
		{
			var move:MoveType = extra;
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
				
				// kem n voa/flutua leva penalidade do terreno
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
					if ( move.maxJumpDown >= altura )
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
		public function podePassar( tile:TileData, objs:Array, extra:Personagem ):Boolean
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
		public function podeFicar( tile:TileData, objs:Array, extra:Personagem ):Boolean
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
		
		
		// atualiaza a fila de ações dos personagens
		public function updateFila():void
		{
			// limpa a fila
			this._ordemAcoes.splice(0, _ordemAcoes.length);
			
			var temp:Personagem
			for each( temp in this._objetos )
				temp.init = temp.realInit;
				
			if( this._numObjetos > 0 )
			// preenche MAX_ORDEM_SIZE posições na fila de ações
			while( this._ordemAcoes.length < MAX_ORDEM_SIZE )
			{
				var baseInit:Number = 100;
				
				//	Procura entre todos os personagens o que tenha a menor iniciativa.
				for each( temp in this._objetos )
					if( temp.init < baseInit )
						baseInit = temp.init;
				
//				trace("\tbaseInit: ", baseInit);
				
				//	Deduz esse valor da iniciativa de todos os personagens.
				for each( temp in this._objetos )
					temp.init -= baseInit;
				
				//	Poe na fila de ações os personagens q ficaram com Iniciativa 0
				//	e faz suas iniciativas serem o valor da velocidade novamente.
				for ( var key:String in this._objetos )
				{
					temp = this._objetos[key];
					if( this._ordemAcoes.length < MAX_ORDEM_SIZE )
						if( temp.init == 0 )
						{
//							trace("\tnext: ", this._personagens[a3][b3].char.nome);
							this._ordemAcoes.push( uint(key) );
							temp.init = 100.0 / temp.velocidade;
						}
				}
			}
		}
		
		public function get ordemAcoes():Array { return this._ordemAcoes; }
		
		// pega o proximo personagem a agir (primeiro da fila)
		public function proximoAgir():uint
		{
			if( this._ordemAcoes.length == 0 )
				throw new Error("BATALHA::proximoAgir() ordem de ações vazia!");
			
			return this._ordemAcoes[0];
		}
		
		public function fullAction():void
		{
			if( this._ordemAcoes.length == 0 )
				throw new Error("BATALHA::fullAction() ordem de ações vazia!");
			
//			trace("realInit: ", proximoAgir().realInit);
			var prox:uint = this._ordemAcoes.shift();
			var baseInit:Number = this._objetos[prox].realInit;
			
			var temp:Personagem
			for each( temp in this._objetos )
			{
//				trace("\treal init antes de ", a2, "-", b2, " = ", this._personagens[a2][b2].realInit);
				temp.realInit -= baseInit;
//				trace("\treal init depoi de ", a2, "-", b2, " = ", this._personagens[a2][b2].realInit);
			}
			this._objetos[prox].realInit = 100.0 / this._objetos[prox].velocidade;
		}
		
		public function halfAction():void
		{
			if( this._ordemAcoes.length == 0 )
				throw new Error("BATALHA::halfAction() ordem de ações vazia!");
			
			var prox:uint = this._ordemAcoes.shift();
			var baseInit:Number = this._objetos[prox].realInit;
			
			var temp:Personagem
			for each( temp in this._objetos )
				temp.realInit -= baseInit;
			
			this._objetos[prox].realInit = 50.0 / this._objetos[prox].velocidade;
		}
		
		public function run():void
		{
			// lê o inputData
			
			// cria os personagens
			var p1:Personagem = new Personagem( "João", 14, 12, 14, 12 );
			var p2:Personagem = new Personagem( "Maria", 10, 18, 10, 10 );
			
			for each( var p:Pericia in skillTable )
			{
				p1.pushPericia( p, 0 );
				p2.pushPericia( p, 0 );
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
			
			p1.restauraDefesasAtivas();
			p1.refresh();
			p2.restauraDefesasAtivas();
			p2.refresh();
			
			
			// o mapa
			this._grafo = new Grafo3;
			this._grafo.fromXML(this._battleData.grafo[0]);
			/*
			var v:Array = new Array;
			v[0]  = this._grafo.inserirVertice( new TileData( 0, 0, 0, 1, ETile.PLAIN ) );
			v[1]  = this._grafo.inserirVertice( new TileData( 0, 0, 1, 1, ETile.LAVA ) );
			v[2]  = this._grafo.inserirVertice( new TileData( 0, 0, 2, 1, ETile.PLAIN ) );
			v[3]  = this._grafo.inserirVertice( new TileData( 0, 0, 3, 1, ETile.PLAIN ) );
			v[4]  = this._grafo.inserirVertice( new TileData( 0, 0, 4, 1, ETile.PLAIN ) );
			v[5]  = this._grafo.inserirVertice( new TileData( 0, 0, 5, 1, ETile.PLAIN ) );
			
			v[6]  = this._grafo.inserirVertice( new TileData( 1, 0, 0, 1, ETile.PLAIN ) );
			v[7]  = this._grafo.inserirVertice( new TileData( 1, 0, 1, 1, ETile.LAVA ) );
			v[8]  = this._grafo.inserirVertice( new TileData( 1, 0, 2, 1, ETile.PLAIN ) );
			v[9]  = this._grafo.inserirVertice( new TileData( 1, 0, 3, 1, ETile.PLAIN ) );
			v[10] = this._grafo.inserirVertice( new TileData( 1, 0, 4, 1, ETile.PLAIN ) );
			v[11] = this._grafo.inserirVertice( new TileData( 1, 0, 5, 1, ETile.PLAIN ) );
			
			v[12] = this._grafo.inserirVertice( new TileData( 2, 0, 0, 1, ETile.PLAIN ) );
			v[13] = this._grafo.inserirVertice( new TileData( 2, 0, 1, 1, ETile.LAVA ) );
			v[14] = this._grafo.inserirVertice( new TileData( 2, 0, 2, 1, ETile.PLAIN ) );
			v[15] = this._grafo.inserirVertice( new TileData( 2, 0, 3, 2, ETile.PLAIN ) );
			v[16] = this._grafo.inserirVertice( new TileData( 2, 0, 4, 2, ETile.PLAIN ) );
			v[17] = this._grafo.inserirVertice( new TileData( 2, 0, 5, 2, ETile.PLAIN ) );
			
			v[18] = this._grafo.inserirVertice( new TileData( 3, 0, 0, 1, ETile.PLAIN ) );
			v[19] = this._grafo.inserirVertice( new TileData( 3, 0, 1, 1, ETile.LAVA ) );
			v[20] = this._grafo.inserirVertice( new TileData( 3, 0, 2, 1, ETile.PLAIN ) );
			v[21] = this._grafo.inserirVertice( new TileData( 3, 0, 3, 1, ETile.PLAIN ) );
			v[22] = this._grafo.inserirVertice( new TileData( 3, 0, 4, 1, ETile.PLAIN ) );
			v[23] = this._grafo.inserirVertice( new TileData( 3, 0, 5, 1, ETile.PLAIN ) );
			
			v[24] = this._grafo.inserirVertice( new TileData( 4, 0, 0, 1, ETile.PLAIN ) );
			v[25] = this._grafo.inserirVertice( new TileData( 4, 0, 1, 1, ETile.LAVA ) );
			v[26] = this._grafo.inserirVertice( new TileData( 4, 0, 2, 1, ETile.PLAIN ) );
			v[27] = this._grafo.inserirVertice( new TileData( 4, 0, 3, 1, ETile.LAVA ) );
			v[28] = this._grafo.inserirVertice( new TileData( 4, 0, 4, 1, ETile.PLAIN ) );
			v[29] = this._grafo.inserirVertice( new TileData( 4, 0, 5, 1, ETile.PLAIN ) );
			
			v[30] = this._grafo.inserirVertice( new TileData( 5, 0, 0, 1, ETile.PLAIN ) );
			v[31] = this._grafo.inserirVertice( new TileData( 5, 0, 1, 1, ETile.PLAIN ) );
			v[32] = this._grafo.inserirVertice( new TileData( 5, 0, 2, 1, ETile.PLAIN ) );
			v[33] = this._grafo.inserirVertice( new TileData( 5, 0, 3, 1, ETile.LAVA ) );
			v[34] = this._grafo.inserirVertice( new TileData( 5, 0, 4, 1, ETile.PLAIN ) );
			v[35] = this._grafo.inserirVertice( new TileData( 5, 0, 5, 1, ETile.PLAIN ) );
			
			// linha 0
			this._grafo.inserirArco( v[0], v[1], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[0], v[6], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[1], v[2], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[1], v[7], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[2], v[3], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[2], v[8], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[3], v[4], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[3], v[9], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[4], v[5], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[4], v[10], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[5], v[11], new ArcData( EArc.SIMPLE ) );
			
			// linha 1
			this._grafo.inserirArco( v[6], v[7], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[6], v[12], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[7], v[8], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[7], v[13], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[8], v[9], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[8], v[14], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[9], v[10], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[9], v[15], new ArcData( EArc.HJUMP ) );
			
			this._grafo.inserirArco( v[10], v[11], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[10], v[16], new ArcData( EArc.HJUMP ) );
			
			this._grafo.inserirArco( v[11], v[17], new ArcData( EArc.HJUMP ) );
			
			// linha 2
			this._grafo.inserirArco( v[12], v[13], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[12], v[18], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[13], v[14], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[13], v[19], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[14], v[15], new ArcData( EArc.HJUMP ) );
			this._grafo.inserirArco( v[14], v[20], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[15], v[16], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[15], v[21], new ArcData( EArc.HJUMP ) );
			
			this._grafo.inserirArco( v[16], v[17], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[16], v[22], new ArcData( EArc.HJUMP ) );
			
			this._grafo.inserirArco( v[17], v[23], new ArcData( EArc.HJUMP ) );
			
			// linha 3
			this._grafo.inserirArco( v[18], v[19], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[18], v[24], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[19], v[20], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[19], v[25], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[20], v[21], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[20], v[26], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[21], v[22], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[21], v[27], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[22], v[23], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[22], v[28], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[23], v[29], new ArcData( EArc.SIMPLE ) );
			
			// linha 4
			this._grafo.inserirArco( v[24], v[25], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[24], v[30], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[25], v[26], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[25], v[31], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[26], v[27], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[26], v[32], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[27], v[28], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[27], v[33], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[28], v[29], new ArcData( EArc.SIMPLE ) );
			this._grafo.inserirArco( v[28], v[34], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[29], v[35], new ArcData( EArc.SIMPLE ) );
			
			// linha 5
			this._grafo.inserirArco( v[30], v[31], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[31], v[32], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[32], v[33], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[33], v[34], new ArcData( EArc.SIMPLE ) );
			
			this._grafo.inserirArco( v[34], v[35], new ArcData( EArc.SIMPLE ) );
			
			// extra jumps
			this._grafo.inserirArco( v[12], v[14], new ArcData( EArc.DJUMP ) );
			this._grafo.inserirArco( v[32], v[34], new ArcData( EArc.DJUMP ) );
			*/
			
			p1.addGambit( 0, new Gambit( EIA_Target.SELF, [EIA_Condition.HP_lt_50_p], "CuraSuperficial" ) );
			p1.addGambit( 1, new Gambit( EIA_Target.FOE, [EIA_Condition.NEAREST], "AttackBAL" ) );
			
			p2.addGambit( 0, new Gambit( EIA_Target.SELF, [EIA_Condition.HP_lt_30_p], "CuraProfunda" ) );
			p2.addGambit( 1, new Gambit( EIA_Target.FOE, [EIA_Condition.NEAREST], "AttackGDP" ) );
			
			pushTeam("PlayerTeam");
			pushTeam("EnemyTeam");
			pushObject( p1, "PlayerTeam", 0 );
			pushObject( p2, "EnemyTeam", 29 );
			
			
			this._comm.dispatchEvent( new DisplayInstruction( DisplayInstruction.MAP, this._battleData.grafo[0] ) );
			
			this._comm.dispatchEvent( new DisplayInstruction( DisplayInstruction.ADD_CHAR, <char id={p1.ID} pos={p1.idPos}> <display asset="Fighter_high"/> </char>, false, 0.0 ) );
			this._comm.dispatchEvent( new DisplayInstruction( DisplayInstruction.ADD_CHAR, <char id={p2.ID} pos={p2.idPos}> <display asset="Fighter_high"/> </char>, false, 0.0 ) );
			
/*
			var data:XML = <move target="0" animation="run" start="0">
					<step type="HJUMP" value="1"/>
					<step type="SIMPLE" value="2"/>
					<step type="DJUMP" value="4"/>
					<step type="SIMPLE" value="5"/>
					<step type="DJUMP" value="17"/>
					<step type="SIMPLE" value="16"/>
					<step type="SIMPLE" value="15"/>
				</move>;
			this._comm.dispatchEvent( new DisplayInstruction( DisplayInstruction.MOVE, data, false, 1000.0 ) );
			
			this._comm.dispatchEvent( new DisplayInstruction( DisplayInstruction.SHOW_DAMAGE, <damage target="0" value="15" color="0xff0000" duration="0.3"/>, true, 1000.0 ) );
			this._comm.dispatchEvent( new DisplayInstruction( DisplayInstruction.ANIMATION, <animation target="0" value="hit" loop="3" time="300" />, false, 1000.0 ) );
			this._comm.dispatchEvent( new DisplayInstruction( DisplayInstruction.WAIT, <wait time="1.2"/>, false, 0.0 ) );
			
			this._comm.dispatchEvent( new DisplayInstruction( DisplayInstruction.LOOK, <look target="0" from="15" to="32"/>, false, 0.0 ) );
			
			this._comm.dispatchEvent( new DisplayInstruction( DisplayInstruction.SHOW_DAMAGE, <damage target="0" value="10" color="0x0000ff" duration="1.5"/>, true, 100.0 ) );
			this._comm.dispatchEvent( new DisplayInstruction( DisplayInstruction.SHOW_DAMAGE, <damage target="0" value="20" color="0xff0000" duration="1.5"/>, true, 200.0 ) );
			
			this._comm.dispatchEvent( new DisplayInstruction( DisplayInstruction.SHOW_DAMAGE, <damage target="0" value="30" color="0x0000ff" duration="1.5"/>, true, 300.0 ) );
			
			this._comm.dispatchEvent( new DisplayInstruction( DisplayInstruction.SHOW_DAMAGE, <damage target="0" value="40" color="0xff0000" duration="1.5"/>, true, 400.0 ) );
			this._comm.dispatchEvent( new DisplayInstruction( DisplayInstruction.SHOW_DAMAGE, <damage target="0" value="50" color="0x0000ff" duration="1.5"/>, true, 500.0 ) );
			
			this._comm.dispatchEvent( new DisplayInstruction( DisplayInstruction.SHOW_DAMAGE, <damage target="0" value="60" color="0xff0000" duration="1.5"/>, true, 600.0 ) );
			
			this._comm.dispatchEvent( new DisplayInstruction( DisplayInstruction.SHOW_DAMAGE, <damage target="0" value="70" color="0x00ff00" duration="1.5"/>, true, 100.0 ) );
*/
			
			var a:int = 10;
			
			
			this._internalComm.addEventListener( BattleEvent.BATTLE_TURN_START, battleTurnStart );
			this._internalComm.addEventListener( BattleEvent.CHAR_TURN, charTurnStart );
			
			this._internalComm.dispatchEvent( new BattleEvent(BattleEvent.BATTLE_TURN_START) );
			
/*
			var running:Boolean = true;
//			while ( running )
			{
				// ordena lista de personagens a agir
				this.updateFila();
				
				// pega proximo personagem a agir
				subject = this._objetos[this.proximoAgir()];
				
				// loop do turno do persongem
//				while ( subject.possuiAcoesDisponives() )
				{
					//Pega lista de ações disponiveis
					this.subjActionList = subject.getActions();
					
					// mostra lista de ações
//					this._comm.dispatchEvent( new DisplayInstruction( DisplayInstruction.GET_ACTION, this.subjActionList, false, 0.0 ) );
					
					// ação escolhida
					this.subjAction = this.actionTable["2"];
					
					// pega area da ação escolhida
//					this._grafo.search( subject.idPos, subjAction.alcance, subjAction.area,
					
					
					subjSelectionArea = <data/>;
					
					// pega todas vertices no alcance inicial
					var resultAlcance:Array = this._grafo.alcanceDijkstra( subject.idPos, subjAction.alcance, calculaCusto, subjAction.moveTypeAlcance, false );
					
					
					// para cada vertice no alcance
					for each( var n:uint in resultAlcance )
					{
						var sel:XML = <selection id={n} type="tile"/>
						
						// pega os vertices da área
						var resultArea:Array = this._grafo.alcanceDijkstra( n, subjAction.area, calculaCusto, subjAction.moveTypeArea, false );
						
						// para cada vertice na area
						for each( var n2:uint in resultArea )
						{
							sel.appendChild( <effect id={n2} type="tile"/> );
						}
						
						subjSelectionArea.appendChild(sel);
					}
				}
				
			}
			
			subjSelectionArea;
			*/
		}
		
		
		// começo do turno
		private function battleTurnStart( e:BattleEvent ):void
		{
			// ordena lista de personagens a agir
			this.updateFila();
			
			// pega proximo personagem a agir
			subject = this._objetos[this.proximoAgir()];
			
			subject.restauraAcoes();
			
//			charTurnStart();
			this._internalComm.dispatchEvent( new BattleEvent(BattleEvent.CHAR_TURN) );
			return;
		}
		
		private function actionList2XML( actionList:Array ):XML
		{
			var result:XML = <actionList />;
			var i:uint = 0;
			for each( var a:Acao in actionList )
			{
				result.appendChild(<acao id={i} type={a.tipoAcao} render="button" enabled="true" label={a.nome} />);
//type = { EAcaoTipo.STD } id = "2" render = "iconbutton" icon = "../assets/sword1.png" label = { resourceManager.getString('localeText', 'BAL_LABEL') } tip = { resourceManager.getString('localeText', 'BAL_TIP') }
//<acao id="3" type={EAcaoTipo.MOV} render="button" enabled="true" alcance={this.movimento} tip={resourceManager.getString('localeText', 'MOVE_TIP') + " " + this.movimento + " " + resourceManager.getString('localeText', 'MOVE_TIP2')} label={resourceManager.getString('localeText', 'MOVE_LABEL')} />;
				i++;
			}
			result.appendChild(<acao id={i} render="button" enabled="true" label="Terminar" />);
			return result;
		}
		
		// turno do personagem
		private function charTurnStart( e:BattleEvent ):void
		{
			if ( !subject.possuiAcoesDisponives() )
			{
				//charTurnEnd();
				this.fullAction();
				this._internalComm.dispatchEvent( new BattleEvent(BattleEvent.BATTLE_TURN_START) );
				return;
			}
			
			this._comm.dispatchEvent( new DisplayInstruction( DisplayInstruction.MOVE_CAMERA, <camera type="char" id={subject.ID} />, false, 0.0 ) );
			
			//Pega lista de ações disponiveis
//			this.subjActionList = subject.getActions();
			this.subjActionList = subject.actionList();
			
			
			this.subjActionListXML = actionList2XML( this.subjActionList );
			
			
			
			
			
			
			
			// espera acao escolhida
			this._comm.addEventListener( BattleEvent.ACTION_SELECTED, charTurnActionSelected );
			
			// mostra lista de ações
			this._comm.dispatchEvent( new DisplayInstruction( DisplayInstruction.GET_ACTION, subjActionListXML, false, 0.0 ) );
			return;
		}
		
		private function charTurnActionSelected( e:BattleEvent ):void
		{
			this._comm.removeEventListener( BattleEvent.ACTION_SELECTED, charTurnActionSelected );
//			trace("acao escolhida: ", e.data.@id);
			
			// ação escolhida
			this.subjAction = this.subjActionList[uint(e.data.@id)]; // this.actionTable[e.data.@id];
			
			subjSelectionArea = <data/>;
			
			// pega todas vertices no alcance inicial
			var resultAlcance:Array = this._grafo.alcanceDijkstra( subject.idPos, subjAction.alcance, calculaCusto, subjAction.moveTypeAlcance, false );
			
			subjSelectionArea.@tiles = String(resultAlcance);
//			subjSelectionArea.@chars = String(listaAlvos);	// lista de ids dos alvos
			
			// para cada vertice no alcance
			for each( var n:uint in resultAlcance )
			{
				var sel:XML = <selection id={n} /> //<selection id={n} type="tile"/>
				
				// pega os vertices da área
				var resultArea:Array = this._grafo.alcanceDijkstra( n, subjAction.area, calculaCusto, subjAction.moveTypeArea, false );
				
				// para cada vertice na area
				for each( var n2:uint in resultArea )
				{
//					sel.appendChild( <effect id={n2} type="tile"/> );
					sel.@area = String(resultArea);
				}
				
				subjSelectionArea.appendChild(sel);
			}
			
//			subjSelectionArea.appendChild(<t15 area="1,2,3"/>);
			
			// espera alvo escolhido
			this._comm.addEventListener( BattleEvent.TARGET_SELECTED, subjTargetSelection );
			
			// mostra lista de alvos
			this._comm.dispatchEvent( new DisplayInstruction( DisplayInstruction.GET_TARGET, subjSelectionArea, false, 0.0 ) );
			return;
			
		}
		
		private function subjTargetSelection( e:BattleEvent ):void
		{
			// pega alvo e executa ação
			
			this.subjAction;// = this.subjActionList[uint(e.data.@id)];
			
			if ( this.subjAction is Movimento )
			{
				var caminho:Array = this._grafo.caminhosDijkstra( this.subject.idPos, calculaCusto, podePassar, podeFicar, this.subject, this.subject.moveType )[uint(e.data.@id)];
			//	<move target="0" animation="run" start="0">
			//		<step type="HJUMP" value="1"/>
			//		<step type="SIMPLE" value="2"/>
			//		<step type="DJUMP" value="4"/>
			//		<step type="DJUMP" value="16"/>
			//		<step type="SIMPLE" value="15"/>
			//	</move>
				var path:XML = <move target={subject.ID} animation="run" start={subject.idPos}/>;
				
				for ( var s:int = 1; s < caminho.length; s++ )
					path.appendChild(<step type={caminho[s].type} value={caminho[s].id}/>);
				
				this._comm.dispatchEvent( new DisplayInstruction( DisplayInstruction.MOVE, path, false, 0.0 ) );
				
				this.subject.idPos = uint(e.data.@id);
				this.subject.acaoMovimento = false;
				this.subject.acaoPadrao = false;
				this.subject.acaoMenor = false;
				this.subject.acaoLivre = false;
				
				this._internalComm.dispatchEvent( new BattleEvent(BattleEvent.CHAR_TURN) );
				return;
			}
			
			
//			switch( String(e.data.@id) )
//			{
//			case "2":	// mover
				// executa ação de movimento
				
//				break;
//			}
			
		}
		
		// fim do turno do personagem
		private function charTurnEnd( e:BattleEvent ):void
		{
			
		}
		
		
		
		
		
		
		
		// IA ------------------------------------------------------------------------------------
		
		private function Gambit_NEAREST( subject:Personagem, target:Personagem ):Number
		{
			// pega distancia entra subject.idPos e target.idPos calculado por Dijkstra
			var posSubj:TileData = this._grafo.getData( subject.idPos )
			var posTarg:TileData = this._grafo.getData( target.idPos )
			return 1.0/( (posSubj.x + posSubj.z) - (posTarg.x + posTarg.z) );
		}
		private function Gambit_HP_lt_50_p( subject:Personagem, target:Personagem ):Number
		{
			if( target.PV_porcentagem > 50 )
				return 0.0;
			else
				return 1.0 / target.PV_porcentagem;
		}
		private function Gambit_HP_lt_30_p( subject:Personagem, target:Personagem ):Number
		{
			if( target.PV_porcentagem > 30 )
				return 0.0;
			else
				return 1.0 / target.PV_porcentagem;
		}
		
		
		// End IA --------------------------------------------------------------------------------
		
/*
		public function run( inputData:XML, render:CenaBatalha ):void
		{
			this.render = render;
			
			// parse do arquivo de input
			try {
				if ( inputData.@rule != "GURPS" )
					throw new Error("Unica regra suportada atualmente, eh GURPS: "+inputData.@rule);
				
				// todos os times
				var teams:XMLList = inputData.team;
				
				// para cada time
				for( var a:uint = 0; a < teams.length(); a++ )
				{
					// pega a lista de personagens do time
					var chars:XMLList = teams[a].char;
					
					this.pushTeam( teams[a].@id, teams[a].@name );
					
					// para cada personagem do time
					for( var b:uint = 0; b < chars.length(); b++ )
					{
						
						var p:Personagem = new Personagem( chars[b].@name, chars[b].@ST, chars[b].@DX, chars[b].@IQ, chars[b].@HT );
						this.pushChar( p, teams[a].@id, chars[b].@id, chars[b].@x, chars[b].@z );
						
						var di:DisplayInstruction = new DisplayInstruction( DisplayInstruction.ADD_CHAR )
						di.data = chars[b];
						
						render.addToDisplayQueue(di);
						
//						var de:DisplayEvent = new DisplayEvent( DisplayEvent.ADD_CHAR );
//						de.data = chars[b];
//						GlobalDispatcher.dispatchEvent( de );
					}
				}
			} catch ( e:Error )
			{
				throw new Error( "Erro no parse do arquivo xml input da Batalha: " + e.message );
			}
			
//			GlobalDispatcher.addEventListener( BattleEvent.NEXT_TURN, turnStart, false, 0, false );
//			GlobalDispatcher.addEventListener( BattleEvent.CHAR_TURN, getCharAction, false, 0, false );
		}

		public function turnStart( e:BattleEvent ):void
		{
			// incrementa numeração do turno
			_turnoAtual++;
			
			// atualiza a lista de ações
			this.updateFila();
			
			// pega o personagem q vai agir
			table.subj = this.proximoAgir();
			table.subj.char.restauraAcoes();
			
			var de:DisplayEvent = new DisplayEvent(DisplayEvent.START);
			de.data = new Object;
			de.data.subj = table.subj;
			GlobalDispatcher.dispatchEvent( de );
			
			GlobalDispatcher.dispatchEvent( new BattleEvent(BattleEvent.CHAR_TURN) );
		}
		
		public function getCharAction( e:BattleEvent ):void
		{
//			if ( table.subj.char.acaoPadrao == false && table.subj.char.acaoMovimento == false )
//			{
//				var be:BattleEvent = new BattleEvent( BattleEvent.RETURN );
//				be.data = <return><actionId>0</actionId></return>;
//			}
//			else
//			{
				GlobalDispatcher.addEventListener( BattleEvent.RETURN, actionSelected );
				
				var de:DisplayEvent = new DisplayEvent(DisplayEvent.GET_ACTION);
				de.data = table.subj.char.getActions();
				GlobalDispatcher.dispatchEvent( de );
//			}
		}
		
		public function actionSelected( e:BattleEvent ):void
		{
			GlobalDispatcher.removeEventListener( BattleEvent.RETURN, actionSelected );
//			trace("e.data.actionId: ", e.data.actionId);
//			trace("table.subj: ", table.subj);
//			trace("table.subj: ", skillTable[e.data.actionId]);
			skillTable[e.data.actionId].execute(table);
		}
*/
		
		
		
		
/*
		public function findIn( positions:Array, subj:Object, type:String="any" ):Array
		{
			var result:Array = new Array;
			
			switch(type) {
			case "enemy":
				// para cada personagem
				for ( var a:String in this._personagens )
				{
					for ( var b:String in this._personagens[a] )
					{
						for each( var i:String in positions )
						{
							
						}
					}
				}
			break;
			default: throw new Error("Batalha::findIn("+positions+", "+subj+", "+type+") -> tipo desconhecido");
			}
			
			// para cada id de nos do grafo no array positions
			for each( var i:String in positions )
			{
				// para cada personagem
				for ( var a:String in this._personagens )
				{
					for ( var b:String in this._personagens[a] )
					{
						// para cada id de nos do grafo no array positions
						for each( var i2:String in positions )
						{
							if ( _grafo.pos2id(_personagens[a][b].x, _personagens[a][b].z) == i &&
								_personagens[a][b].team != i2 )
								result.push( _personagens[a][b].id );
						}
					}
				}
			}
			
			return result;
		}

		public function findIn( positions:Array, ofTeams:Array ):Array
		{
			trace(positions);
			trace(ofTeams);
			var result:Array = new Array;
			
			// para cada id de nos do grafo no array positions
			for each( var i:String in positions )
			{
				// para cada personagem
				for ( var a:String in this._personagens )
				{
					for ( var b:String in this._personagens[a] )
					{
						// para cada id de nos do grafo no array positions
						for each( var i2:String in ofTeams )
						{
							if ( _grafo.pos2id(_personagens[a][b].x, _personagens[a][b].z) == i &&
								_personagens[a][b].team != i2 )
								result.push( _personagens[a][b].id );
						}
					}
				}
			}
			
			return result;
		}
		
*/
		

/*
		public function moveChar( team:String, id:String, x:int, z:int ):Array
		{
			var id_origem:String = this._grafo.pos2id( this._personagens[team][id].x, this._personagens[team][id].z );
			var id_destino:String = this._grafo.pos2id( x, z );
			
			// se nao existir caminho...
			if ( this._grafo.distancias( id_origem ).id_destino >= 9999 )
				throw new Error("Erro em moveChar( " + team + ", " + id + ", " + x + ", " + z + " ), impossivel axar caminho");
			
//			trace( "origem:", id_origem, "x:", this._personagens[team][id].x, "z:", this._personagens[team][id].z);
//			trace( "destino:", id_destino, "x:", x, "z:", z);
			
			this._personagens[team][id].x = x;
			this._personagens[team][id].z = z;
			
			var caminho:Array = this._grafo.caminhos(id_origem)[id_destino];
			
			this._grafo.desbloquear(id_origem);
			this._grafo.bloquear(id_destino);
			
			return caminho;
		}
*/
	}
}

/*
Gambits

Targets: Foe, Ally, Self, Ally&Self

Especificadores: para ally
	higest HP
	lowest HP
	higest MP
	lowest MP
	highest max HP
	lowest max HP
	highest max MP
	lowest max MP
	highest level
	lowest level
	
*	strongest attack power
*	weakest attack power
*	strongest magic power
*	weakest magic power
*	strongest defense
*	weakest defense
*	strongest magic defense
*	weakest magic defense
*	strongest status defense
*	weakest status defense
*	strongest speed defense
*	weakest speed defense

*	party leader
	
	HP:			=0%, =100%, >0%, >10%, >20%, >30%, >40%, >50%, >60%, >70%, >80%, >90%, <10%, <20%, <30%, <40%, <50%, <60%, <70%, <80%, <90%, <100%
	MP:			=0%, =100%, >0%, >10%, >20%, >30%, >40%, >50%, >60%, >70%, >80%, >90%, <10%, <20%, <30%, <40%, <50%, <60%, <70%, <80%, <90%, <100%
	Status:		any, any debuff, any buff, KO, Sleep, Confuse, Blind, Poison, Silence, Immobilize, Slow, Protect, Shell, Haste, Invisible, Regen, Berserk, HP Critical(bloodied HP<50%), Near Death(HP<25%)

	elemental-weak:			fire, wind, water, earth, light, dark	(weak siginifica q o alvo recebe dano de fogo)
	elemental-vulnerable:	fire, wind, water, earth, light, dark	(vulnerable significa q o alvo recebe mais dano q o normal de fogo)

	undead
	flying

Especificadores: para foe
	higest HP
	lowest HP
	higest MP
	lowest MP
	highest max HP
	lowest max HP
	highest max MP
	lowest max MP
	highest level
	lowest level
	
	strongest attack power
	weakest attack power
	strongest magic power
	weakest magic power
	strongest defense
	weakest defense
	strongest magic defense
	weakest magic defense
	strongest status defense
	weakest status defense
	strongest speed defense
	weakest speed defense
	
	HP:			=0%, =100%, >0%, >10%, >20%, >30%, >40%, >50%, >60%, >70%, >80%, >90%, <10%, <20%, <30%, <40%, <50%, <60%, <70%, <80%, <90%, <100%
	MP:			=0%, =100%, >0%, >10%, >20%, >30%, >40%, >50%, >60%, >70%, >80%, >90%, <10%, <20%, <30%, <40%, <50%, <60%, <70%, <80%, <90%, <100%
	Status:		any, any debuff, any buff, KO, Sleep, Confuse, Blind, Poison, Silence, Immobilize, Slow, Protect, Shell, Haste, Invisible, Regen, Berserk, HP Critical(bloodied HP<50%), Near Death(HP<25%)

	elemental-weak:			fire, wind, water, earth, light, dark	(weak siginifica q o alvo recebe dano de fogo)
	elemental-vulnerable:	fire, wind, water, earth, light, dark	(vulnerable significa q o alvo recebe mais dano q o normal de fogo)

	undead
	flying
	
*	has item (para usar com steal)
*	party leaders target
*	any
*	nearest
*	furthest
*	enemy leader
//*	targeting leader
//*	targeting self
//*	targeting ally
	
*	self HP:		=100%, >10%, >20%, >30%, >40%, >50%, >60%, >70%, >80%, >90%, <10%, <20%, <30%, <40%, <50%, <60%, <70%, <80%, <90%, <100%	(referente ao HP de quem faz a ação e não ao alvo)
*	self MP:		=100%, >10%, >20%, >30%, >40%, >50%, >60%, >70%, >80%, >90%, <10%, <20%, <30%, <40%, <50%, <60%, <70%, <80%, <90%, <100%	(referente ao MP de quem faz a ação e não ao alvo)
*	seld Status:	any, any debuff, any buff, KO, Sleep, Confuse, Blind, Poison, Silence, Immobilize, Slow, Protect, Shell, Haste, Invisible, Regen, Berserk, bloodied(HP<50%), HP Critical(HP<25%) 	(referente ao status de quem faz a ação e não ao alvo)


Especificadores: para self
*	HP:			=0%, =100%, >0%, >10%, >20%, >30%, >40%, >50%, >60%, >70%, >80%, >90%, <10%, <20%, <30%, <40%, <50%, <60%, <70%, <80%, <90%, <100%
*	MP:			=0%, =100%, >0%, >10%, >20%, >30%, >40%, >50%, >60%, >70%, >80%, >90%, <10%, <20%, <30%, <40%, <50%, <60%, <70%, <80%, <90%, <100%
*	Status:		any, any debuff, any buff, KO, Sleep, Confuse, Blind, Poison, Silence, Immobilize, Slow, Protect, Shell, Haste, Invisible, Regen, Berserk, bloodied(HP<50%), HP Critical(HP<25%)
	facing 2 or more enemies
	facing 3 or more enemies
	facing 4 or more enemies


Movement: // Define como usar as ações de movimento em relação ao Target
	// Foe
	Agressive		// Move em direção ao inimigo
	Defensive		// Move para longe do inimigo
	Stationary		// Não move
	
	// Ally
	Helper			// Move em direção ao aliado
	Defensive		// Move para longe do inimigo
	Stationary		// Não move
	
	// Self
	Helper			// Move em direção ao aliado
	Agressive		// Move em direção ao inimigo
	Defensive		// Move para longe do inimigo
	Stationary		// Não move
	
	// Ally&Self
	Helper			// Move em direção ao aliado
	Agressive		// Move em direção ao inimigo
	Defensive		// Move para longe do inimigo
	Stationary		// Não move

*/
