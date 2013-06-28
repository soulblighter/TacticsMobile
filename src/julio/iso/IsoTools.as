package julio.iso
{
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class IsoTools
	{
		public static function xFlaToIso(x:Number, y:Number):Number
		{
			return ( x/Math.cos( -0.46365 ) - y/Math.sin( -0.46365 ) ) / 2;
		}
		
		public static function yFlaToIso(x:Number, y:Number):Number
		{
			return ( - ( x/Math.cos( -0.46365 ) + y/Math.sin( -0.46365 ) ) ) / 2;
		}
		
		public static function iso2xFla(x:Number, y:Number, z:Number):Number
		{
			return xFla( xIso(x, y, z) );
		}
		
		public static function iso2yFla(x:Number, y:Number, z:Number):Number
		{
			return yFla( yIso(x, y, z) );
		}
		
		// Convert Flash X and Y and altitude coordinates to isometric X coordinate
		public static function xFla(x:Number):Number
		{
			return x;
		}
		
		// Convert Flash X and Y and altitude coordinates to isometric Y coordinate (actually Z, but I don't give a hoot)
		public static function yFla(y:Number):Number
		{
			return - y;
		}
		
		// Converte abissicas cartesianas em isometricas
		public static function xIso(x:Number, y:Number, z:Number):Number
		{
			return (x - z) * Math.cos( -(Math.PI/180*26.7) );	//0.46365
		}
		
		// Converte coordenadas cartesianas em isometricas
		public static function yIso(x:Number, y:Number, z:Number):Number
		{
			return y + (x + z) * Math.sin( -(Math.PI/180*26.7) );
		}
		
		public static function size2iso( x:Number, y:Number ):Number
		{
			return Math.sqrt( (x / 2) * (x / 2) + (y / 2) * (y / 2) );	// teorema de pitagoras (com metade dos lados)
		}	
		
		public static function boxHitTest(obj1:Box, obj2:Box):Boolean
		{
			if ((Math.abs((obj1.final_pos_x + obj1.size.x / 2) - (obj2.final_pos_x + obj2.size.x / 2)) < (obj1.size.x + obj2.size.x) / 2) &&
				(Math.abs((obj1.final_pos_y + obj1.size.y / 2) - (obj2.final_pos_y + obj2.size.y / 2)) < (obj1.size.y + obj2.size.y) / 2) &&
				(Math.abs((obj1.final_pos_z + obj1.size.z / 2) - (obj2.final_pos_z + obj2.size.z / 2)) < (obj1.size.z + obj2.size.z) / 2))
			{
				return true;
			}
			return false;
		}
	}
}