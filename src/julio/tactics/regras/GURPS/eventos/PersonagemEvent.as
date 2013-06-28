package julio.tactics.regras.GURPS.eventos
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class PersonagemEvent extends Event
	{
		// eventos do começo do turno do personagem
		public static const ONGOING_DAMAGE:String = "ONGOING_DAMAGE";	// dano que ocorrem de tempos em tenpos como veneno, burning, bleeding
		public static const REGENERATION:String = "REGENERATION";		// cura q ocorrem de tempos em tempos
		public static const NEW_STATUS:String = "NEW_STATUS";			// um novo buff ou debuf foi colocano no personagem
		public static const END_STATUS:String = "END_STATUS";			// um buff ou debuf perdeu o efeito
		
		public static const DEATH:String = "DEATH";		// personagem morreu
		public static const FALL:String = "FALL";		// personagem caiu do penhasco
		public static const PRONE:String = "PRONE";		// personagem caiu no chão
		
		private var _data:XML;			// dados extras
		
		public function PersonagemEvent( type:String, data:XML = <data/>, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
			this._data = data;
		}
		
		public override function clone():Event
		{
			return new PersonagemEvent( type, bubbles, cancelable );
		}
		
		public override function toString():String
		{
			return formatToString( "PersonagemEvent", "type", "bubbles", "cancelable", "eventPhase" );
		}
		
		public function get data():XML { return this._data; }
	}
}
