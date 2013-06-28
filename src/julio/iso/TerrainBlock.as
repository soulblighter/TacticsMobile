package julio.iso
{
	import away3d.core.math.Matrix3D;
	import away3d.core.math.Number3D;
	import away3d.core.math.Quaternion;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import julio.iso.*;
	import julio.iso.events.TerrainBlockEvent;
	import julio.iso.MultBitmap2;
	import julio.scenegraph.*;
	
	
	//import julio.tactics.*;
	//import julio.tactics.cenas.*;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class TerrainBlock extends DisplayNode
	{
		private var _x:int;
		private var _y:int;
		private var _z:int;
		private var _h:uint;
		private var _tileSize:Number3D;
		private var _id:uint;
		private var _tipo:uint;
		private var _multBitmap:MultBitmap2;
//		private var _isoTileSize:Number;
		private var _sel:TileButton;
		
		public function TerrainBlock( id:uint, x:int, y:int, z:int, h:uint, multBitmap:MultBitmap2, tipo:uint, pos:Number3D, rot:Quaternion, tileSize:Number3D, nodeName:String, renderPriority:uint = 0, onlyDefaultRender:Boolean = false )
		{
			super(Sprite, pos, rot, new Number3D( tileSize.x, tileSize.y*h, tileSize.z ), nodeName, renderPriority, onlyDefaultRender);
//			super(Sprite, pos, rot, new Number3D(this._isoTileSize, tileSize.y, this._isoTileSize), nodeName, renderPriority, onlyDefaultRender);
			
			this._x = x;
			this._y = y;
			this._z = z;
			this._h = h;
			this._tileSize = tileSize;
			this._id = id;
			this._tipo = tipo;
			this._multBitmap = multBitmap;
//			this._isoTileSize = IsoTools.size2iso(tileSize.x, tileSize.z);
			_sel = new TileButton( id, size.x * 0.9, x, z );
			
			_depthPoints.x = - _tileSize.x / 2;
			_depthPoints.z = - _tileSize.z / 2;
		}
		
		public function get x():uint { return this._x; }
		public function get y():uint { return this._y; }
		public function get z():uint { return this._z; }
		public function get h():uint { return this._h; }
		
		public function get id():uint { return this._id; }
		public function get tipo():uint { return this._tipo; }
		public function get sel():TileButton { return this._sel; }
		public function get tileSize():Number3D { return this._tileSize; }
		
		public override function draw( viewName:String ):void
		{
			var xp:Number = 0;
			var yp:Number = 0;
			
//			for ( var b:int = 0; b < (this.pos.y/this.size.y); b++ )
//			for ( var b:int = (this.local_pos_y/this.size.y); b < _y+_h; b++ )
			for ( var b:int = y+1; b <= y+_h; b++ )
			{
				var image:Bitmap; //= _multBitmap.getImage(1);
				/*
				switch( this.tipo )
				{
				case ETile.GRASS:	image = _multBitmap.getImage(1); break;
				case ETile.ICE:		image = _multBitmap.getImage(2); break;
				case ETile.LAVA:	image = _multBitmap.getImage(3); break;
				case ETile.PLAIN:	image = _multBitmap.getImage(4); break;
				case ETile.ROCK:	image = _multBitmap.getImage(5); break;
				case ETile.SAND:	image = _multBitmap.getImage(6); break;
				case ETile.WATER:	image = _multBitmap.getImage(7); break;
				}*/
				image = _multBitmap.getImage(this._tipo);
				
				var y_:Number = b * tileSize.y;
				
				image.x = IsoTools.iso2xFla(0, y_, 0) - image.width / 2;
				image.y = IsoTools.iso2yFla(0, y_, 0) - tileSize.z/2 + tileSize.y * y;
				
				//xp = - image.width / 2;
//				yp = - tileSize.z / 2;
				
				this._instances[viewName].addChild( image );
			}
			if ( viewName == "defaultView" )
			{
//				_sel = new TileButton( id, _isoTileSize*0.9 );
				_sel.x = IsoTools.iso2xFla(tileSize.x*0.05, y_, tileSize.z*0.05); // + sel.width / 2;
				_sel.y = IsoTools.iso2yFla(tileSize.x * 0.05, y_, tileSize.z * 0.05) - tileSize.z / 2 + tileSize.y * y;
//				_sel.addEventListener( MouseEvent.CLICK, tileMouseClick, false, 0, true );
//				_sel.addEventListener( MouseEvent.MOUSE_OVER, tileMouseOver, false, 0, true );
				
				this._instances[viewName].addChild( _sel );
			}
			this._instances[viewName].cacheAsBitmap = true;
			
//			this.drawDebugBox(viewName, xp, yp);
		}
		
		public override function update( timeDelta:Number, parentTransformation:Matrix3D, parentChanged:Boolean = false, recursive:Boolean = true ):void
		{
			super.update(timeDelta, parentTransformation, parentChanged, recursive);
			
			if ( this._transformChanged == true || parentChanged == true )
			{
				_sel.scaleX = this.local_scale_x;
				_sel.scaleY = this.local_scale_y;
				_sel.scaleZ = this.local_scale_z;
			}
		}
		
		public function tileMouseClick(event:MouseEvent):void
		{
			var te:TerrainBlockEvent = new TerrainBlockEvent( TerrainBlockEvent.TILE_CLICK );
			te.x = _x;
			te.z = _z;
			event.target.dispatchEvent( te );
//			trace( event.target );
//			trace( this.nodeName, this.final_pos_x, this.final_pos_y, this.final_pos_z );
//			trace( event.target.id, event.target.pos.x, event.target.pos.y, event.target.pos.z );
//			trace( event.target.id, event.target.pos.x, event.target.pos.y, event.target.pos.z );
//			trace( event.localX, event.localY );
//			trace( IsoTools.xFlaToIso(event.localX, event.localY), IsoTools.yFlaToIso(event.localX, event.localY) );
		}
		
		public function tileMouseOver(event:MouseEvent):void
		{
//			event.target.dispatchEvent( new TurnEvent.TILE_OVER );
//			trace( event.target );
//			trace( event.target.id );
//			trace( event.target.id, event.target.pos.x, event.target.pos.y, event.target.pos.z );
		}
	}
}
