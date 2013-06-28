package julio.tactics.regras.GURPS.enuns
{
	import julio.enum.*;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class ETeste extends EEnum
	{
    	{initEnum(ETeste);} // static ctor
		
    	public static const MELEE			:ETeste = new ETeste();	// Ataques corpo-a-corpo como BAL, GDP
    	public static const RANGED_BOW		:ETeste = new ETeste(); // Ataques a distancia com arco
    	public static const CREATE_MAGIC	:ETeste = new ETeste(); // Teste de criar a magia
    	public static const SOCIAL			:ETeste = new ETeste(); // Testes sociais, como de reação
	}
}
