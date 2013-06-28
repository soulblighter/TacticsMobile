package julio.scenegraph
{
	import away3d.core.math.Matrix3D;
	import away3d.core.math.Number3D;
	import away3d.core.math.Quaternion;

	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public interface INode 
	{
		function get childs():Array;
		
		// Locais
		function get local_pos_x():Number;
		function get local_pos_y():Number;
		function get local_pos_z():Number;
		
		function set local_pos_x(value:Number):void;
		function set local_pos_y(value:Number):void;
		function set local_pos_z(value:Number):void;
		function set local_pos(value:Number3D):void;
		
		function get local_rot_x():Number;
		function get local_rot_y():Number;
		function get local_rot_z():Number;
		function get local_rot_angle():Number;
		
		function set local_rot_x(value:Number):void;
		function set local_rot_y(value:Number):void;
		function set local_rot_z(value:Number):void;
		function set local_rot_angle(value:Number):void;
		
//		function set local_rot(value:Quaternion):void;
		function setLocal_rot(x:Number, y:Number, z:Number, angle:Number):void;
		
		function get local_dir_x():Number;
		function get local_dir_y():Number;
		function get local_dir_z():Number;
		
		// Globais
		function get final_pos_x():Number;
		function get final_pos_y():Number;
		function get final_pos_z():Number;

		function get final_dir_x():Number;
		function get final_dir_y():Number;
		function get final_dir_z():Number;
		
		function get size():Number3D;
		function set size(value:Number3D):void;
		
		function get parent():INode;
		function set parent(value:INode):void;
		function get nodeName():String;
		
		function addChildNode( child:INode ):void;
		function removeChildNode( child:INode ):void;
		function removeChildNodeByName( nome:String ):void;
		function update( timeDelta:Number, parentTransformation:Matrix3D, parentChanged:Boolean = false, recursive:Boolean = true ):void;
		function countChildNode( recursive:Boolean = true ):int;
		function searchChildNodeByName( searchName:String, recursive:Boolean = true ):INode;
	}
}