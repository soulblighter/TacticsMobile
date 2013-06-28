package julio.iso.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class AnimationNodeEvent extends Event
	{
		public static const ANIMATION_END:String = "ANIMATION_END";
		
		public function AnimationNodeEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
		
		public override function clone():Event
		{
			return new AnimationNodeEvent( type, bubbles, cancelable );
		}
		
		public override function toString():String
		{
			return formatToString( "AnimationNodeEvent", "type", "bubbles", "cancelable", "eventPhase" );
		}
	}
}
	
