package julio.tactics.regras.GURPS
{
	import julio.tactics.regras.GURPS.enuns.ETile;
	import julio.tactics.regras.GURPS.enuns.EMove;
	import flash.utils.describeType;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class MoveType
	{
		public static const NULL:MoveType = new MoveType(EMove.NULL);
		public static const FLOAT:MoveType = new MoveType(EMove.FLOAT);
		public static const FLOAT_FLY:MoveType = new MoveType(EMove.FLOAT_FLY);
		public static const FLOAT_WARP:MoveType = new MoveType(EMove.FLOAT_WARP);
		public static const FLY:MoveType = new MoveType(EMove.FLY);
		public static const WALK:MoveType = new MoveType(EMove.WALK);
		public static const WARP:MoveType = new MoveType(EMove.WARP);
		
		public var type:EMove;
		
		public var modTerreno:Object;	// Custo de movimento no determinado terreno
		
		public var maxJumpUp:uint;		// Pulo maximo para cima
		public var maxJumpDown:uint;	// pulo maximo para baixo
		public var maxJumpD:uint;		// pulo maximo para frente
		
		public var onWater:Boolean;		// se pode andar sobre agua
		public var underWater:Boolean;	// se pode nadar
		
		public var onLava:Boolean;		// se pode andar sobre lava
		public var underLava:Boolean;	// se pode nadar na lava
		
		function MoveType( type:EMove )
		{
			this.modTerreno = new Object;
			setBasic(type);
		}
		
		public function setBasic( type:EMove ):void
		{
			var def:XML;
			var props:XMLList;
			var prop:String;
			
			switch( type )
			{
				case EMove.WALK:
					this.type = type;
					
					def = describeType(ETile);
					props = def..constant.@name;
					for each (prop in props)
					{
						this.modTerreno[prop] = 1.0;
					}
					
					this.maxJumpD = 1;
					this.maxJumpUp = 1;
					this.maxJumpDown = 2;
					
					this.onWater = false;
					this.underWater = true;
					
					this.onLava = false;
					this.underLava = false;
					break;
				
				case EMove.FLOAT:
					this.type = type;
					
					def = describeType(ETile);
					props = def..constant.@name;
					for each (prop in props)
					{
						this.modTerreno[prop] = 1.0;
					}
					
					this.maxJumpD = 2;
					this.maxJumpUp = 1;
					this.maxJumpDown = 3;
					
					this.onWater = true;
					this.underWater = false;
					
					this.onLava = true;
					this.underLava = false;
					break;
				
				case EMove.FLY:
					this.type = type;
					
					def = describeType(ETile);
					props = def..constant.@name;
					for each (prop in props)
					{
						this.modTerreno[prop] = 1.0;
					}
					
					this.maxJumpD = 99;
					this.maxJumpUp = 99;
					this.maxJumpDown = 99;
					
					this.onWater = false;
					this.underWater = true;
					
					this.onLava = false;
					this.underLava = false;
					break;
				
				case EMove.WARP:
					this.type = type;
					
					def = describeType(ETile);
					props = def..constant.@name;
					for each (prop in props)
					{
						this.modTerreno[prop] = 1.0;
					}
					
					this.maxJumpD = 99;
					this.maxJumpUp = 99;
					this.maxJumpDown = 99;
					
					this.onWater = false;
					this.underWater = false;
					
					this.onLava = false;
					this.underLava = false;
					break;
				
				case EMove.FLOAT_FLY:
					this.type = type;
					
					def = describeType(ETile);
					props = def..constant.@name;
					for each (prop in props)
					{
						this.modTerreno[prop] = 1.0;
					}
					
					this.maxJumpD = 99;
					this.maxJumpUp = 99;
					this.maxJumpDown = 99;
					
					this.onWater = true;
					this.underWater = false;
					
					this.onLava = true;
					this.underLava = false;
					break;
				
				case EMove.FLOAT_WARP:
					this.type = type;
					
					def = describeType(ETile);
					props = def..constant.@name;
					for each (prop in props)
					{
						this.modTerreno[prop] = 1.0;
					}
					
					this.maxJumpD = 99;
					this.maxJumpUp = 99;
					this.maxJumpDown = 99;
					
					this.onWater = true;
					this.underWater = false;
					
					this.onLava = true;
					this.underLava = false;
					break;
				
				case EMove.NULL:
					this.type = type;
					
					def = describeType(ETile);
					props = def..constant.@name;
					for each (prop in props)
					{
						this.modTerreno[prop] = 0.0;
					}
					
					this.maxJumpD = 0;
					this.maxJumpUp = 0;
					this.maxJumpDown = 0;
					
					this.onWater = false;
					this.underWater = false;
					
					this.onLava = false;
					this.underLava = false;
					break;
			}
		}
	}
}
