package julio.tactics.regras.Basic
{
	import flash.events.EventDispatcher;
	import julio.tactics.regras.GURPS.Dano;
	import julio.tactics.regras.GURPS.enuns.EDano;
	import julio.tactics.events.DisplayEvent;
//	import julio.tactics.regras.GURPS.enuns.*;
//	import julio.tactics.regras.GURPS.IA.EIA_Condition;
//	import julio.tactics.regras.GURPS.IA.EIA_Target;
//	import julio.tactics.regras.GURPS.IA.Gambit;
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
		private var _ordemAcoes:Array; 				// Lista com a ordem dos ids dos personagem a agir
		private var _turnoAtual:uint;				// numero do turno atual
		private var _grafo:GrafoSimples;
		
		private var _objetos:Array;		 			// Lista de personagens da batalha
		private var _teams:Array;
		
		
		// communicators
		private var _conm:EventDispatcher;
		private var _internalConm:EventDispatcher;
		
		// data
		private var _battleData:XML;
		
		
		// variaveis do turno
		private var subjectID:uint;				// ID do personagem atual
		private var subject:Char;				// personagem atual
		private var subjActionID:uint;			// ID da ação
		private var subjSelectedTargetID:uint;	// id do alvo
		private var subjActionList:Object;		// Lista de IDs de ações disponíveis do personagem atual
		
//		private var subjSelectionArea:XML;
//		private var subjActionList:Array;
//		private var subjActionListXML:XML;
		private var objectID:uint;
//		private var objects:Array;
//		private var objeDefensesTestes:Array;
		
		public function Batalha( comm:EventDispatcher, battleData:XML )
		{
			this._conm = comm;
			this._internalConm = new EventDispatcher;
			
			this._battleData = battleData;
			
			this._grafo = null;
			this._turnoAtual = 0;
			this._ordemAcoes = new Array;
			this._objetos = new Array;
			this._numObjetos = 0;
			this._teams = new Array;
		}
		
		// adiciona um time na lógica da batalha
		public function pushTeam( id:uint ):void
		{
			if ( this._teams.indexOf( id ) != -1 )
				throw new Error("Team jah existe em Batalha::pushTeam( "+id+" )");
			this._teams[id] = new Array;
		}
		
		// adiciona um personagem na lógica da batalha
		public function pushPersonagem( id:uint, team:uint, obj:Char, idPos:uint ):void
		{
			if ( this._objetos.indexOf( obj ) != -1 )
				throw new Error("Objeto jah existe em Batalha::pushObject( "+obj+", "+team+", "+idPos+" )");
			
//			if ( !podeFicar( this._grafo.getData( idPos ), this._grafo.getObjects( idPos ), obj ) )
//				throw new Error("Vertice \""+idPos+"\" jah esta ocupado em Batalha::pushObject( "+obj+", "+team+", "+idPos+" )");
			
//			var id:uint = this._numObjetos;
			
			this._teams[team].push(id);
			this._objetos[id] = obj;
			
			obj.id = id;
			obj.idPos = idPos;
			obj.idTeam = team;
			obj.init = 100.0 / obj.velocidade;
			obj.tempInit = 100.0 / obj.velocidade;
			
			this._numObjetos++;
		}
/*
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
*/
		// atualiaza a fila de ações dos personagens
		public function updateFila():void
		{
			// limpa a fila
			this._ordemAcoes.splice(0, _ordemAcoes.length);
			
			var temp:Char;
			for each( temp in this._objetos )
				temp.tempInit = temp.init;
				
			if( this._numObjetos > 0 )
			// preenche MAX_ORDEM_SIZE posições na fila de ações
			while( this._ordemAcoes.length < MAX_ORDEM_SIZE )
			{
				var baseInit:Number = 100;
				
				//	Procura entre todos os personagens o que tenha a menor iniciativa.
				for each( temp in this._objetos )
					if( temp.tempInit < baseInit )
						baseInit = temp.tempInit;
				
//				trace("\tbaseInit: ", baseInit);
				
				//	Deduz esse valor da iniciativa de todos os personagens.
				for each( temp in this._objetos )
					temp.tempInit -= baseInit;
				
				//	Poe na fila de ações os personagens q ficaram com Iniciativa 0
				//	e faz suas iniciativas serem o valor da velocidade novamente.
				for ( var key:String in this._objetos )
				{
					temp = this._objetos[key];
					if( this._ordemAcoes.length < MAX_ORDEM_SIZE )
						if( temp.tempInit == 0 )
						{
//							trace("\tnext: ", this._personagens[a3][b3].char.nome);
							this._ordemAcoes.push( uint(key) );
							temp.tempInit = 100.0 / temp.velocidade;
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
			var baseInit:Number = this._objetos[prox].init;
			
			var temp:Char
			for each( temp in this._objetos )
			{
//				trace("\treal init antes de ", a2, "-", b2, " = ", this._personagens[a2][b2].realInit);
				temp.init -= baseInit;
//				trace("\treal init depoi de ", a2, "-", b2, " = ", this._personagens[a2][b2].realInit);
			}
			this._objetos[prox].init = 100.0 / this._objetos[prox].velocidade;
		}
		
		public function halfAction():void
		{
			if( this._ordemAcoes.length == 0 )
				throw new Error("BATALHA::halfAction() ordem de ações vazia!");
			
			var prox:uint = this._ordemAcoes.shift();
			var baseInit:Number = this._objetos[prox].tempInit;
			
			var temp:Char
			for each( temp in this._objetos )
				temp.tempInit -= baseInit;
			
			this._objetos[prox].tempInit = 50.0 / this._objetos[prox].velocidade;
		}
		
		public function run():void
		{
			// lê o inputData
			
			// cria os personagens
			var p1:Char = new Char( "João", 14, 12, 14, 12, 14, 8, 10 );
			var p2:Char = new Char( "Maria", 10, 18, 10, 10, 12, 14, 12 );
			
			
			// o mapa
			this._grafo = new GrafoSimples;
			this._grafo.fromXML(this._battleData.grafo[0]);
			
/*
			p1.addGambit( 0, new Gambit( EIA_Target.SELF, [EIA_Condition.HP_lt_50_p], "CuraSuperficial" ) );
			p1.addGambit( 1, new Gambit( EIA_Target.FOE, [EIA_Condition.NEAREST], "AttackBAL" ) );
			
			p2.addGambit( 0, new Gambit( EIA_Target.SELF, [EIA_Condition.HP_lt_30_p], "CuraProfunda" ) );
			p2.addGambit( 1, new Gambit( EIA_Target.FOE, [EIA_Condition.NEAREST], "AttackGDP" ) );
*/
			pushTeam(0);
			pushTeam(1);
			pushPersonagem( 0, 0, p1, 0 );
			pushPersonagem( 1, 1, p2, 3 );
			
			
			this._conm.dispatchEvent( new DisplayEvent( DisplayEvent.MAP, this._battleData.grafo[0] ) );
			this._conm.dispatchEvent( new DisplayEvent( DisplayEvent.ADD_CHAR, <char id={p1.id} pos={p1.idPos}> <display asset="Fighter_high"/> </char> ) );
			this._conm.dispatchEvent( new DisplayEvent( DisplayEvent.ADD_CHAR, <char id={p2.id} pos={p2.idPos}> <display asset="Fighter_high"/> </char> ) );
			
			this._internalConm.addEventListener( BattleEvent.BATTLE_TURN_START, battleTurnStart );
			this._internalConm.addEventListener( BattleEvent.CHAR_TURN, charTurnStart );
			
			this._internalConm.dispatchEvent( new BattleEvent(BattleEvent.BATTLE_TURN_START) );
		}
		
		// começo do turno
		private function battleTurnStart( e:BattleEvent ):void
		{
			// ordena lista de personagens a agir
			this.updateFila();
			
			// pega proximo personagem a agir
			subjectID = this.proximoAgir();
			subject = this._objetos[subjectID];
			
			// restaura as ações do personagem
			subject.restauraAcoes();
			
			// Manda a ID do personagem do turno atual
			 _conm.dispatchEvent( new DisplayEvent(DisplayEvent.TURN_START, <display charID={subjectID} />) );
			
			// muda estado para CHAR_TURN
			this._internalConm.dispatchEvent( new BattleEvent(BattleEvent.CHAR_TURN) );
			return;
		}
		
		// turno do personagem
		private function charTurnStart( e:BattleEvent ):void
		{
			// 1.	Verifica se o personagem possui ações sobrando
			// 1.1.	Se não possuir:
			if ( !subject.possuiAcoesDisponives() )
			{
				// 1.1.1.	tira ele da frente da fila de ações
				fullAction();
				// 1.1.2.	muda estado para BATTLE_TURN_START
				this._internalConm.dispatchEvent( new BattleEvent(BattleEvent.BATTLE_TURN_START) );
				return;
			}
			
			// 2.	Pega lista de ações disponiveis
			this.subjActionList = subject.getActions();
			
			subjActionList = generateActionList(subject);
			var action_xml:Object = actionList2XML(this.subjectID, subjActionList);
			
			// TODO: pega os tiles alcançados pela ação
			// TODO: pega a área de cada tile de alcance (se tiver área)
			// no fim a estrutura vai ter:
			// 	lista de ações: [0,10,1,2]
			// 		tiles de alcance
			// 		[0] = [3,9,1,5]
			// 		[10] = [2,3,4,5]
			// 			tiles de area
			// 			[2] = [2,3,7]
			// 			[3] = [3,5,6,11]
			// 			[4] = [4,12,3,7]
			// 			[5] = [5,4,0]
			// 		[1] = [3,9,1,5,3,6,8]
			// ou em xml:
			// 	<display actionList="10,1,3">
			//		<action id="0" range="3,9,1,5" />			// basic melle atack
			//		<action id="10" range="2,3,4,5" />			// ex.: area magic atack
			//			<range id="2" area="2,3,7" />
			//			<range id="3" area="3,5,6,11" />
			//			<range id="4" area="4,12,3,7" />
			//			<range id="5" area="5,4,0" />
			//		<action id="1" range="3,9,1,5,3,6,8" />		// move
			//		<action id="2" />							// change direction & end turn
			// 	</display>
			
			// 3.	prepara para receber ação escolhida
			this._conm.addEventListener( BattleEvent.ACTION_SELECTED, charTurnActionSelected );
			
			// 4.	Manda lista de ações disponíveis
			_conm.dispatchEvent( new DisplayEvent(DisplayEvent.GET_ACTION, action_xml) );
			return;
		}
		
		private function charTurnActionSelected( e:BattleEvent ):void
		{
			this._conm.removeEventListener( BattleEvent.ACTION_SELECTED, charTurnActionSelected );
			if (e.data.@poID)
				trace("acao escolhida: ", e.data.@actionID, ", pos: ", e.data.@posID);
			else
				trace("acao escolhida: ", e.data.@actionID);
			
			// ação escolhida
			this.subjActionID = e.data.@actionID; // this.subjActionList[uint(e.data.@actionID)];
			// alvo escolhhido
			this.subjSelectedTargetID = e.data.@posID; // this.subjActionList[uint(e.data.@posID)];
			
			// TODO: valida a ação (i.e.: verifica se ação e posção escolhidas estão no subject action list)
			
			switch(subjActionID)
			{
				case 0:	// attack
					// pega o(s) alvo(s)
					for each(var o:Char in this._objetos)
						if (o.idPos == subjSelectedTargetID)
							this.objectID = o.id;
					// para esse caso vamos considerar somente um alvo possível
					
					// testa o acerto: if( rand()%subject.acerto > rand()%object.esquiva )
					if ( (Math.random() * subject.acerto) > (Math.random() * this._objetos[this.objectID].esquiva) )
					{
						// acertou
						// cacula o dano: subject.danoBase +- 10%
						var dano:Dano = new Dano(subject.danoBase + subject.danoBase * (Math.random() - 0.5)*0.1, EDano.BAL);
						// tira o dano do alvo: object.levaDano([...])
						var danoFinal:int = this._objetos[this.objectID].levaDano(dano);
						// verifica se o alvo morreu
						
						// envia o DisplayEvent com o resulado da ação
						_conm.dispatchEvent( new DisplayEvent(DisplayEvent.ACTION, <display actionID={1} subject={subjectID} subjectPos={subject.idPos} object={this.objectID} objectPos={this._objetos[this.objectID].idPos} result="hit" damage={danoFinal} />) );
					} else {
						// errou
						
						// envia o DisplayEvent com o resulado da ação
						_conm.dispatchEvent( new DisplayEvent(DisplayEvent.ACTION, <display actionID={1} subject={subjectID} subjectPos={subject.idPos} object={this.objectID} objectPos={this._objetos[this.objectID].idPos} result="miss" />) );
					}
					
					// retira do personagem a ação padrão
					subject.acaoPadrao = false;
					
					// volta para CHAR_TURN
					this._internalConm.dispatchEvent( new BattleEvent(BattleEvent.CHAR_TURN) );
					break;
				
				case 1: // moviment
					// pega o posID do destino
					// TODO: pega o caminho até posição escolhida
					
					var caminho:Array = this.caminhoDijkstra( this.subject.idPos, subjSelectedTargetID, podeMesmoTime, podeTimesDiferentes );
					//	<move target="0" animation="run" start="0">
					//		<step type="HJUMP" value="1"/>
					//		<step type="SIMPLE" value="2"/>
					//		<step type="DJUMP" value="4"/>
					//		<step type="DJUMP" value="16"/>
					//		<step type="SIMPLE" value="15"/>
					//	</move>
					var path:XML = <move target={this.subjectID} animation="running" start={subject.idPos} end={subjSelectedTargetID} />;
					
					for ( var s:int = 1; s < caminho.length; s++ )
						//path.appendChild(<step type={caminho[s].type} value={caminho[s].id}/>);
						path.appendChild(<step type="SIMPLE" value={caminho[s]} />);
					
					// muda posição do personagem
					subject.idPos = subjSelectedTargetID;
					
					// retira ação de movimento do personagem
					subject.acaoMovimento = false;
					
					// envia o DisplayEvent com o caminho percorrido
					this._conm.dispatchEvent( new DisplayEvent( DisplayEvent.MOVE, path ) );
					
					// volta para CHAR_TURN
					this._internalConm.dispatchEvent( new BattleEvent(BattleEvent.CHAR_TURN) );
					break;
				
				case 2: // end
					// pega a direção [n, s w, e]
					// muda a direção do persongem
					// envia o DisplayEvent com a nova direção do personagem
					
					// retira ações do personagem
					subject.acaoPadrao = false;
					subject.acaoMovimento = false;
					subject.acaoMenor = false;
					subject.acaoLivre = false;
					
					// volta para CHAR_TURN
					this._internalConm.dispatchEvent( new BattleEvent(BattleEvent.CHAR_TURN) );
					break;
				
				default: // error
					break;
			}
		}
		
		// gera a lista de ações do personagem e a area de alcance de cada
		private function generateActionList( c:Char ):Object
		{
			// 	lista de ações: [0,10,1,2]
			// 		tiles de alcance
			// 		[0] = [3,9,1,5]
			// 		[10] = [2,3,4,5]
			// 			tiles de area
			// 			[2] = [2,3,7]
			// 			[3] = [3,5,6,11]
			// 			[4] = [4,12,3,7]
			// 			[5] = [5,4,0]
			// 		[1] = [3,9,1,5,3,6,8]
			
			var result:Object = new Object;
			
			// ação de ataque simples
			if ( c.acaoPadrao )
				result[0] = alcanceSimples( this.subject.idPos, 1, podeSempre, podeSempre );
			if ( c.acaoMovimento )
			{
				result[1] = alcanceSimples( this.subject.idPos, this.subject.movimento, podeMesmoTime, podeTimesDiferentes );
				
				// remove todos os tile que ja estao ocupados
//				for each (var posID:uint in result[1])
//					if ( !podeTimesDiferentes( posID, subject ) )
//						result[1].splice(result[1].indexOf(posID), 1);
			}
			if ( c.acaoMenor )
				result[2] = [];
			
			return result;
		}
		
		// tranforma a lista de ações e alcances/areas em XML
		private function actionList2XML( charID:uint, actionList:Object ):XML
		{
			// 	<display actionList="10,1,3">
			//		<action id="0" range="3,9,1,5" />			// basic melle atack
			//		<action id="10" range="2,3,4,5" />			// ex.: area magic atack
			//			<range id="2" area="2,3,7" />
			//			<range id="3" area="3,5,6,11" />
			//			<range id="4" area="4,12,3,7" />
			//			<range id="5" area="5,4,0" />
			//		<action id="1" range="3,9,1,5,3,6,8" />		// move
			//		<action id="2" />							// change direction & end turn
			// 	</display>
			
			var result:XML = <display charID={charID} actionList={[]} />;
			var list:Array = [];
			
			for ( var key:String in actionList )
			{
				var action:XML = <action id={key} range={actionList[key]} />;
				result.appendChild(action);
				list.push(uint(key));
			}
			result.@actionList = list;
			
			return result;
		}
		
		
		
		// retorna uma lista de alcance a partir de uma posição
		private function alcanceSimples( idOrigem:uint, alcance:uint, podePassar:Function, podeFicar:Function ):Array
		{
			if ( !this._grafo.existeVertice(idOrigem) )
				throw new Error("Vertice nao exite Grafo::distanciasDijkstra( " + idOrigem + " )");
			
			var result:Array = new Array;
			var distancias:Array = new Array;		// guarda as distancias do nó de origem aos outros
			var marcados:Array = new Array;			// guarda os nós que jah foram visitados
			
			// desmarca vertices
			// poe um valor alto inicialmente para todos os outor vertices
			// exceto à origem q tem distancia 0
			for ( var id:uint = 0; id < this._grafo.numVertices; id++ )
			{
				marcados[id] = !podePassar(id);
				
				if( idOrigem == id )
					distancias[id] = 0;
				else
					distancias[id] = 9999;
			}
			
			var naoMarcados:Array = new Array;						// Fila com os vertices a serem processados
			naoMarcados.push( idOrigem );							// Poe a origem na fila
			marcados[idOrigem] = true;								// Marca a origem
			
			// para cada vertice nao marcado
			while ( naoMarcados.length > 0 )
			{
				//pega um vertice nao marcado
				var fst:uint = naoMarcados.shift();
				
				// pega os sucessores de um vertice
				var temp:Array = this._grafo.listaSucessores(fst);
				
				// para cada sucessor desse vertice
				for( var a:int = 0; a < temp.length; a++ )
				{
					var suc:uint =  temp[a];
					
					if( !marcados[suc] )
					{
						var custo:Number = 1.0;
						
						//se d[v] > d[u] + w(u, v)
						if(	(distancias[suc] > distancias[fst] + custo) && ( (distancias[fst] + custo) <= alcance) )
						{
							distancias[suc] = distancias[fst] + custo;
							naoMarcados.push( suc );
							marcados[suc] = true;
							result.push( suc );
						}
					}
				}
			}
			
			// remove todos os tile que ja estao ocupados
			for each (var posID:uint in result[1])
				if ( !podeFicar( posID ) )
					result[1].splice(result[1].indexOf(posID), 1);
			
			return result;
		}
		
		public function caminhoDijkstra( idOrigem:uint, idDestino:uint, podePassar:Function, podeFicar:Function, alcance:int = 99 ):Array
		{
			if ( !this._grafo.existeVertice(idOrigem) )
				throw new Error("Vertice nao exite Grafo::caminhoDijkstra( " + idOrigem + ", " + idDestino + ", " + alcance + " )");
			
			var distancias:Array = new Array;		// guarda as distancias do nó de origem aos outros
			var marcados:Array = new Array;			// guarda os nós que jah foram visitados
			var caminhos:Array = new Array;			// guarda os caminhos do nó de origem aos outros
			
			// desmarca vertices
			// poe um valor alto inicialmente para todos os outor vertices
			// exceto à origem q tem distancia 0
			for ( var id:uint = 0; id < this._grafo.numVertices; id++ )
			{
				marcados[id] = !podePassar(id);
				caminhos[id] = new Array;
				
				if( idOrigem == id )
					distancias[id] = 0;
				else
					distancias[id] = 9999;
			}
			
			var naoMarcados:Array = new Array;					// Fila com os vertices a serem processados
			naoMarcados.push( idOrigem );						// Poe a origem na fila
			marcados[idOrigem] = true;							// Marca a origem
			caminhos[idOrigem].push(idOrigem);
			
			// para cada vertice nao marcado
			while ( naoMarcados.length > 0 )
			{
				//pega um vertice nao marcado
				var fst:uint = naoMarcados.shift();
				
				// pega os sucessores de um vertice
				var temp:Array = this._grafo.listaSucessores(fst);
				
				// para cada sucessor desse vertice
				for( var a:int = 0; a < temp.length; a++ )
				{
					var suc:uint =  temp[a];
					
					if( !marcados[suc] )
					{
						var custo:Number = 1.0;
						
						//se d[v] > d[u] + w(u, v)
						if(	(distancias[suc] > distancias[fst] + custo) && ( (distancias[fst] + custo) <= alcance) )
						{
							distancias[suc] = distancias[fst] + custo;
							naoMarcados.push( suc );
							marcados[suc] = true;
							
							// troca o caminho da lista pelo novo melhor encontrado
							caminhos[suc].splice(0, caminhos[suc].length);
							for ( var b:int = 0; b < caminhos[fst].length; ++b )
								caminhos[suc].push( caminhos[fst][b] );
							caminhos[suc].push( suc );
						}
					}
				}
			}
			
			// remove todos os tile que ja estao ocupados
			for (var posID:String in caminhos)
				if ( !podeFicar( uint(posID) ) )
					caminhos.splice(caminhos.indexOf(posID), 1);
			
			return caminhos[idDestino];
		}
		
		private function podeSempre(tileID:uint ):Boolean { return true; }
		private function podeNunca(tileID:uint ):Boolean { return false; }
		
		public function podeMesmoTime( tileID:uint ):Boolean
		{
			// procura por outro personagem com time diferente no local
			for each( var c:Char in this._objetos )
				if ( c.idPos == tileID && c.idTeam != subject.idTeam )
					return false;
			
			// se não encontrou ninguem no respectivo tile de time inimigo, entao pode passar
			return true;
		}
		public function podeTimesDiferentes( tileID:uint ):Boolean
		{
			// procura por outro personagem no local
			for each( var c:Char in this._objetos )
				if ( c.idPos == tileID )
					return false;
			
			// se não encontrou ninguem no respectivo tile, entao pode passar
			return true;
		}
		
/*
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

*/
		
		

		
/*
		private function charTurnActionSelected( e:BattleEvent ):void
		{
			this._conm.removeEventListener( BattleEvent.ACTION_SELECTED, charTurnActionSelected );
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
			this._conm.addEventListener( BattleEvent.TARGET_SELECTED, subjTargetSelection );
			
			// mostra lista de alvos
			this._conm.dispatchEvent( new DisplayInstruction( DisplayInstruction.GET_TARGET, subjSelectionArea, false, 0.0 ) );
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
				
				this._conm.dispatchEvent( new DisplayInstruction( DisplayInstruction.MOVE, path, false, 0.0 ) );
				
				this.subject.idPos = uint(e.data.@id);
				this.subject.acaoMovimento = false;
				this.subject.acaoPadrao = false;
				this.subject.acaoMenor = false;
				this.subject.acaoLivre = false;
				
				this._internalConm.dispatchEvent( new BattleEvent(BattleEvent.CHAR_TURN) );
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
*/
		
		
		
		
		
		
		// IA ------------------------------------------------------------------------------------
/*
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
*/
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
