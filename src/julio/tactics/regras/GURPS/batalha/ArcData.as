package julio.tactics.regras.GURPS.batalha
{
	import julio.tactics.regras.GURPS.enuns.EArc;
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class ArcData
	{
		public var type:EArc;
		public var value:int;
		
		public function ArcData( type:EArc, value:int = 0 )
		{
			this.type = type;
			this.value = value;
		}
	}
}
