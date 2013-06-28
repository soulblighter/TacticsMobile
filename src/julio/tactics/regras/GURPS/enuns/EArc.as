package julio.tactics.regras.GURPS.enuns
{
	import julio.enum.*;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class EArc extends EEnum
	{
    	{initEnum(EArc);} // static ctor
		
    	public static const SIMPLE		:EArc = new EArc();		// andar
    	public static const HJUMP		:EArc = new EArc();		// pular para uma altura mais elevada
    	public static const DJUMP		:EArc = new EArc();		// pular para um bloco mais distante
	}
}
