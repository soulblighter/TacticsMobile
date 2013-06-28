package julio.iso
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import julio.iso.events.TerrainBlockEvent;
	import julio.tactics.events.TurnEvent;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class TileButton extends SimpleButton
	{
		private var _id:uint;
		private var _x:int;
		private var _z:int;
		private var _corLinha:int;
		private var _corFill:int;
		private var _isoTileSize:Number;
		
		private var _move:Shape;
		private var _shift:Shape;
		private var _attack:Shape;
		private var _magic:Shape;
		
		public function TileButton( id:uint, isoTileSize:Number, x:int, z:int )
		{
			this._id = id;
			this._x = x;
			this._z = z;
			this.corLinha = corLinha;
			this.corFill = corFill;
			this._isoTileSize = isoTileSize;
			
			_move = new Shape;
			_shift = new Shape;
			_attack = new Shape;
			_magic = new Shape;
			
			var upState:Shape = _move;
			var overState:Shape = new Shape;
			var downState:Shape = new Shape;
			var hitTestState:Shape = overState;
			
			upState.visible = false;
			
			drawFiledSquare( _move.graphics, 0, 0, 0, _isoTileSize, _isoTileSize, 0x000000, 0x00AAAA );
			drawFiledSquare( _shift.graphics, 0, 0, 0, _isoTileSize, _isoTileSize, 0x000000, 0x0000AA );
			drawFiledSquare( _attack.graphics, 0, 0, 0, _isoTileSize, _isoTileSize, 0x000000, 0xCCCCAA );
			drawFiledSquare( _magic.graphics, 0, 0, 0, _isoTileSize, _isoTileSize, 0x000000, 0xBB00AA );
			drawFiledSquare( overState.graphics, 0, 0, 0, _isoTileSize, _isoTileSize, 0x00FF00, 0x00AA00 );
			drawFiledSquare( downState.graphics, 0, 0, 0, _isoTileSize, _isoTileSize, 0xFF0000, 0xAA0000 );
//			drawFiledSquare( hitTestState.graphics, 0, 0, 0, _isoTileSize, _isoTileSize, 0xFFFFFF, 0xAAAAAA );
			
			super(upState, overState, downState, hitTestState);
			this.useHandCursor = false;
			this.cacheAsBitmap = true;
			
//			addEventListener( MouseEvent.CLICK, tileMouseClick, false, 0, true );
//			addEventListener( MouseEvent.MOUSE_OVER, tileMouseOver, false, 0, true );
		}
		
		public function drawFiledSquare( graphics:Graphics, xa:Number, ya:Number, za:Number, xb:Number, zb:Number, cor:Number, cor2:Number):void
		{
			graphics.clear();
			graphics.beginFill( cor2 );
			drawSquare(graphics, xa, ya, za, xb, zb, cor);
			graphics.endFill();
		}
		
		public function drawSquare(graphics:Graphics, x1:Number, y1:Number, z1:Number, a:Number, c:Number, cor:Number):void
		{
			graphics.lineStyle( 2, cor )

			graphics.moveTo( IsoTools.iso2xFla(x1, y1, z1),		IsoTools.iso2yFla(x1, y1, z1) );
			graphics.lineTo( IsoTools.iso2xFla(x1+a, y1, z1),	IsoTools.iso2yFla(x1+a, y1, z1) );
			graphics.lineTo( IsoTools.iso2xFla(x1+a, y1, z1+c),	IsoTools.iso2yFla(x1+a, y1, z1+c) );
			graphics.lineTo( IsoTools.iso2xFla(x1, y1, z1+c),	IsoTools.iso2yFla(x1, y1, z1+c) );
			graphics.lineTo( IsoTools.iso2xFla(x1, y1, z1),		IsoTools.iso2yFla(x1, y1, z1) );
		}

		public function get id():uint { return this._id; }
		
		public function get corLinha():int { return this._corLinha; }
		public function set corLinha( value:int ):void { this._corLinha = value; }
		public function get corFill():int { return this._corFill; }
		public function set corFill( value:int ):void { this._corFill = value; }
		
		public function setState( number:int ):void
		{
			switch( number )
			{
			case 0: upState = _move;	upState.visible = false; if( hasEventListener( MouseEvent.CLICK ) ) removeEventListener( MouseEvent.CLICK, tileMouseClick, false ); break;
			case 1: upState = _move;	upState.visible = true; if( !hasEventListener( MouseEvent.CLICK ) ) addEventListener( MouseEvent.CLICK, tileMouseClick, false, 0, true ); break;
			case 2: upState = _shift;	upState.visible = true; if( !hasEventListener( MouseEvent.CLICK ) ) addEventListener( MouseEvent.CLICK, tileMouseClick, false, 0, true ); break;
			case 3: upState = _attack;	upState.visible = true; if( !hasEventListener( MouseEvent.CLICK ) ) addEventListener( MouseEvent.CLICK, tileMouseClick, false, 0, true ); break;
			case 4: upState = _magic;	upState.visible = true; if( !hasEventListener( MouseEvent.CLICK ) ) addEventListener( MouseEvent.CLICK, tileMouseClick, false, 0, true ); break;
			}
		}

		public function tileMouseClick(event:MouseEvent):void
		{
			var te:TerrainBlockEvent = new TerrainBlockEvent( TerrainBlockEvent.TILE_CLICK );
//			te.data.appendChild(<tileclick x={_x} z={_z}/>);
			te.id = _id;
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
