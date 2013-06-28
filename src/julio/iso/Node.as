package julio.iso
{
	import flash.events.EventDispatcher;
	import away3d.core.math.Matrix3D;
	import away3d.core.math.Number3D;
	import away3d.core.math.Quaternion;
	
	import julio.iso.*;
	import julio.scenegraph.*;
	//import julio.tactics.*;
	//import julio.tactics.cenas.*;
	
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class Node implements INode
	{
		protected var _nodeName:String;			// nome do nó (alguma utilidade?)
		protected var _childs:Array;			// nós filhos
		protected var _parent:INode;			// Nó pai
		
		protected var _transformChanged:Boolean;	// Marca se eh necessario recalcula a matrix de transformação
		protected var _pos:Number3D;			// Posição
		protected var _scale:Number3D;			// Escala
		protected var _rot:Quaternion;			// Rotação
		protected var _rotX:Number;				// Rotação
		protected var _rotY:Number;				// Rotação
		protected var _rotZ:Number;				// Rotação
		protected var _rotAngle:Number;			// Rotação
		protected var _dir:Number3D;			// Direção
		protected var _size:Number3D;			// tamanho, BoundingBox
		protected var _transformation:Matrix3D;	// Matrix de transformação
		
		// variáveis temporárias para evitar a criação delas em Loops
		// evitando a chamada de garbage colector
		private var _tempMatrix:Matrix3D;
		private var _tempNode:INode
		
		
		public function Node( pos:Number3D, rot:Quaternion, size:Number3D, nodeName:String )
		{
			this._nodeName = nodeName;
			this._childs = new Array();
			this._dir = new Number3D(0, 0, 1);
			this._pos = pos;
			this._scale = new Number3D(1, 1, 1);
			this._rot = rot;
			this._size = size;
			this._transformation = new Matrix3D();
			this._transformation.clear();
			this._tempMatrix = new Matrix3D();
			this._transformChanged = true;
			
			this._rotX = 0.0;
			this._rotY = 1.0;
			this._rotZ = 0.0;
			this._rotAngle = 0.0;
		}
		
		// Locais
//		public function get local_pos():Number3D { return this._pos; }
//		public function set local_pos(value:Number3D):void { this._pos = value; this._transformChanged = true; }
		
		// posistion
		public function get local_pos_x():Number { return this._pos.x; }
		public function get local_pos_y():Number { return this._pos.y; }
		public function get local_pos_z():Number { return this._pos.z; }
		
		public function set local_pos_x(value:Number):void { this._pos.x = value; this._transformChanged = true; }
		public function set local_pos_y(value:Number):void { this._pos.y = value; this._transformChanged = true; }
		public function set local_pos_z(value:Number):void { this._pos.z = value; this._transformChanged = true; }
		public function set local_pos(value:Number3D):void { this._pos = value; this._transformChanged = true; }
		
		// scale
		public function get local_scale_x():Number { return this._scale.x; }
		public function get local_scale_y():Number { return this._scale.y; }
		public function get local_scale_z():Number { return this._scale.z; }
		
		public function set local_scale_x(value:Number):void { this._scale.x = value; this._transformChanged = true; }
		public function set local_scale_y(value:Number):void { this._scale.y = value; this._transformChanged = true; }
		public function set local_scale_z(value:Number):void { this._scale.z = value; this._transformChanged = true; }
		public function set local_scale(value:Number3D):void
		{
			this._scale = value; this._transformChanged = true;
		}
		
		public function zoom( x:Number, y:Number, z:Number ):void
		{
			local_scale_x = x;
			local_scale_y = y;
			local_scale_z = z;
			for each( var tempNode:Node in this._childs )
			{
				tempNode.zoom(x, y, z)
			}
		}
		
		// rotation
		public function get local_rot_x():Number { return this._rotX; }
		public function get local_rot_y():Number { return this._rotY; }
		public function get local_rot_z():Number { return this._rotZ; }
		public function get local_rot_angle():Number { return this._rotAngle; }
		
		public function set local_rot_x(value:Number):void { this._rotX = value; setLocal_rot(_rotX, _rotY, _rotZ, _rotAngle); }
		public function set local_rot_y(value:Number):void { this._rotY = value; setLocal_rot(_rotX, _rotY, _rotZ, _rotAngle); }
		public function set local_rot_z(value:Number):void { this._rotZ = value; setLocal_rot(_rotX, _rotY, _rotZ, _rotAngle); }
		public function set local_rot_angle(value:Number):void { this._rotAngle = value; setLocal_rot(_rotX, _rotY, _rotZ, _rotAngle); }

//		public function get local_rot():Quaternion { return this._rot; }
//		public function set local_rot(value:Quaternion):void { this._rot = value; var m:Matrix3D = new Matrix3D; m.quaternion2matrix(_rot); this._dir.transform(_dir, m); this._transformChanged = true; }
		public function setLocal_rot(x:Number, y:Number, z:Number, angle:Number):void
		{
			this._rotX = x; this._rotY = y; this._rotZ = z; this._rotAngle = angle;
			this._rot.axis2quaternion(x, y, z, angle); _tempMatrix.clear(); _tempMatrix.quaternion2matrix(_rot); this._dir.transform(_dir, _tempMatrix);
			this._transformChanged = true;
		}
		
		public function get local_dir_x():Number { return this._dir.x; }
		public function get local_dir_y():Number { return this._dir.y; }
		public function get local_dir_z():Number { return this._dir.z; }
		
		// Globais
		public function get final_pos_x():Number { return this._transformation.position.x; }
		public function get final_pos_y():Number { return this._transformation.position.y; }
		public function get final_pos_z():Number { return this._transformation.position.z; }
		
		public function get final_dir_x():Number { return this._transformation.forward.x; }
		public function get final_dir_y():Number { return this._transformation.forward.y; }
		public function get final_dir_z():Number { return this._transformation.forward.z; }
		
		public function get size():Number3D { return this._size; }
		public function set size(value:Number3D):void { this._size = value; }
		
		
		public function get nodeName():String { return this._nodeName; }
		public function get childs():Array { return this._childs; }
		
		public function get parent():INode { return this._parent; }
		public function set parent(value:INode):void
		{
			if(this._parent)
				this._parent.removeChildNode(this);
			this._parent = value;
			value.childs.push( this );
//			dispatchEvent( new ViewEvent( ViewEvent.NEW_ADDED ) );
		}
		
		// adiciona um filho e retorna seu indice
		public function addChildNode( child:INode ):void
		{
			child.parent = this;
		}
		
		// remove um nó filho
		public function removeChildNode( child:INode ):void
		{
			this._childs.slice( this._childs.indexOf( child ), 1 );
		}
		
		// remove um nó filho a partir do nome
		public function removeChildNodeByName( nome:String ):void
		{
			this._childs.slice( searchChildNodeByName( nome, false ) );
		}
		
		// atualiza o nó
		public function update( timeDelta:Number, parentTransformation:Matrix3D, parentChanged:Boolean = false, recursive:Boolean = true ):void
		{
			if (this._transformChanged == true || parentChanged == true)
			{
//				trace(this.nodeName);
	//			trace("\t", "timeDelta: ", timeDelta);
	//			trace("\t", "parentTransformation: ");
	//			trace(parentTransformation);
				
				// update...
				_transformation.clear();
				_transformation.clone(parentTransformation);
				
				_tempMatrix.clear();
				_tempMatrix.translationMatrix(_pos.x, _pos.y, _pos.z);
	//			trace("\t", "translation temp: ");
	//			trace(_tempMatrix);
				_transformation.multiply4x4(_transformation, _tempMatrix);
	//			trace("\t", "translation combined: ");
	//			trace(transformation);
				
				
				
				_tempMatrix.clear();
				_tempMatrix.scaleMatrix( _scale.x, _scale.y, _scale.z );
	//			trace("\t", "quaternion temp: ");
	//			trace(_tempMatrix);
				_transformation.multiply4x4(_transformation, _tempMatrix);
	//			trace("\t", "quaternion combined: ");
	//			trace(transformation);
				
				
				
				_tempMatrix.clear();
				_tempMatrix.quaternion2matrix( _rot );
	//			trace("\t", "quaternion temp: ");
	//			trace(_tempMatrix);
				_transformation.multiply4x4(_transformation, _tempMatrix);
	//			trace("\t", "quaternion combined: ");
	//			trace(transformation);
				
//				_transformation.multiply4x4(_transformation, parentTransformation);
	//			trace("\t", "translation final: ");
	//			trace(transformation);
				
				if( recursive ) // update os filhos
					for each( _tempNode in this._childs )
					{
						_tempNode.update(timeDelta, _transformation, true, recursive)
					}
				_transformChanged = false;
			} else
				if( recursive ) // update os filhos
					for each( _tempNode in this._childs )
					{
						_tempNode.update(timeDelta, _transformation, false, recursive)
					}
		}
		
		// conta a quantidade de filhos
		public function countChildNode( recursive:Boolean = true ):int
		{
			if(!recursive)
			{
				return(this._childs.length);
			}
			else
			{
				var val:int = this._childs.length;
				
				for each( _tempNode in this._childs )
				{
					val += _tempNode.countChildNode( true );
				}
				return(val);
			}
		}
		
		// procura um nó nos filhos a partir do nome
		public function searchChildNodeByName( searchName:String, recursive:Boolean = true ):INode
		{
			for each( var a:INode in this._childs )
			{
				if ( searchName == a.nodeName )
					return a;
				else if (recursive)
				{
					_tempNode = a.searchChildNodeByName( searchName, recursive );
					if ( _tempNode != null )
						return _tempNode;
				}
			}
			return null;
		}
	}
}
