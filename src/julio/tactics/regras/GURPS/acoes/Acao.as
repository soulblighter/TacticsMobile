package julio.tactics.regras.GURPS.acoes
{
	import julio.tactics.regras.GURPS.Dados;
	import julio.tactics.regras.GURPS.Dano;
	import julio.tactics.regras.GURPS.enuns.*;
	import julio.tactics.regras.GURPS.MoveType;
	import julio.tactics.regras.GURPS.Personagens.*;
	import julio.tactics.regras.GURPS.Personagem;
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class Acao
	{
		/*
		 * 	Tipos de ações
		 * 	Ataque -	MeleeAttack ( damateType BAL or GDP )	-> ataque fisico proximo
		 * 				Ranged									-> projetil com percurso com curva
		 * 				Project									-> prejetil direto (sem curvas)
		 *	Magic		Magic									-> magia
		 * 				ProjectMagic							-> Projetil magico
		 * 				Move ( moveType Walk, Fly or Teleport )	-> movimento
		 *
		 * 0	Null
		 * 1	EndTurn
		 * 2	Wait
		 * 10	MeleeBAL
		 * 11	MeleeGDP
		 * 12	Punch			(unhanded GDP)
		 * 13	Kick			(unhanded BAL)
		 * 20	Ranged			(bow)
		 * 21	Project			(crossbow)
		 * 30	Magic			(basic magics)
		 * 31	ProjectMagic	(adaga de gelo, etc)
		 * 30	Move			(ver se eh necessário todas essas ações de movimento ou usar somente uma com parametros diferentes)
		 * 31	Fly
		 * 32	Teleport
		 *
		 * */
		
		
//		private var _id:String;					// identificação única
		private var _nome:String;
		private var _classe:EAcao;
		private var _tipoAcao:EAcaoTipo;
//		private var _tipoAlcance:EAcaoAlcance;
		private var _magico:Boolean;
		private var _alcance:uint;				// alcance do ataque
		private var _area:uint;					// area do ataque
		private var _movetypeAlcance:MoveType;
		private var _movetypeArea:MoveType;
		
//		private var _selecao:XML;				// xml q descreve como a ação seleciona os alvos
//		private var _execucao:XML;				// xml q descreve como a ação deve ser executada
		
		public function Acao( /*id:String,*/ nome:String, tipoAcao:EAcaoTipo, classe:EAcao, magico:Boolean, alcance:uint, area:uint, movetypeAlcance:MoveType, movetypeArea:MoveType )
		{
//			this._id = id;
			this._nome = nome;
			this._classe = classe;
			this._tipoAcao = tipoAcao;
//			this._tipoAlcance = tipoAlcance;
			this._magico = magico;
			this._alcance = alcance;
			this._area = area;
			this._movetypeAlcance = movetypeAlcance;
			this._movetypeArea = movetypeArea;
//			this._selecao = <select/>;
//			this._execucao = <execucao/>;
		}
		
//		public function get id():String { return this._id; }
//		public function set id(value:String):void { this._id = value; }
		
		public function get nome():String { return this._nome; }
		public function set nome(value:String):void { this._nome = value; }
		
		public function get tipoAcao():EAcaoTipo { return this._tipoAcao; }
		public function set tipoAcao(value:EAcaoTipo):void { this._tipoAcao = value; }
		
//		public function get tipoAlcance():EAcaoAlcance { return this._tipoAlcance; }
//		public function set tipoAlcance(value:EAcaoAlcance):void { this._tipoAlcance = value; }
		
		public function get alcance():uint { return this._alcance; }
		public function get area():uint { return this._area; }
		
		public function get moveTypeAlcance():MoveType { return this._movetypeAlcance; }
		public function get moveTypeArea():MoveType { return this._movetypeArea; }
		
		
		// subject -> o personagem q faz a ação
		// objects -> alvo o alvos da ação (pode ser nulo se a ação eh pessoal i.e. soh afeta o proprio usuário
//		public function execute( subject:Personagem, objects:Array ):void //, any extra? yes: batalha:Batalha
//		{
//		}
	}
}
