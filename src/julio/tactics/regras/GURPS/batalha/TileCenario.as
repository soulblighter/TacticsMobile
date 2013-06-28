package julio.tactics.regras.GURPS.batalha
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class TileCenario extends ObjetoCenario
	{
		public var h:int;
		
		public function TileCenario( h:int )
		{
			this.h = h;
		}
		
		public override function canPass( o:ObjetoCenario ):Boolean { return true; }
		public override function canStay( o:ObjetoCenario ):Boolean { return true; }
		
		public override function get altura():Number { return h; }
		public override function get peso():Number { return altura*100; }
	}
}
