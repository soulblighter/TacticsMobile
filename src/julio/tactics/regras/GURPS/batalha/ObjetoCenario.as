package julio.tactics.regras.GURPS.batalha
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class ObjetoCenario
	{
		public var ID:uint;
		public var teamID:String;
		public var idPos:uint;
		public var altura:Number = 1.8;
		public var peso:Number = 80;
		public var visible:Boolean = true;
		
		
		public function canPass( o:ObjetoCenario ):Boolean { return true }
		public function canStay( o:ObjetoCenario ):Boolean { return true }
		
//		public function get altura():Number { return 0 }
//		public function get peso():Number { return 0 }
	}
}
