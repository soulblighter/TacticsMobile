package julio.iso
{
	import away3d.core.math.Matrix3D;
	import away3d.core.math.Number2D;
	import away3d.core.math.Number3D;
	import away3d.core.math.Quaternion;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.geom.*;
	import flash.display.*;
		
	import julio.iso.*;
	import julio.scenegraph.*;
	//import julio.tactics.*;
	//import julio.tactics.cenas.*;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class SceneView  implements IViewport
	{
		private var _viewName:String;	// Nome da visao
		
		private var _pos:Number2D;		// Posição de visualização
		private var _size:Number2D;		// Tamanho do viewport
		private var _sprite:Sprite;		// DisplayObjectContainer q guarda todos objetos visiveis
		
		private var _nodes:Array;		// Array dos objetos da view
		private var _square:Shape;		// Moldura preta para demarcar a view
		private var _scrollRect:Rectangle;	// Deslocação do ponto de visao
		
		public function SceneView( renderPos:Number2D, pos:Number2D, size:Number2D, viewName:String )
		{
			_pos = pos;
			_size = size;
			_viewName = viewName;
			
			_sprite = new Sprite;
			_sprite.x = renderPos.x;
			_sprite.y = renderPos.y;
			_nodes = new Array;
			_square = new Shape;
			
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [0xccccff, 0x3333cc];
			var alphas:Array = [1, 1];
			var ratios:Array = [0, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(800, 600, Math.PI/2);
			
			_square.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, "pad");
//			_square.graphics.beginFill(0xff00ff);
			_square.graphics.lineStyle( 4, 0x000000 );
			_square.graphics.moveTo( 0, 	0 );
			_square.graphics.lineTo( size.x,0 );
			_square.graphics.lineTo( size.x,size.y );
			_square.graphics.lineTo( 0, 	size.y );
			_square.graphics.lineTo( 0, 	0 );
			_square.graphics.endFill();
			_square.cacheAsBitmap = true;
			
			this._viewName = viewName;
			
			_scrollRect = new Rectangle(pos.x, pos.y, size.x, size.y);
			this._sprite.scrollRect = _scrollRect;
			sprite.cacheAsBitmap = true;
			
			clear();
		}
		
		public function get sprite():Sprite { return this._sprite; }
		public function get viewName():String { return this._viewName; }
		public function get size():Number2D { return this._size; }
		public function get x_pos():int { return this._pos.x; }
		public function get y_pos():int { return this._pos.y; }
		public function set x_pos( value:int ):void
		{
			this._pos.x = value;
			_scrollRect.x = _pos.x;
			_scrollRect.y = _pos.y;
			this._sprite.scrollRect = _scrollRect;
			_square.x = _pos.x;
			_square.y = _pos.y;
			sprite.cacheAsBitmap = true;
		}
		public function set y_pos( value:int ):void
		{
			this._pos.y = value;
			_scrollRect.x = _pos.x;
			_scrollRect.y = _pos.y;
			this._sprite.scrollRect = _scrollRect;
			_square.x = _pos.x;
			_square.y = _pos.y;
			sprite.cacheAsBitmap = true;
		}
		
		public function clear():void
		{
			// Remove todos os displayObjects da view
			while( _sprite.numChildren )
				this._sprite.removeChildAt(0);
			_nodes.splice(0);	// limpa a lista de profundidades
			
			_sprite.addChildAt( _square, 0 );
			
			_scrollRect.x = _pos.x;
			_scrollRect.y = _pos.y;
			this._sprite.scrollRect = _scrollRect;
			_square.x = _pos.x;
			_square.y = _pos.y;
		}
		
		public function contains( node:INode ):int
		{
			for (var i:int = 0; i < this._nodes.length; i++)
				if ( this._nodes[i].node == node )
					return i;
			return -1;
		}
		
//		public function newObjAdded( ve:ViewEvent ):void
//		{
//			trace(ve.target);
//		}
		
		public function addNode( node:INode, recursive:Boolean = true ):void
		{
//			trace("adding... ", node.nodeName );
			// verifica se o nó não jah estah na visao
			if( contains(node) == -1 )
				if ( node is IDrawable )	// verifica se o nó eh "desenhável"
				{
//					trace("\t", node.nodeName, " is drawable");
					
					// morph
					var d:IDrawable = node as IDrawable;
					
					// verifica se essa visao pode/deve exibir esse nó
					if (	(d.onlyDefaultRender && (this._viewName == "defaultView") ) ||
							(!d.onlyDefaultRender) )
					{
//						trace("\t", this.viewName, " can draw ", node.nodeName);
						// cria uma instancia do displayObject para exibir nessa view
						d.register( this );
						
						var o:Object = new Object;
						o.node = node;
						o.drawable = d;
						o.displayObj = d.getDisplayObject( this._viewName );
						o.depth = (o.drawable.depthPoint_x + o.drawable.depthPoint_z)*0.886 + o.drawable.depthPoint_y * 0.707;
						
						
						if (this._nodes.length == 0)
						{
//							trace("\t", node.nodeName, " addeded as first");
							this._nodes.push( o );
							this._sprite.addChild(o.displayObj);
						} else
							for (var i:int = 0; i < this._nodes.length; i++)
							{
								if ( o.depth < this._nodes[i].depth )
								{
//									trace("\t", node.nodeName, " addeded to ", i);
									this._nodes.splice(i, 0, o);
									this._sprite.addChildAt(o.displayObj, i+1);
									break;
								}
								// se chegou no final do vetor entao adiciona no final
								if ( i == this._nodes.length - 1 )
								{
//									trace("\t", node.nodeName, " addeded to end");
									this._nodes.push( o );
									this._sprite.addChild(o.displayObj);
									break;
								}
							}
					}
				}
			
			if( recursive )
				for each(var n:INode in node.childs)
					addNode( n, recursive );
		}
		
		// remove o nó da view
		public function removeNode( node:INode ):void
		{
			// verifica se a view contem o nó
			var index:int = contains(node);
			if ( index != -1 )
			{
				var d:IDrawable = node as IDrawable;
				
				// remove o elemento do displayObjectContainer
				this._sprite.removeChild(d.getDisplayObject(this.viewName));
				
				// deleta a instancia do displayObject do nó
				d.unregister( this );
				
				// remove o elemento do array de nós
				this._nodes.splice(index, 1);
			}
		}
		
		
		// ? mudar a propriedade "visible" para false dos objetos q estao fora do scrollRect (nao precisa, o scrollRect jah faz issu automaticament)
		// atualiaza a posição do objeto na view
		public function update( node:INode ):void
		{
			// verifica se a view contem o nó
			var index:int = contains(node);
			if ( index != -1 )
			{
				var o:Object = this._nodes[index];
				
				// recalcula depth
				o.depth = (o.drawable.depthPoint_x + o.drawable.depthPoint_z) * 0.886 + o.drawable.depthPoint_y * 0.707;
				
				this._nodes.sortOn("depth", Array.NUMERIC);
				
				for (var i:int = 0; i < _nodes.length; i++)
				{
					if( _nodes[i].displayObj != sprite.getChildAt(i+1) )
						sprite.setChildIndex( _nodes[i].displayObj, i+1 );
				}
			}
		}
		
		
/*
		
		public function clear():void
		{
			while( _sprite.numChildren )
				this._sprite.removeChildAt(0);
			_depths.splice(0);
//			_sprite.addChild( _square );
//			getDepth(99999);


			_scrollRect.x = _pos.x;
			_scrollRect.y = _pos.y;
			this._sprite.scrollRect = _scrollRect;
			_square.x = _pos.x;
			_square.y = _pos.y;
			
			registerNodes(_startNode);
		}
		
		public function update():void
		{
//			trace( "unsorted ", _depths.length );
			for each(var o:Object in _depths)
			{
				o.depth = (o.node.final_pos_x+o.drawable.depthPoints.x + o.node.final_pos_z+o.drawable.depthPoints.z) * 0.886 + o.node.final_pos_y+o.drawable.depthPoints.y * 0.707;
//				trace( o.node.nodeName, o.depth );
			}
			
			_depths.sortOn("depth", Array.NUMERIC);
			
//			trace( "sorted ", _depths.length );
//			for each(var o2:Object in _depths)
//			{
//				trace( o2.node.nodeName, o2.depth );
//			}
			
			for (var i:int = 0; i < _depths.length; i++)
			{
				if( sprite.numChildren > 0 )
					if( _depths[i].displayObj != sprite.getChildAt(i) )
						sprite.addChildAt( _depths[i].displayObj, i );
				else
					sprite.addChild( _depths[i].displayObj );
			}
			
			_sprite.addChildAt( _square, 0 );
		}
		
		public function registerNodes( node:INode, recursive:Boolean = true ):void
		{
//			trace( "testing node: ", node.nodeName );
			if ( node is IDrawable )
			{
//				trace( "node: ", node.nodeName, " is drawable" );

				var d:IDrawable = node as IDrawable;
				
				if (	(d.onlyDefaultRender && (this._viewName == "defaultView") ) ||
						(!d.onlyDefaultRender) )
				{
					test( node );
				}
			}
			
			if( recursive )
				for each(var n:INode in node.childs)
					registerNodes( n );
		}
		
		
		public function test( node:INode ):Boolean
		{
			if ( node is IDrawable )
			{
				var w:IDrawable = node as IDrawable;
				w.register( this );
//				var d:DisplayObject = w.getDisplayObject( this._viewName );
				
				var o:Object = new Object;
				o.node = node;
				o.drawable = w;
				o.displayObj = w.getDisplayObject( this._viewName );
				o.depth = (node.final_pos_x + node.final_pos_z)*0.886 - node.final_pos_y * 0.707;
				this._depths.push( o );
				
//				var depth:Number = (node.transformation.position.x + node.transformation.position.z)*0.886 - node.transformation.position.y * 0.707;
//				var depth_value:int = getDepth( depth ); // (node.transformation.position.x * 103) + (node.transformation.position.z * 100) + (node.transformation.position.y * 103) );
				
//				var depth_value:int = changeDepth( node );
//				sprite.addChildAt( d, depth_value );
				
//				trace( "added: ", node.nodeName, node.transformation.position.x, node.transformation.position.y, node.transformation.position.z, " - ", depth_value );
				return true;
			}
			return false;
		}
		
		// pega uma posição valida no indice de childs o DisplayObjectContainer
		private function getDepth( d:int ):int
		{
			for ( var a:int = 0; a < _depths.length; a++ )
			{
				if ( d < _depths[a] )
				{
					_depths.splice(a, 0, d);
					return a;
				}
			}
			_depths.push( d );
			return _depths.length - 1;
		}
		
		private function changeDepth( node:INode ):int
		{
			var o:Object = new Object;
			o.node = node;
			var w:IDrawable = node as IDrawable;
			o.displayObj = w.getDisplayObject( this._viewName );
			o.depth = w.renderPriority+1000 + (node.final_pos_x + node.final_pos_z)*0.886 - node.final_pos_y * 0.707;
			
			for ( var a:int = 0; a < _depths.length; a++ )
			{
				if ( o.depth < _depths[a] )
				{
					_depths.splice(a, 0, o);
					return a;
				}
			}
			_depths.push( o );
			return _depths.length - 1;
		}
		
		private function swapArrayElem( array:Array, a:int, b:int ):void
		{
			var temp:* = array[b];
			array[b] = array[a];
			array[a] = temp;
		}
		
		private function diffArray( array1:Array, array2:Array ):Array
		{
			var r:Array = new Array;
			if (array1.length == array2.length)
			{
				for ( var i:int = 0; i < array1.length; i++ )
				{
					r.push(0);
					if ( array1[i] != array2[i] )
					{
						r[i] = i;
					}
				}
			}
			return r;
		}
	*/
	}
}
