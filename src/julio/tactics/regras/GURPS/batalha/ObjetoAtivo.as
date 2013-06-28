package julio.tactics.regras.GURPS.batalha
{
	import julio.tactics.regras.GURPS.MoveType;
	import julio.tactics.regras.GURPS.enuns.EMove;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ObjetoAtivo extends ObjetoCenario
	{
		public var init:Number = 0;
		public var realInit:Number = 0;
		public var showInit:Boolean = true;
		public var canBePlayerControlled:Boolean = true;
		
		
		public var baseMoveType:MoveType = new MoveType( EMove.WALK );
		
		// dados sobre o movimento do personagem no cenário
		public function get moveType():MoveType { return baseMoveType; };
		public function get velocidade():Number { return 1.0; };
		public function get movimento():uint { return 1; };
	}
}
