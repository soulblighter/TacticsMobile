package julio.tactics.regras.GURPS.batalha
{
	import julio.tactics.regras.GURPS.enuns.ETile;
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class TileData
	{
		public var x:int;
		public var y:int;
		public var z:int;
		public var h:uint;
		public var type:ETile;
		
		public function TileData( x:int, y:int, z:int, h:uint, type:ETile )
		{
			this.x = x;
			this.y = y;
			this.z = z;
			this.h = h;
			this.type = type;
		}
	}
}
