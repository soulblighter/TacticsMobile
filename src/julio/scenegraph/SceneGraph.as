package julio.scenegraph
{
	import away3d.core.math.Matrix3D;
	import away3d.core.math.Number2D;
	import away3d.core.math.Number3D;
	import away3d.core.math.Quaternion;
	import flash.display.Sprite;
//	import flash.display.DisplayObjectContainer;
	
	import julio.iso.*;
	import julio.scenegraph.*;
	//import julio.tactics.*;
	//import julio.tactics.cenas.*;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class SceneGraph
	{
		// Container q exibirá a imagem
		private var _container:Sprite;
		
		// Nó raiz da n-tree
		private var _root:Node;
		
		// visoes principal. as views sao as estruturas esparsas q sao utilizadas no culling
		private var _views:Array;
		
		public function SceneGraph( container:Sprite )
		{
			this.container = container;
			this._root = new Node( new Number3D, new Quaternion(0, 1, 0, 0), new Number3D, "root");
			this._views = new Array;
			addViewport( new SceneView( new Number2D(0, 0), new Number2D(0, 0), new Number2D(800, 600), "defaultView" ) );
		}
		
		public function get root():Node { return this._root; }
		
		public function get container():Sprite { return this._container; }
		public function set container( value:Sprite ):void { this._container = value; }
		
		public function get defaultView():IViewport { return this._views[0]; }
		public function getView( id:uint ):IViewport { return this._views[id]; }
		
		public function update( timeDelta:Number ):void
		{
			root.update( timeDelta, Matrix3D.IDENTITY );
		}
		
		public function addChildToName( nodeName:String, node:INode ):void
		{
			var temp:INode = this.root.searchChildNodeByName( nodeName );
			if ( temp != null )
			{
				temp.addChildNode( node );
			}
			else
				throw new Error("Node não exite em SceneGraph::addChildToName( " + nodeName + " ," + node + " ).");
		}
		
		public function addViewport( view:IViewport ):uint
		{
			var newSize:uint = this._views.push( view );
			container.addChild( view.sprite );
			return newSize-1;
		}
		
		public function addToAllViews( node:INode, recursive:Boolean = true ):void
		{
			for each( var v:IViewport in this._views )
				v.addNode( node, recursive );
		}

	}
}
