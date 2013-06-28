package julio.tactics.regras.GURPS.enuns
{
	import julio.enum.*;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class ETile extends EEnum
	{
    	{initEnum(ETile);} // static ctor
		
    	public static const PLAIN		:ETile = new ETile();		// tile basico
    	public static const GRASS		:ETile = new ETile();		// com vegetação alta
    	public static const ROCK		:ETile = new ETile();		// pedregoso
    	public static const SAND		:ETile = new ETile();		// areia
    	public static const ICE			:ETile = new ETile();		// gelo
    	public static const WATER		:ETile = new ETile();		// água
    	public static const LAVA		:ETile = new ETile();		// lava
	}
}
