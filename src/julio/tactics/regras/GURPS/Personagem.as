package julio.tactics.regras.GURPS
{
	import flash.utils.describeType;
	import julio.tactics.regras.GURPS.acoes.AtaqueBAL;
	import julio.tactics.regras.GURPS.acoes.AtaqueGDP;
	import julio.tactics.regras.GURPS.acoes.Movimento;
	import julio.tactics.regras.GURPS.batalha.ObjetoAtivo;
	import julio.tactics.regras.GURPS.enuns.*;
	import julio.tactics.regras.GURPS.*;
	import julio.tactics.regras.GURPS.Pericias.PericiaCombate;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import julio.tactics.regras.GURPS.IA.Gambit;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class Personagem extends ObjetoAtivo
	{
		private static const damageBAL:Array = [
							new Dados,			// 0
							new Dados,			// 1
							new Dados,			// 2
							new Dados,			// 3
							new Dados,			// 4
							new Dados(1, -5),	// 5
							new Dados(1, -4),	// 6
							new Dados(1, -3),	// 7
							new Dados(1, -2),	// 8
							new Dados(1, -1),	// 9
							new Dados(1),		// 10
							new Dados(1, 1),	// 11
							new Dados(1, 2),	// 12
							new Dados(2, -1),	// 13
							new Dados(2),		// 14
							new Dados(2, 2),	// 15
							new Dados(2, 2),	// 16
							new Dados(3, -1),	// 17
							new Dados(3),		// 18
							new Dados(3, 1),	// 19
							new Dados(3, 2),	// 20
							];
		private static const damageGDP:Array = [
							new Dados,			// 0
							new Dados,			// 1
							new Dados,			// 2
							new Dados,			// 3
							new Dados,			// 4
							new Dados(1, -5),	// 5
							new Dados(1, -4),	// 6
							new Dados(1, -3),	// 7
							new Dados(1, -3),	// 8
							new Dados(1, -2),	// 9
							new Dados(1, -2),	// 10
							new Dados(1, -1),	// 11
							new Dados(1, -1),	// 12
							new Dados(1),		// 13
							new Dados(1),		// 14
							new Dados(1, 1),	// 15
							new Dados(1, 1),	// 16
							new Dados(1, 2),	// 17
							new Dados(1, 2),	// 18
							new Dados(2, -1),	// 19
							new Dados(2, -1),	// 20
							];
		
		
		private var _nome:String;
		
		// Caracteristicas físicas
		private var _altura:Number;
		private var _tamanho:ETamanho;
		private var _peso:Number;		// em kg
		
		// Tabelas globais de Pericias, Ações e Itens
//		public var skillTable:Object;
//		public var actionTable:Object;
//		public var itemTable:Object;
		
		
		// Atributos Primarios
		private var _ST:int;				// Força
		private var _DX:int;				// Dextreza
		private var _IQ:int;				// Inteligência
		private var _HT:int;				// Vitalidade
		
		// redutor no atibutos
		private var _red_ST:int;			// redutor (geralmente temporario) nos atributos primarios
		private var _red_DX:int;			// *
		private var _red_IQ:int;			// *
		private var _red_HT:int;			// *
		
		// Modificadores de Atributos Secundários
		private var _fadigaExtra:int;		// bonus permanante nos atributos secundários
		private var _pontosVidaExtra:int;	// *
		
		
		private var _bonusAparar:int;		// bonus temporários
		private var _bonusBloquear:int;		// *
		private var _bonusEsquiva:int;		// *
		private var _bonusVelocidade:int;	// *
		private var _bonusMovimento:int;	// *
		
		
		private var _numAparar:int;			// Numero de vezes q o personagem pode aparar por tuno com arma equipada
		private var _numBloquear:int;
		private var _numEsquivar:int;
		
		
		// Iventário
		private var _iventario:Array;		// Array de itens sendo carregados pelo personagem (obs.: nao incluem os itens equipados!!!)
		private var _arma:Arma;				// Arma atualmente equipada (null para nenhum)
		private var _escudo:Escudo;			// Escudo atualmente equipadr (null para nenhum)
		private var _armadura:Armadura;		// Armadura atualmente equipado (null para nenhum)
		
		// Pericias
		private var _pericias:Object;
		private var _periciaCombateDesarmado:Object;
		
		
		// Resistências
		private var _resistenciasDanoMultipicador:Object;	// Esses valores sao multiplicados ao dano
		private var _resistenciasDanoSomador:Object;		// esses valores sao somados ao dano
		
		// Variáveis de combate
		private var _idGrupo:String;
		private var _alvo:Personagem;
		private var _iniciativa:Number;
		private var _initAtual:Number;
		
		
		// Variaveis de controle do turno do personagem
		private var _acaoMovimento:Boolean;
		private var _acaoPadrao:Boolean;
		private var _acaoMenor:Boolean;
		private var _acaoLivre:Boolean;
		
		// Valores atual dos atributos
		private var _danoAcumulado:uint;		// total de dano levada pelo personagem atualmente
		private var _fadigaGasta:uint;			// fadiga q foi gasta pelo personagem
		private var _esquivasGastas:uint;		// Numero de esquivas realizadas pelo personagem desde o ultumo turno
		private var _bloqueiosGastos:uint;		// Numero de bloqueios realizados pelo personagem desde o ultumo turno
		private var _apararGastos:uint;			// Numero de aparar realizadas pelo personagem desde o ultumo turno
		
		// status
		private var _status:Array;				// Array de Status do personagem, positivos ou negativos
		
		
		// Parametros da Intelgencia Artificial (Gambit FF12 copy)
		private var _gambits:Array;
		private var _numGambits:uint;
		
		// Flag de defesa total
		private var _defesaTotal:Boolean;
		
		public function Personagem( nome:String = "Unknow", ST:int = 10, DX:int = 10, IQ:int = 10, HT:int = 10 )
		{
			this._nome = nome;
			
			this._ST = ST;
			this._DX = DX;
			this._IQ = IQ;
			this._HT = HT;
			
			this._red_ST = 0;
			this._red_DX = 0;
			this._red_IQ = 0;
			this._red_HT = 0;
			
			// TODO: talvez um sistema semelhante aos talentos de DnD 3.5
			this._fadigaExtra = 0;
			this._pontosVidaExtra = 0;
			this._bonusAparar = 0;
			this._bonusBloquear = 0;
			this._bonusEsquiva = 0;
			this._bonusVelocidade = 0;
			this._bonusMovimento = 0;
			
			this._iventario = new Array; // TODO: Classe especifica e mais prática soh pra o inventário
			this._arma = null;
			this._escudo = null;
			this._armadura = null;
			
			this._pericias = new Object;
			this._resistenciasDanoMultipicador = new Object;
			this._resistenciasDanoSomador = new Object;
			
//			// inicializa tabela de pontos de pericia
//			// *feito externamente
//			var def:XML = describeType(EPericia);
//			var props:XMLList = def..constant.@name;
//			for each (var prop:String in props)
//			{
//				this._pericias[prop] = 0;
//			}
			
			var def2:XML = describeType(EDano);
			var props2:XMLList = def2..constant.@name;
			for each (var prop2:String in props2)
			{
				this._resistenciasDanoMultipicador[prop2] = 1.0;
			}
			this._resistenciasDanoMultipicador[EDano.HEAL] = -1.0;	// dano de cura soma ao invez de diminuir HP
			
			var def3:XML = describeType(EDano);
			var props3:XMLList = def3..constant.@name;
			for each (var prop3:String in props3)
			{
				this._resistenciasDanoSomador[prop3] = 0;
			}
			
			
			this._gambits = new Array;
			this._numGambits = 5;
			
			restauraAcoes();
		}
		
		public function refresh():void
		{
			
		}
		
		public function get nome():String { return _nome; }
//		public override function get altura():Number { return this._altura; }
//		public override function get peso():Number { return this._peso; }
		
		public function get base_ST():int { return this._ST; }
		public function get base_DX():int { return this._DX; }
		public function get base_IQ():int { return this._IQ; }
		public function get base_HT():int { return this._HT; }
		
		public function set base_ST(value:int):void { this._ST = value; }
		public function set base_DX(value:int):void { this._DX = value; }
		public function set base_IQ(value:int):void { this._IQ = value; }
		public function set base_HT(value:int):void { this._HT = value; }
		
		public function get red_ST():int { return this._red_ST; }
		public function get red_DX():int { return this._red_DX; }
		public function get red_IQ():int { return this._red_IQ; }
		public function get red_HT():int { return this._red_HT; }
		
		public function set red_ST(value:int):void { this._red_ST = value; }
		public function set red_DX(value:int):void { this._red_DX = value; }
		public function set red_IQ(value:int):void { this._red_IQ = value; }
		public function set red_HT(value:int):void { this._red_HT = value; }
		
		public function get atual_ST():int { return this._ST - this._red_ST; }
		public function get atual_DX():int { return this._DX - this._red_DX; }
		public function get atual_IQ():int { return this._IQ - this._red_IQ; }
		public function get atual_HT():int { return this._HT - this._red_HT; }
		
		// Atributos Sencundários
		public function get fadiga():int		{ return this.atual_ST + this._fadigaExtra; }
		public function get pontosVida():int	{ return this.atual_HT + this._pontosVidaExtra; }
		public function get aparar():int		{ return 1/3 * acerto + this._bonusAparar }
		public function get bloquear():int		{ return (this.escudoEquipado!=null)?( 1/2 * this._pericias[this.escudoEquipado.pericia] + this._bonusBloquear) : 0; }
		public function get esquivar():int		{ return this.movimento + this._bonusEsquiva; }
		public override function get velocidade():Number	{ return (this.atual_DX+this.atual_HT)/4 + this._bonusVelocidade; }
		public override function get movimento():uint		{ return this.velocidade + this._bonusMovimento; }
		
		public function get acerto():int
		{
			var bonus:int = 0;
			if ( this.armaEquipada == null )
			{
				bonus =  this._periciaCombateDesarmado.skill.Points2NH(this._periciaCombateDesarmado.points);
			} else {
				bonus = this._pericias[this.armaEquipada.pericia].skill.Points2NH(this._pericias[this.armaEquipada.pericia].points) + this.armaEquipada.redutor;
				
				if ( this.armaEquipada.ST_min > this.atual_ST )
				{
					bonus += this.atual_ST - this.armaEquipada.ST_min;
				}
			}
			return this.atual_DX + bonus;
		}
		
		public function get numAparar():int		{ return this._numAparar }
		public function get numBloquear():int	{ return this._numBloquear; }
		public function get numEsquivar():int	{ return this._numEsquivar; }
		
//		public function get reacao():int		{ return this._finalReacao; }
//		public function get listaAcoes():XML	{ return this._finalListaAcoes; }
//		public override function get moveType():MoveType	{ return this._finalMoveType; }
		
		public function get defesaTotal():Boolean	{ return this._defesaTotal; }
		
		public function get numApararUsados():int		{ return this._apararGastos; }
		public function get numBloqueiosUsados():int	{ return this._bloqueiosGastos; }
		public function get numEsquivasUsadas():int		{ return this._esquivasGastas; }
		
		public function get numApararDisponiveis():int		{ var result:int = numAparar - numApararUsados; if ( result < 0 ) return 0; else return result; }
		public function get numBloqueiosDisponiveis():int	{ var result:int = numBloquear - numBloqueiosUsados; if ( result < 0 ) return 0; else return result; }
		public function get numEsquivasDisponiveis():int	{ var result:int = numEsquivar - numEsquivasUsadas; if ( result < 0 ) return 0; else return result; }
		
		public function usaAparar( num:uint = 1 ):void		{ this._apararGastos += num; }
		public function usaBloquear( num:uint = 1 ):void	{ this._bloqueiosGastos += num; }
		public function usaEsquivar( num:uint = 1 ):void	{ this._esquivasGastas += num; }
		
		
		
		public function get danoBAL():Dados		{ return Personagem.damageBAL[this.atual_ST]; }
		public function get danoGDP():Dados		{ return Personagem.damageGDP[this.atual_ST]; }
		
		// Itens
		public function equiparArma( arma:Arma ):void
		{
			this._arma = arma;
		}
		public function equiparArmadura( armadura:Armadura ):void
		{
			this._armadura = armadura;
		}
		public function equiparEscudo( escudo:Escudo ):void
		{
			this._escudo = escudo;
		}
		
		// equipamento
		public function get armaEquipada():Arma { return this._arma; }
		public function set armaEquipada(value:Arma):void { this._arma = value; }
		
		public function get escudoEquipado():Escudo { return this._escudo; }
		public function set escudoEquipado(value:Escudo):void { this._escudo = value; }
		
		public function get armaduraEquipada():Armadura { return this._armadura; }
		public function set armaduraEquipada(value:Armadura):void { this._armadura = value; }
		
		public function pushPericia( pericia:Pericia, points:uint ):void
		{
			this._pericias[pericia.id] = new Object;
			this._pericias[pericia.id].skill = pericia;
			this._pericias[pericia.id].points = points;
			this._pericias[pericia.id].NH = pericia.Points2NH(points);
		}
		
		public function selectPericiaCombateDesarmado( id:EPericia ):void
		{
			if ( !this._pericias[id] )
				throw new Error("personagem n tem essa pericia em Personagem::selectPericiaCombateDesarmado( " + id + " )");
			
			if ( !this._pericias[id].skill.desarmado )
				throw new Error("Essa pericia n eh de combat desarmado! em Personagem::selectPericiaCombateDesarmado( " + id + " )");
			
			this._periciaCombateDesarmado = this._pericias[id];
		}
		
		public function pontosProximoNivelPericia( id:EPericia ):uint
		{
			if ( !this._pericias[id] )
				throw new Error("personagem n tem essa pericia em Personagem::pontosProximoNivelPericia( " + id + " )");
			
			return this._pericias[id].skill.points2NextNH(this._pericias[id].points);
		}
		
		public function addPontosEmPericia( id:EPericia, pontos:uint ):void
		{
			if ( !this._pericias[id] )
				throw new Error("personagem n tem essa pericia em Personagem::addPontosEmPericia( " + id + ", "+ pontos +" )");
			
			var d1:int = pontosProximoNivelPericia(id);
			if ( pontosProximoNivelPericia(id) != pontos )
				throw new Error("Quantidade de pontos n coincide com nessecario pra proximo nivel Personagem::addPontosEmPericia( " + id + ", "+ pontos +" )");
			
			var pericia:Pericia = this._pericias[id].skill;
			
			this._pericias[pericia.id].points += pontos;
			this._pericias[pericia.id].NH = pericia.Points2NH(this._pericias[pericia.id].points);
		}
		
		public function getPontosEmPericia( id:EPericia ):uint
		{
			if ( !this._pericias[id] )
				throw new Error("personagem n tem essa pericia em Personagem::getPontosEmPericia( " + id + " )");
			
			return this._pericias[id].points;
		}
		
		public function getNHEmPericia( id:EPericia ):uint
		{
			if ( !this._pericias[id] )
				throw new Error("personagem n tem essa pericia em Personagem::getPontosEmPericia( " + id + " )");
			
			return this._pericias[id].NH;
		}
		
		public function actionList():Array
		{
			var actionList:Array = [];
			
			// ações padroes
			if ( acaoPadrao == true )
			{
				// se n tiver arma equipada
				if ( this.armaEquipada == null )
				{
					// * cria lista de ações para ataques possiveis (i.e.: GDP ou BAL)
					actionList.push( new AtaqueBAL );
					actionList.push( new AtaqueGDP );
				}
				
				// se tiver arma equipada
				if ( this.armaEquipada != null )
				{
					if ( this.armaEquipada.cortante)
						actionList.push( new AtaqueBAL );
					
					if ( this.armaEquipada.perfurante)
						actionList.push( new AtaqueGDP );
				}
			}
			
			// açoes de movimento
			if ( acaoMovimento == true )
			{
				actionList.push( new Movimento( "Andar", false, this.movimento, MoveType.WALK ) );
			}
			
			// END TURN
//			actionList.appendChild(<acao id="1" />);
			
			return actionList;
		}
		
		public function getActions():XML
		{
//			var resourceManager:IResourceManager = ResourceManager.getInstance();
			
			var actionList:XML = <actionList/>;
			
			// ações padroes
			if ( acaoPadrao == true )
			{
				// se n tiver arma equipada
				if ( this.armaEquipada == null )
				{
					// pega perica de combate desarmado padrao do personagem
					//var pericia:Pericia = this._pericias[this.armaEquipada.pericia].skill;
//					actionList.appendChild( <action type={EAcaoTipo.STD} id={this._periciaCombateDesarmado.skill.id} /> );
					
					// * cria lista de ações para ataques possiveis (i.e.: GDP ou BAL)
//					var ataques:XML = <acao render="tilelist" enabled="true" tip={resourceManager.getString('localeText', 'MELEE_TIP')} label={resourceManager.getString('localeText', 'MELEE_LABEL')}/>;
					
//					ataques.appendChild( <tilenode type={EAcaoTipo.STD} id="2" render="iconbutton" icon="../assets/sword1.png" label={resourceManager.getString('localeText', 'BAL_LABEL')} tip={resourceManager.getString('localeText', 'BAL_TIP')} /> );
//					ataques.appendChild( <tilenode type={EAcaoTipo.STD} id="3" render="iconbutton" icon="../assets/sword1.png" label={resourceManager.getString('localeText', 'GDP_LABEL')} tip={resourceManager.getString('localeText', 'GDP_TIP')} /> );
					
					actionList.appendChild( <acao id="10" type={EAcaoTipo.STD}/> );
					actionList.appendChild( <acao id="11" type={EAcaoTipo.STD}/> );
					
//					actionList.appendChild(ataques);
				}
				
				// se tiver arma equipada
				if ( this.armaEquipada != null )
				{
					// pega a pericia relacionada a arma
					//var pericia:Pericia = this._pericias[this.armaEquipada.pericia].skill;
					
					// * cria lista de ações para ataques possiveis com arma (i.e.: GDP ou BAL)
//					var ataques2:XML = <acao render="tilelist" enabled="true" tip={resourceManager.getString('localeText', 'MELEE_TIP')} label={resourceManager.getString('localeText', 'MELEE_LABEL')}/>;
					
					if ( this.armaEquipada.cortante)
//						ataques2.appendChild( <tilenode type={EAcaoTipo.STD} id="2" render="iconbutton" icon="../assets/sword1.png" label={resourceManager.getString('localeText', 'BAL_LABEL')} tip={resourceManager.getString('localeText', 'BAL_TIP')}/> );
						actionList.appendChild( <tilenode id="10" type={EAcaoTipo.STD}/> );
					
					if ( this.armaEquipada.perfurante)
//						ataques2.appendChild( <tilenode type={EAcaoTipo.STD} id="3" render="iconbutton" icon="../assets/sword1.png" label={resourceManager.getString('localeText', 'GDP_LABEL')} tip={resourceManager.getString('localeText', 'GDP_TIP')}/> );
						actionList.appendChild( <tilenode id="11" type={EAcaoTipo.STD}/> );
					
//					actionList.appendChild(ataques2);
				}
				
//				ataque.appendChild(<tilenode id="11" type="standart" render="iconbutton" alcance="1" icon="../assets/sword1.png" label={resourceManager.getString('localeText', 'BAL_LABEL')} tip={resourceManager.getString('localeText', 'BAL_TIP')} />);
//				ataque.appendChild(<tilenode id="12" type="standart" render="iconbutton" alcance="1" icon="../assets/sword1.png" label={resourceManager.getString('localeText', 'GDP_LABEL')} tip={resourceManager.getString('localeText', 'GDP_TIP')} />);
//				xml.appendChild(ataque);
				
				// magias
				// TODO: lista de magias do personagem q sao açõa padrão
				
//				var magias:XML = <acao id="2" render="tilelist" enabled="true" tip={resourceManager.getString('localeText', 'MAGIC_TIP')} label={resourceManager.getString('localeText', 'MAGIC_LABEL')}/>;
//					magias.appendChild(<tilenode id="21" type="standart" render="iconbutton" alcance="1" area="2" icon="../assets/tome1.png" label={resourceManager.getString('localeText', 'FIREBALL_LABEL')} />);
//				xml.appendChild(magias);
			}
			
			// açoes de movimento
			if ( acaoMovimento == true )
			{
//				actionList.appendChild(<acao id="3" type={EAcaoTipo.MOV} render="button" enabled="true" alcance={this.movimento} tip={resourceManager.getString('localeText', 'MOVE_TIP') + " " + this.movimento + " " + resourceManager.getString('localeText', 'MOVE_TIP2')} label={resourceManager.getString('localeText', 'MOVE_LABEL')} />);
				actionList.appendChild(<acao id="30" type={EAcaoTipo.MOV}/>);
			}
			
			// END TURN
			actionList.appendChild(<acao id="1" />);
			
			return actionList;
		}
		
		// Turno
		public function get acaoMovimento():Boolean { return this._acaoMovimento; }
		public function set acaoMovimento(value:Boolean):void { this._acaoMovimento = value; }
		
		public function get acaoPadrao():Boolean { return this._acaoPadrao; }
		public function set acaoPadrao(value:Boolean):void { this._acaoPadrao = value; }
		
		public function get acaoMenor():Boolean { return this._acaoMenor; }
		public function set acaoMenor(value:Boolean):void { this._acaoMenor = value; }
		
		public function get acaoLivre():Boolean { return this._acaoLivre; }
		public function set acaoLivre(value:Boolean):void { this._acaoLivre = value; }
		
		public function restauraAcoes():void
		{
			acaoMovimento = true;
			acaoPadrao = true;
			acaoMenor = true;
			acaoLivre = true;
		}
		
		public function restauraDefesasAtivas():void
		{
			this._apararGastos = 0;
			this._bloqueiosGastos = 0;
			this._esquivasGastas = 0;
		}
		
		public function possuiAcoesDisponives():Boolean
		{
			return ( acaoPadrao || acaoMovimento || acaoMenor || acaoLivre );
		}
		
		
		// recebe uma array de danos e aplica todos
		public function levaDanos( danos:Array ):Number
		{
			var danoFinal:Number = 0;
			for each( var dano:Dano in danos )
			{
				danoFinal += levaDano(dano);
			}
			return danoFinal;
		}
		
		// recebe um objeto de dano e aplica seu valor (modificado pelas resistencias) ao personagem
		public function levaDano( dano:Dano ):Number	// retorn o dano final q o personagem levou considerando suas resistencias
		{
			var danoFinal:Number = dano.valor;
			
			// Redus o RD do dano (exceto se o dano ignorar RD)
			if ( !dano.ignoraRD )
			{
				var danoReduzido:int = danoFinal - this._resistenciasDanoSomador[dano.tipo];
				if ( danoReduzido <= 0 ) return 0;
				danoFinal = danoReduzido;
			}
			
			// verifica o tipo de dano
			// busca por resistencias e vulnerabilidades a dano (Resistencias naturais do personagem e dos itens equipados)
			// aplica modificadores ao dano (ex.: personagem tem redução de dano de fogo ou eh vuneravel a gelo)
			danoFinal = danoFinal * this._resistenciasDanoMultipicador[dano.tipo];
//			danoFinal = dano.valor + this._resistenciasDanoSomador[dano.tipo];
			
			// diminui os PVs do dano aplicado
			this._danoAcumulado += danoFinal;
			
			return danoFinal;
		}
		
		
		public function isDead():Boolean
		{
			if ( this.PV_Atual < 0 )
				return true;
			else
				return false;
		}
		
		public function get PV_Atual():uint
		{
			return this.pontosVida - this._danoAcumulado;
		}
		
		public function get PV_porcentagem():Number
		{
			return this.PV_Atual / this.pontosVida;
		}
		public function setMaxGambits( n:uint ):void
		{
			this._numGambits = n;
		}
		public function get numMaxGambits():uint
		{
			return this._numGambits;
		}
		
		
		public function addGambit( index:uint, value:Gambit ):void
		{
			if ( index > numMaxGambits )
				throw new Error("Erro em Personagem::addGambit( "+index+", "+value+" ). Index maior q o maximo permitido. Esqueceu de usar setMaxGambits( "+index+" )?");
			
			this._gambits[index] = value;
		}
		public function removeGambit( index:uint ):void
		{
			this._gambits[index] = null;
		}
		public function swapGambit( index1:uint, index2:uint ):void
		{
			if ( index1 > numMaxGambits )
				throw new Error("Erro em Personagem::swapGambit( "+index1+", "+index2+" ). Index1 maior q o maximo permitido. Esqueceu de usar setMaxGambits( "+index1+" )?");
			if ( index2 > numMaxGambits )
				throw new Error("Erro em Personagem::swapGambit( "+index1+", "+index2+" ). Index2 maior q o maximo permitido. Esqueceu de usar setMaxGambits( "+index2+" )?");
			
			var temp:Gambit = this._gambits[index1];
			this._gambits[index1] = this._gambits[index2];
			this._gambits[index2] = temp;
		}
		
		
		// Batalha
		
		public function get idGrupo():String { return this._idGrupo; }
		public function set idGrupo(value:String):void { this._idGrupo = value; }
/*
		// nao podem passar pelo tile ocupado por esse personagem outros personagens inimigos
		public override function canPass( o:ObjetoCenario ):Boolean
		{
			if (o is Personagem)
			{
				var p:Personagem = o as Personagem;
				if ( this.idGrupo != p.idGrupo )
					return false;
			}
			return true;
		}
		
		// nada pode terminar o movimento em cima de um personagem
		public override function canStay( o:ObjetoCenario ):Boolean { return false; }
*/
		
		
		public function fromXML( xml:XML ):void
		{
			// TODO: carrega os dados do personagem a partir de um objeto xml
		}
		
		public function toXML():XML
		{
			var xml:XML = <personagem/>;
			// TODO: transforma os dados do personagem em um objeto xml
			
			return xml;
		}
		
		public function toString():String
		{
			return "{Personagem: " + this._nome + "}";
		}
		
	}
}
