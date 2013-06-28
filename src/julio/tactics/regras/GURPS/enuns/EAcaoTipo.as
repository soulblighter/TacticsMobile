package julio.tactics.regras.GURPS.enuns
{
	import julio.enum.*;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class EAcaoTipo extends EEnum
	{
    	{initEnum(EAcaoTipo);} // static ctor
		
    	public static const STD		:EAcaoTipo = new EAcaoTipo();
    	public static const MOV		:EAcaoTipo = new EAcaoTipo();
    	public static const MIN		:EAcaoTipo = new EAcaoTipo();
    	public static const FREE	:EAcaoTipo = new EAcaoTipo();
	}
}
