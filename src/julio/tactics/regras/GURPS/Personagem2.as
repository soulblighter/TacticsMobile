package julio.tactics.regras.GURPS
{
	import away3d.core.utils.ValueObject;
	import flash.utils.describeType;
	import julio.tactics.regras.GURPS.batalha.ObjetoAtivo;
	import julio.tactics.regras.GURPS.enuns.*;
	import julio.tactics.regras.GURPS.*;
	import julio.tactics.regras.GURPS.IA.Gambit;
	import julio.tactics.regras.GURPS.Personagens.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public final class Personagem2 extends ObjetoAtivo
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
		private var _tamanho:ETamanho;
//		private var _altura:Number;
//		private var _peso:Number;		// em kg
		
		// Atributos Primarios
		private var _ST:int;				// Força
		private var _DX:int;				// Dextreza
		private var _IQ:int;				// Inteligência
		private var _HT:int;				// Vitalidade
		
		
		
/*		// Atributos Secundários
		private var _fadiga:int;
		private var _pontosDeVida:int;
		private var _danoBasicoBAL:Dano;
		private var _danoBasicoGDP:Dano;
		
		private var _velocidade:int;
		private var _deslocamento:int;
		
		private var _cargaNenhuma:int;
		private var _cargaLeve:int;
		private var _cargaMedia:int;
		private var _cargaPesada:int;
		private var _cargaMPesada:int;
		
		private var _aparar:int;
		private var _bloquear:int;
		private var _esquivar:int;
*/
		
		private var _danoBasicoBAL:Dados;
		private var _danoBasicoGDP:Dados;
		
		private var _danoAcumulado:uint;		// total de dano levada pelo personagem atualmente
		private var _fadigaGasta:uint;			// fadiga q foi gasta pelo personagem
		private var _esquivasGastas:uint;		// Numero de esquivas realizadas pelo personagem desde o ultumo turno
		private var _bloqueiosGastos:uint;		// Numero de bloqueios realizados pelo personagem desde o ultumo turno
		private var _apararGastos:uint;			// Numero de aparar realizadas pelo personagem desde o ultumo turno
		
		
		// Atributos modificados pelas vantagens, desvantagens, buffs, debuffs, etc
		private var _finalST:int;
		private var _finalDX:int;
		private var _finalIQ:int;
		private var _finalHT:int;
		private var _finalFadiga:int;			// *Valor Máximo
		private var _finalPontosDeVida:int;		// *Valor Máximo
		private var _finalDanoBAL:Dados;
		private var _finalDanoGDP:Dados;
		private var _finalVelocidade:int;
		private var _finalDeslocamento:int;
		private var _finalCargaNenhuma:int;
		private var _finalCargaLeve:int;
		private var _finalCargaMedia:int;
		private var _finalCargaPesada:int;
		private var _finalCargaMPesada:int;
		private var _finalAparar:int;
		private var _finalBloquear:int;
		private var _finalEsquivar:int;
		private var _finalNumAparar:int;		// Numero de vezes q o personagem pode aparar por tuno com arma equipada
		private var _finalNumBloquear:int;
		private var _finalNumEsquivar:int;
		private var _finalReacao:int;
		private var _finalAcerto:int;
		private var _finalListaAcoes:XML;		// Lista de ações disponiveis ao personagem
		private var _finalMoveType:MoveType;	// Tipo de movimento do personagem
		
		// Lista de modificadores de atributos
		private var _modST:Array;
		private var _modDX:Array;
		private var _modIQ:Array;
		private var _modHT:Array;
		private var _modFadiga:Array;
		private var _modPontosDeVida:Array;
		private var _modDanoBAL:Array;
		private var _modDanoGDP:Array;
		private var _modVelocidade:Array;
		private var _modDeslocamento:Array;
		private var _modCarga:Array;
		private var _modAparar:Array;
		private var _modBloquear:Array;
		private var _modEsquivar:Array;
		private var _modNumAparar:Array;
		private var _modNumBloquear:Array;
		private var _modNumEsquivar:Array;
		private var _modReacao:Array;
		private var _modAcerto:Array;
		private var _modListaAcoes:Array;
		private var _modMoveType:Array;
		
		// Flag de defesa total
		private var _defesaTotal:Boolean;
		
		// Vantagens / Desvantagens
		private var _vantagens:Array;
		private var _desvantagens:Array;
		
		// Iventário
		private var _iventario:Array;		// Array de itens sendo carregados pelo personagem (obs.: nao incluem os itens equipados!!!)
		private var _arma:Arma;				// Arma atualmente equipada (null para nenhum)
		private var _escudo:Escudo;			// Escudo atualmente equipadr (null para nenhum)
		private var _armadura:Armadura;		// Armadura atualmente equipado (null para nenhum)
		
		// Pericias
		private var _pericias:Object;
		private var _periciaCombateDesarmado:Object;
		
		// Magias
		private var _grimorio:Array;		// Lista de magias conhecidas do personagem
		
		// Resistências
		private var _resistenciasDanoMultipicador:Object;	// Esses valores sao multiplicados ao dano
		private var _resistenciasDanoSomador:Object;		// esses valores sao somados ao dano
		
		
		
		// Variaveis de controle do turno do personagem
		private var _acaoMovimento:Boolean;
		private var _acaoPadrao:Boolean;
		private var _acaoMenor:Boolean;
		private var _acaoLivre:Boolean;
		
		// status
		private var _status:Array;				// Array de Status do personagem, positivos ou negativos
		
		
		// Parametros da Intelgencia Artificial (Gambit FF12 copy)
		private var _gambits:Array;
		private var _numGambits:uint;
		
		
		// Variáveis de combate
//		public var iniciativa:Number;
//		public var realInit:Number;
//		public var teamID:String;
//		public var ID:String;
//		public var idPos:String;
		
		
		public function Personagem( nome:String = "Unknow", ST:int = 10, DX:int = 10, IQ:int = 10, HT:int = 10 )
		{
			this._nome = nome;
//			this._altura = 1.80;
			this._tamanho = ETamanho.Medio;
//			this._peso = 80;
			
//			this._basicMoveType = new MoveType( EMove.WALK );
			
			this._ST = ST;
			this._DX = DX;
			this._IQ = IQ;
			this._HT = HT;
			
			this._iventario = new Array; // TODO: Classe especifica e mais prática soh pra o inventário
			this._arma = null;
			this._escudo = null;
			this._armadura = null;
			
			
			this._gambits = new Array;
			this._numGambits = 5;
			
			// tabela de magias conhecidas do persongem
			this._grimorio = new Array;
			
			// tabela de pericias do persongem
			this._pericias = new Object;
			
			this._resistenciasDanoMultipicador = new Object;
			this._resistenciasDanoSomador = new Object;
			
			// Cria a tabela de multiplicador de tipo de dano do personagem
			var def2:XML = describeType(EDano);
			var props2:XMLList = def2..constant.@name;
			for each (var prop2:String in props2)
			{
				this._resistenciasDanoMultipicador[prop2] = 1.0;
			}
			this._resistenciasDanoMultipicador[EDano.BAL] = 1.5;	// Dano de BAL recebe um bonus de 50%
			this._resistenciasDanoMultipicador[EDano.GDP] = 2.0;	// Dano de GDP recebe um bonus de 100%
			this._resistenciasDanoMultipicador[EDano.HEAL] = -1.0;	// dano de cura soma ao invés de diminuir HP
			
			var def3:XML = describeType(EDano);
			var props3:XMLList = def3..constant.@name;
			for each (var prop3:String in props3)
			{
				this._resistenciasDanoSomador[prop3] = 0;
			}
			
			this._finalST = 0;
			this._finalDX = 0;
			this._finalIQ = 0;
			this._finalHT = 0;
			
			this._finalFadiga = 0;
			this._finalPontosDeVida = 0;
			
			this._finalDanoBAL = new Dados;
			this._finalDanoGDP = new Dados;
			
			this._finalVelocidade = 0;
			this._finalDeslocamento = 0;
			this._finalCargaNenhuma = 0;
			this._finalCargaLeve = 0;
			this._finalCargaMedia = 0;
			this._finalCargaPesada = 0;
			this._finalCargaMPesada = 0;
			this._finalAcerto = 0;
			this._finalAparar = 0;
			this._finalBloquear = 0;
			this._finalEsquivar = 0;
			this._finalNumEsquivar = 0;
			this._finalNumAparar = 0;
			this._finalNumBloquear = 0;
			this._finalReacao = 0;
			this._finalListaAcoes = <acoes/>;
			
			this._defesaTotal = false;
			
			restauraAcoes();
		}
		
		
		
		public function refresh():void
		{
			// essa função caucula os valores finais dos atributos primario
			// e secundários do personagem
			// pega a lista de vantagens e desvantagens e aplica aos atributos do personagem
			// pega a lista de pericias e aplica aos atributos do personagem
			
			// 1º: alterar os atributos primarios
			// 2º: alterar os atributos secundários
			// 3º: gerar lista de ações do prsonagem
			
			refreshST();
			refreshDX();
			refreshIQ();
			refreshHT();
			
			refreshFadiga();
			refreshPontosDeVida();
			
			refreshVelocidade();
			refreshDeslocamento();
			
			refreshCarga();
			refreshDanoBAL();
			refreshDanoGDP();
			
			refreshAcerto();
			refreshAparar();
			refreshBloquear();
			refreshEsquivar();
			
			refreshNumAparar();
			refreshNumBloquear();
			refreshNumEsquivar();
			
			refreshReacao();
			
			refreshListaAcoes();
			refreshMoveType();
		}
		
		
		public function refreshST():void
		{
			this._finalST = this._ST;
			for each( var modST:IModST in this._modST )
				this._finalST += modST.ModST(this);
		}
		
		public function refreshDX():void
		{
			this._finalDX = this._DX;
			for each( var modDX:IModDX in this._modDX )
				this._finalDX += modDX.ModDX(this);
		}
		
		public function refreshIQ():void
		{
			this._finalIQ = this._IQ;
			for each( var modIQ:IModIQ in this._modIQ )
				this._finalIQ += modIQ.ModIQ(this);
		}
		
		public function refreshHT():void
		{
			this._finalHT = this._HT;
			for each( var modHT:IModHT in this._modHT )
				this._finalHT += modHT.ModHT(this);
		}
		
		public function refreshFadiga():void
		{
			this._finalFadiga = this._finalST;
			for each( var modFadiga:IModFadiga in this._modFadiga )
				this._finalFadiga += modFadiga.ModFadiga(this);
		}
		
		public function refreshPontosDeVida():void
		{
			this._finalPontosDeVida = this._finalHT;
			for each( var modPontosDeVida:IModPontosDeVida in this._modPontosDeVida )
				this._finalPontosDeVida += modPontosDeVida.ModPontosDeVida(this);
		}
		
		public function refreshVelocidade():void
		{
			this._finalVelocidade = (this._finalDX + this._finalHT)/4;
			for each( var modVelocidade:IModVelocidade in this._modVelocidade )
				this._finalVelocidade += modVelocidade.ModVelocidade(this);
		}
		
		public function refreshDeslocamento():void
		{
			this._finalDeslocamento = this._finalVelocidade;
			for each( var modDeslocamento:IModDeslocamento in this._modDeslocamento )
				this._finalDeslocamento += modDeslocamento.ModDeslocamento(this);
		}
		
		public function refreshDanoBAL():void
		{
			this._finalDanoBAL = damageBAL[this._finalST];
			for each( var modDanoBAL:IModDanoBAL in this._modDanoBAL )
				this._finalDanoBAL.add( modDanoBAL.ModDanoBAL(this) );
		}
		
		public function refreshDanoGDP():void
		{
			this._finalDanoGDP = damageGDP[this._finalST];
			for each( var modDanoGDP:IModDanoGDP in this._modDanoGDP )
				this._finalDanoGDP.add( modDanoGDP.ModDanoGDP(this) );
		}
		
		public function refreshCarga():void
		{
			var _finalCarga:Number = this._finalST;
			for each( var modCarga:IModCarga in this._modCarga )
				_finalCarga += modCarga.ModCarga(this);
			
			this._finalCargaNenhuma = _finalCarga;
			this._finalCargaLeve = _finalCarga*2;
			this._finalCargaMedia = _finalCarga*3;
			this._finalCargaPesada = _finalCarga*6;
			this._finalCargaMPesada = _finalCarga*10;
		}
		
		public function refreshAparar():void
		{
			this._finalAparar = 0;
			
			if ( this.armaEquipada != null )
			{
				this._finalAparar += (this.DX + this._pericias[this.armaEquipada.pericia].NH) * this._pericias[this.armaEquipada.pericia].skill.apararBase;
			} else {
				this._finalAparar += (this.DX + this._periciaCombateDesarmado.NH) * this._periciaCombateDesarmado.skill.apararBase;
			}
			
			for each( var modAparar:IModAparar in this._modAparar )
				this._finalAparar = modAparar.ModAparar(this);
		}
		
		public function refreshBloquear():void
		{
			this._finalBloquear = 0;
			
			if ( this.escudoEquipado != null )
			{
				this._finalBloquear += (this.DX + this._pericias[this.escudoEquipado.pericia].NH) * this._pericias[this.escudoEquipado.pericia].skill.bloquearBase;
			}
			
			for each( var modBloquear:IModBloquear in this._modBloquear )
				this._finalBloquear = modBloquear.ModBloquear(this);
		}
		
		public function refreshEsquivar():void
		{
			this._finalEsquivar = this._finalVelocidade;
			for each( var modEsquivar:IModEsquivar in this._modEsquivar )
				this._finalEsquivar += modEsquivar.ModEsquivar(this);
		}
		
		public function refreshReacao():void
		{
			this._finalReacao = 0;
			for each( var modReacao:IModReacao in this._modReacao )
				this._finalReacao += modReacao.ModReacao(this);
		}
		
		public function refreshListaAcoes():void
		{
			this._finalListaAcoes = <acoes/>;
			
			if ( this.armaEquipada != null )
			{
				if( this.armaEquipada.GDP != null )
					this._finalListaAcoes.appendChild(<acao id="2"/>);
				if( this.armaEquipada.BAL != null )
					this._finalListaAcoes.appendChild(<acao id="3"/>);
			}
			
			for each( var modListaAcoes:IModListaAcoes in this._modListaAcoes )
				this._finalListaAcoes.appendChild(modListaAcoes.ModListaAcoes(this));
		}
		
		public function refreshMoveType():void
		{
			this._finalMoveType = this.baseMoveType;
			for each( var modMoveType:IModMoveType in this._modMoveType )
				this._finalMoveType = modMoveType.ModMoveType(this);
		}
		
		public function refreshAcerto():void
		{
			this._finalAcerto = this.DX;
			
			if ( this.armaEquipada != null )
			{
				this._finalAcerto += this._pericias[this.armaEquipada.pericia].NH;
				
			} else {
				this._finalAcerto += this._periciaCombateDesarmado.NH;
			}
			
			// TODO: calcular acerto baseado na pericia da arma equipada atualmente no personagem
			for each( var modAcerto:IModAcerto in this._modAcerto )
				this._finalAcerto += modAcerto.ModAcerto(this);
		}
		
		public function refreshNumAparar():void
		{
			this._finalNumAparar = 2;
			for each( var modNumAparar:IModNumAparar in this._modNumAparar )
				this._finalNumAparar += modNumAparar.ModNumAparar(this);
		}
		
		public function refreshNumBloquear():void
		{
			this._finalNumBloquear = 2;
			for each( var modNumBloquear:IModNumBloquear in this._modNumBloquear )
				this._finalNumBloquear += modNumBloquear.ModNumBloquear(this);
		}
		
		public function refreshNumEsquivar():void
		{
			this._finalNumEsquivar = 99;	// personagem pode esquivar infinitas vezes por turno, para impedir as esquivas do personagem basta colocar uma IModNumEsquivar para retornar -99
			for each( var modNumEsquivar:IModNumEsquivar in this._modNumEsquivar )
				this._finalNumEsquivar += modNumEsquivar.ModNumEsquivar(this);
		}
		
		// Caracteristicas físicas
		public function get nome():String { return this._nome; }
//		public function get altura():Number { return this._altura; }
		public function get tamanho():ETamanho { return this._tamanho; }
//		public function get peso():Number { return this._peso; }
		
		
		// Atributos Básicos
		public function get base_ST():int { return this._ST; }
		public function get base_DX():int { return this._DX; }
		public function get base_IQ():int { return this._IQ; }
		public function get base_HT():int { return this._HT; }
//		public function get baseMoveType():MoveType	{ return this.baseMoveType; }
		
		public function get ST():int { return this._finalST; }
		public function get DX():int { return this._finalDX; }
		public function get IQ():int { return this._finalIQ; }
		public function get HT():int { return this._finalHT; }
		
		// Atributos Sencundários
		public function get fadiga():int		{ return this._finalFadiga; }
		public function get pontosVida():int	{ return this._finalPontosDeVida; }
		public override function get velocidade():Number	{ return this._finalVelocidade; }
		public override function get movimento():uint		{ return this._finalDeslocamento; }
		
		public function get danoBAL():Dados		{ return this._finalDanoBAL; }
		public function get danoGDP():Dados		{ return this._finalDanoGDP; }
		
		public function get cargaNenhuma():int	{ return this._finalCargaNenhuma; }
		public function get cargaLeve():int		{ return this._finalCargaLeve; }
		public function get cargaMedia():int	{ return this._finalCargaMedia; }
		public function get cargaPesada():int	{ return this._finalCargaPesada; }
		public function get cargaMPesada():int	{ return this._finalCargaMPesada; }
		
		public function get acerto():int		{ return this._finalAcerto; }
		public function get aparar():int		{ return this._finalAparar }
		public function get bloquear():int		{ return this._finalBloquear; }
		public function get esquivar():int		{ return this._finalEsquivar; }
		
		public function get numAparar():int		{ return this._finalNumAparar }
		public function get numBloquear():int	{ return this._finalNumBloquear; }
		public function get numEsquivar():int	{ return this._finalNumEsquivar; }
		
		public function get reacao():int		{ return this._finalReacao; }
		public function get listaAcoes():XML	{ return this._finalListaAcoes; }
		public override function get moveType():MoveType	{ return this._finalMoveType; }
		
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
		
		// resistencias
		public function get resistenciasDanoMultipicador():Object { return this._resistenciasDanoMultipicador; }
		public function get resistenciasDanoSomador():Object { return this._resistenciasDanoSomador; }
		
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
		
		public function get PV_Atual():int
		{
			return this.pontosVida - this._danoAcumulado;
		}
		
		public function get PV_porcentagem():Number
		{
			return this.PV_Atual / this.pontosVida;
		}
		
		
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
		
		
		
		
		
		public function toString():String
		{
			return "{Personagem: " + this._nome + "}";
		}
	}
}
