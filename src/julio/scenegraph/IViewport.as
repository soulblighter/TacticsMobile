package julio.scenegraph
{
	import away3d.core.math.Number2D;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public interface IViewport
	{
		function get viewName():String;
		
		function get size():Number2D;
		
		function get x_pos():int;
		function get y_pos():int;
		function set x_pos( value:int ):void;
		function set y_pos( value:int ):void;
		
		function get sprite():Sprite;
		
		function contains( node:INode ):int;
		
		function clear():void;
		
		function addNode( node:INode, recursive:Boolean = true ):void;
		function removeNode( node:INode ):void;
		function update( node:INode ):void;
	}
}