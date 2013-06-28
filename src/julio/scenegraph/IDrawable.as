package julio.scenegraph
{
	import away3d.core.math.Number2D;
	import away3d.core.math.Number3D;
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public interface IDrawable
	{
		function draw( viewName:String ):void;

		function getDisplayObject( viewName:String ):DisplayObject;
		
		function get depthPoint_x():Number;
		function get depthPoint_y():Number;
		function get depthPoint_z():Number;
		function get regPoints():Number2D;
		function register( view:IViewport ):void;
		function unregister( view:IViewport ):void;
		function get displayType():Class;
		function get onlyDefaultRender():Boolean;
		function get renderPriority():uint;
	}
}