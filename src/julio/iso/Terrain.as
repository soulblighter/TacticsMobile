package julio.iso
{
	import away3d.core.math.Number3D;
	import away3d.core.math.Quaternion;
	import flash.utils.Dictionary;
	import julio.iso.*;
	import julio.scenegraph.*;
	import julio.tactics.*;
	import julio.tactics.regras.GURPS.batalha.*;
	import julio.tactics.regras.GURPS.enuns.ETile;
	
	//import julio.tactics.cenas.*;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class Terrain extends Node implements ITerrain
	{
		private var _tileSize:Number3D;
//		private var _isoTileSize:Number;
		
		private var _bufferedIds:Array;
		
		private var _grafo:XML;
		private var _multBitmap:MultBitmap2;
		
		private var _tileButtons:Dictionary;
		
		public function Terrain( grafo:XML, multBitmap:MultBitmap2, pos:Number3D, rot:Quaternion, tileSize:Number3D, nodeName:String )
		{
			super( pos, rot, new Number3D(0,0,0), nodeName );
			
			_grafo = grafo;
			_multBitmap = multBitmap;
			_tileSize = tileSize;
			//_tileSize = new Number3D;
			//_tileSize.x = 128;
			//_tileSize.z = 64;
			//_tileSize.y = 16;
			_tileButtons = new Dictionary(true);
			
//			this._isoTileSize = IsoTools.size2iso( _tileSize.x, _tileSize.z );
			
			_bufferedIds = new Array;
//			_bufferedPos = new Array;
			
			parseXML(_grafo);
//			parseGraph(_grafo);
		}
/*
		private function parseGraph(grafo:Grafo3):void
		{
			var block:TerrainBlock;
//			var vertices:Array = grafo.vertices;
			
			for (var id:uint = 0; id < grafo.numVertices; id++ )
			{
				block = new TerrainBlock( id, grafo.getData(id).x, grafo.getData(id).y, grafo.getData(id).z, grafo.getData(id).h,
											_multBitmap, grafo.getData(id).type,
											new Number3D( (grafo.getData(id).x ) * _tileSize.x + _tileSize.x/2, grafo.getData(id).y * _tileSize.y, (grafo.getData(id).z ) * _tileSize.z + _tileSize.z/2),
//											new Number3D( (grafo.getData(id).x * 2 + 1) * _tileSize.x / 2, grafo.getData(id).y * _tileSize.y, (grafo.getData(id).z * 2 + 1) * _tileSize.z / 2 ),
											new Quaternion, new Number3D( _tileSize.x, _tileSize.y, _tileSize.z ), "t_"+id );
				addChildNode( block );
			}
		}
*/
		private function parseXML(grafo:XML):void
		{
			var block:TerrainBlock;
//			var vertices:Array = grafo.vertices;
/*
			for (var id:uint = 0; id < grafo.numVertices; id++ )
			{
				block = new TerrainBlock( id, grafo.getData(id).x, grafo.getData(id).y, grafo.getData(id).z, grafo.getData(id).h,
											_multBitmap, grafo.getData(id).type,
											new Number3D( (grafo.getData(id).x ) * _tileSize.x + _tileSize.x/2, grafo.getData(id).y * _tileSize.y, (grafo.getData(id).z ) * _tileSize.z + _tileSize.z/2),
//											new Number3D( (grafo.getData(id).x * 2 + 1) * _tileSize.x / 2, grafo.getData(id).y * _tileSize.y, (grafo.getData(id).z * 2 + 1) * _tileSize.z / 2 ),
											new Quaternion, new Number3D( _tileSize.x, _tileSize.y, _tileSize.z ), "t_"+id );
				addChildNode( block );
			}
*/
//			for each( var t:XML in grafo.tile )
			for ( var a:uint = 0; a < grafo.tile.length(); a++ )
			{
				var t:XML = grafo.tile[a];
				
				var type:uint;
				switch( String(t.@tipo) )
				{
					case "PLAIN": type = 0; break;
					case "GRASS": type = 1; break;
					case "ROCK": type = 2; break;
					case "SAND": type = 3; break;
					case "ICE": type = 4; break;
					case "WATER": type = 5; break;
					case "LAVA": type = 6; break;
					default: type = uint(t.@tipo);
				}
				
				var tileData:TileData = new TileData( int(t.@x), int(t.@y), int(t.@z), int(t.@h), ETile.GRASS );
				tileData.x = int(t.@x);
				tileData.y = int(t.@y);
				tileData.z = int(t.@z);
				tileData.h = int(t.@h);
				
				var id:uint = uint(t.@id);
				
				block = new TerrainBlock( id, tileData.x, tileData.y, tileData.z, tileData.h,
											_multBitmap, type,
											new Number3D( tileData.x * _tileSize.x + _tileSize.x/2, tileData.y * _tileSize.y, tileData.z * _tileSize.z + _tileSize.z/2),
											new Quaternion, new Number3D( _tileSize.x, _tileSize.y, _tileSize.z ), "t_"+id );
				addChildNode( block );
			}
			
			var xyu:int = 0;
			
		}
		
		public function get multBitmap():MultBitmap2 { return this._multBitmap; }
		public function get tileSize():Number3D { return this._tileSize; }
//		public function set tileSize( value:Number3D ):void { this._tileSize = value; }
		
		public function getPos( id:uint ):Number3D
		{
			return _bufferedIds[id];
		}

		public function getHeight( x:Number, z:Number ):Number
		{
//			return _bufferedIds[id].y;
			
			for each( var o:Object in this.childs )
			{
//				trace( "testing ", tb.nodeName );
//				trace( x, " <= ", (tb.transformation.position.x + tb.size.x / 2) );
//				trace( x, " >= ", (tb.transformation.position.x - tb.size.x / 2) );
//				trace( z, " <= ", (tb.transformation.position.z + tb.size.z / 2) );
//				trace( z, " >= ", (tb.transformation.position.z - tb.size.z / 2) );
				if ( o is TerrainBlock )
				{
					var tb:TerrainBlock = o as TerrainBlock;
					if (	x < (tb.local_pos_x + size.x/2) &&
							x >= (tb.local_pos_x - size.x/2) &&
							z < (tb.local_pos_z + size.z/2) &&
							z >= (tb.local_pos_z - size.z/2)	)
					{
	//					trace( "ok for ", tb.nodeName );
						return tb.local_pos_y+1;
					}
				}
			}
			return 0;
		}

		// um Terrain soh pode ter como nós filhos, terrain block
		public override function addChildNode( child:INode ):void
		{
			if (child is TerrainBlock)
			{
				var tb:TerrainBlock = child as TerrainBlock;
				_tileButtons[tb.id] = tb.sel;
				this._bufferedIds[tb.id] = new Number3D(tb.x, tb.y + tb.h, tb.z);
			}
			super.addChildNode( child );
		}
		
		public function setAllTileButtons( state:int = 0 ):void
		{
			for ( var key:String in _tileButtons)
				_tileButtons[key].setState(state);
		}
		
		public function setTileButtons( tiles:Array, state:int ):void
		{
			for each( var nodeName:String in tiles)
				_tileButtons[nodeName].setState(state);
		}
		
		
/*
		private function parseGraph(grafo:Grafo):void
		{
			var node:GraphNode;
			var graphIter:Iterator = _grafo.getIterator();
			
			do
			{
				node = graphIter.next()
				if ( node != null )
				{
					var vertice:Object = node.data;
//					trace(vertice.id, vertice.x, vertice.y, vertice.z);
					block = new TerrainBlock( vertice.id, _multBitmap, TerrainBlock.ELEMENTO_VENTO, TerrainBlock.TERRENO_GRAMA_2, new Number3D( (vertice.x*2+1)*_isoTileSize/2, vertice.y*_tileSize.y, (vertice.z*2+1)*_isoTileSize/2 ), new Quaternion, new Number3D( 128, 16, 64 ), "t_"+vertice.id );
					addChildNode( block );
				}
			} while (graphIter.hasNext());
		}
		
		
		private function parseXML(xmlData:XML):void
		{
			//parse and build a screen from parsed data
			var parser:XmlParser = new XmlParser(xmlData);
			var tempArray:Array = parser.getRows();
			
			for (var i:uint = 0; i < tempArray.length; i++)
			{
				for (var j:uint = 0; j < tempArray[i].length; j++)
				{
					var block:TerrainBlock;
					if(tempArray[i][j] != 0)
					{
						block = new TerrainBlock( "0", _multBitmap, TerrainBlock.ELEMENTO_VENTO, TerrainBlock.TERRENO_GRAMA_2, new Number3D( (i*2+1)*_isoTileSize/2, tempArray[i][j]*_tileSize.y, (j*2+1)*_isoTileSize/2 ), new Quaternion, new Number3D( 128, 16, 64 ), "t_"+i+"_"+j );
						addChildNode( block );
					}
				}
			}
		}
*/
	}
}
