package julio.tactics.regras.Basic
{
	import julio.tactics.regras.GURPS.Dano;
	import julio.tactics.regras.GURPS.Dados;
	import julio.tactics.regras.GURPS.enuns.ETamanho;
	import julio.tactics.regras.GURPS.IA.Gambit;
	
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class Char
	{
		private var _nome:String;
		
		// Caracteristicas físicas
		private var _altura:Number;
//		private var _tamanho:ETamanho;
//		private var _peso:Number;			// em kg
		
		// Atributos Primarios
		private var _atk:uint;				// attack
		private var _def:uint;				// defense
		private var _spd:uint;				// speed
		private var _dex:uint;				// acerto
		private var _agi:uint;				// esquiva
		
		private var _hp:uint;				// hit points
		private var _init:Number;			// inciativa
		private var _danoAcumulado:uint;	// total damage received
		
		// Iventário
		private var _iventario:Array;		// Array de itens sendo carregados pelo personagem (obs.: nao incluem os itens equipados!!!)
//		private var _arma:Arma;				// Arma atualmente equipada (null para nenhum)
//		private var _escudo:Escudo;			// Escudo atualmente equipadr (null para nenhum)
//		private var _armadura:Armadura;		// Armadura atualmente equipado (null para nenhum)
		
		// Variáveis de combate
		private var _id:uint;
		private var _idTeam:uint;
		private var _idPos:uint;
		private var _tempInit:Number;
		
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
		
		public function Char( nome:String = "Unknow", atk:uint = 10, def:uint = 10, spd:uint = 10, hp:uint = 10, dex:uint = 10, agi:uint = 10, init:uint = 10 )
		{
			this._nome = nome;
			
			this._atk = atk;
			this._def = def;
			this._spd = spd;
			this._dex = dex;
			this._agi = agi;
			this._hp = hp;
			
			this._init = init;
			
			this._iventario = new Array; // TODO: Classe especifica e mais prática soh pra o inventário
//			this._arma = null;
//			this._escudo = null;
//			this._armadura = null;
			
			this._status = new Array;
			
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
		
		public function get atk():uint { return this._atk; }
		public function get def():uint { return this._def; }
		public function get spd():uint { return this._spd; }
		public function get hp():uint { return this._hp; }
		public function get dex():uint { return this._dex; }
		public function get agi():uint { return this._agi; }
		public function get init():Number { return this._init; }
		
		public function set atk(value:uint):void { this._atk = value; }
		public function set def(value:uint):void { this._def = value; }
		public function set spd(value:uint):void { this._spd = value; }
		public function set hp(value:uint):void { this._hp = value; }
		public function set dex(value:uint):void { this._dex = value; }
		public function set agi(value:uint):void { this._agi = value; }
		public function set init(value:Number):void { this._init = value; }
		
		// Atributos Sencundários
		public function get velocidade():Number	{ return spd; }
		public function get movimento():uint	{ return 3.0 + spd/10.0; }
		
		public function get HP_Atual():uint		{ return this.hp - this._danoAcumulado; }
		public function get HP_Porcentagem():Number	{ return this.HP_Atual / this.hp; }
		public function isDead():Boolean		{ return ( this.HP_Atual < 0 ); }
		
		public function get acerto():int		{ return this.dex; }
		public function get esquiva():int		{ return this.agi; }
		
		public function get danoBase():int		{ return this.atk; }
		
		// combate
		public function get id():uint { return this._id; }
		public function get idTeam():uint { return this._idTeam; }
		public function get idPos():uint { return this._idPos; }
		public function get tempInit():Number { return this._tempInit; }
		
		public function set id(value:uint):void { this._id = value; }
		public function set idTeam(value:uint):void { this._idTeam = value; }
		public function set idPos(value:uint):void { this._idPos = value; }
		public function set tempInit(value:Number):void { this._tempInit = value; }
		
/*		// Itens
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
*/

		
		public function getActions():Array
		{
			var acoes:Array = [];
			
			if ( acaoPadrao )
				acoes.push(0);
			if( acaoMovimento )
				acoes.push(1);
				
			return acoes;
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
			
			// diminui os PVs do dano aplicado
			this._danoAcumulado += danoFinal;
			
			return danoFinal;
		}
		
/*
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
*/
		
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
