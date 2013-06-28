package julio.tactics.regras.GURPS.enuns
{
	import julio.enum.EEnum;
	
	/**
	 * ...
	 * @author ...
	 */
	public class EDefesaAtiva extends EEnum
	{
		{initEnum(EDefesaAtiva);} // static ctor
		
    	public static const ESQUIVA		:EDefesaAtiva = new EDefesaAtiva();
    	public static const APARAR		:EDefesaAtiva = new EDefesaAtiva();
    	public static const BLOQUEAR	:EDefesaAtiva = new EDefesaAtiva();
    	public static const MAGIC_BLOCK	:EDefesaAtiva = new EDefesaAtiva();
    	public static const MAGIC_EVADE	:EDefesaAtiva = new EDefesaAtiva();
	}
}
