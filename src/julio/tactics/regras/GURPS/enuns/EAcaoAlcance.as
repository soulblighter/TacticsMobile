package julio.tactics.regras.GURPS.enuns
{
	import julio.enum.*;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class EAcaoAlcance extends EEnum
	{
    	{initEnum(EAcaoAlcance);} // static ctor
		
    	public static const MELEE			:EAcaoAlcance = new EAcaoAlcance();
    	public static const RANGED			:EAcaoAlcance = new EAcaoAlcance();
    	public static const CLOSE_BURST		:EAcaoAlcance = new EAcaoAlcance();
    	public static const CLOSE_BLAST		:EAcaoAlcance = new EAcaoAlcance();
    	public static const AREA_BURST		:EAcaoAlcance = new EAcaoAlcance();
    	public static const AREA_WALL		:EAcaoAlcance = new EAcaoAlcance();
	}
}
