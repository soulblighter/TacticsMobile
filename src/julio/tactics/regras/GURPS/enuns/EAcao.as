package julio.tactics.regras.GURPS.enuns
{
	import julio.enum.*;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class EAcao extends EEnum
	{
    	{initEnum(EAcao);} // static ctor
		
    	public static const MELEE			:EAcao = new EAcao();
    	public static const RANGED			:EAcao = new EAcao();
    	public static const PROJECT			:EAcao = new EAcao();
    	public static const MAGIC			:EAcao = new EAcao();
    	public static const MAGIC_PROJECT	:EAcao = new EAcao();
    	public static const MOVE			:EAcao = new EAcao();
	}
}
