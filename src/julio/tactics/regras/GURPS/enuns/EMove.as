package julio.tactics.regras.GURPS.enuns
{
	import julio.enum.*;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class EMove extends EEnum
	{
    	{initEnum(EMove);} // static ctor
		
    	public static const NULL		:EMove = new EMove();		// dont move
    	public static const WALK		:EMove = new EMove();		// andar
    	public static const FLY			:EMove = new EMove();		// voar
    	public static const FLOAT		:EMove = new EMove();		// flutuar
    	public static const WARP		:EMove = new EMove();		// teleportar
		
    	public static const FLOAT_FLY	:EMove = new EMove();		// flutuar+voar
    	public static const FLOAT_WARP	:EMove = new EMove();		// flutuar+teleportar
	}
}
