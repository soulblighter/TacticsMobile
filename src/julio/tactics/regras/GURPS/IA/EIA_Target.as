package julio.tactics.regras.GURPS.IA
{
	import julio.enum.*;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class EIA_Target extends EEnum
	{
    	{initEnum(EIA_Target);} // static ctor
		
    	public static const FOE			:EIA_Target = new EIA_Target();
    	public static const ALLY		:EIA_Target = new EIA_Target();
    	public static const SELF		:EIA_Target = new EIA_Target();
//    	public static const ALLY_SELF	:EIA_Target = new EIA_Target();
	}
}
