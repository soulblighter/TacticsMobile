package julio.tactics.regras.GURPS.enuns
{
	import julio.enum.EEnum;
	/**
	 * ...
	 * @author ...
	 */
	public class ESelectionType extends EEnum
	{
		{initEnum(ESelectionType); } // static ctor
		
		
		/* * == subject
		 * x == area de alcance
		 *
		 * 	  		*
		 *
		 * */
    	public static const AUTO		:ESelectionType = new ESelectionType();
		
		
		/* * == subject
		 * x == area de alcance
		 *
		 * 			x
		 * 			x
		 * 			x
		 * 	  x x x	* x x x
		 * 			x
		 * 			x
		 * 			x
		 *
		 * */
    	public static const LINE		:ESelectionType = new ESelectionType();
		
		/* * == subject
		 * x == area de alcance
		 *
		 * 			*
		 * 			x
		 * 			x
		 * 			x
		 *
		 * */
 //   	public static const DIRECTLINE		:ESelectionType = new ESelectionType();
		
		/* * == subject
		 * x == area de alcance
		 *
		 * 		  x
		 * 		x x x
		 * 	  x x x x x
		 * 	x x x * x x x
		 * 	  x x x x x
		 * 		x x x
		 * 		  x
		 *
		 * */
    	public static const SQUARE		:ESelectionType = new ESelectionType();
	}

}
