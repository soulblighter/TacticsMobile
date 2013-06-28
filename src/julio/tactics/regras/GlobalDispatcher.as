package julio.tactics.regras
{
  	import flash.events.EventDispatcher;
 	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
  	public class GlobalDispatcher
	{
    	protected static var disp:EventDispatcher;
		
		public static function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
		{
      		if (disp == null) { disp = new EventDispatcher(); }
      		disp.addEventListener(type, listener, useCapture, priority, useWeakReference);
      	}
		
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			if (disp == null) { return; }
      		disp.removeEventListener(type, listener, useCapture);
      	}
		
		public static function dispatchEvent(event:Event):void
		{
      		if (disp == null) { return; }
      		disp.dispatchEvent(event);
      	}
		
		public static function get dispatcher():EventDispatcher { return disp; }
    }
}
