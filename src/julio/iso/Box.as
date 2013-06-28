package julio.iso
{
	import flash.display.Shape;
	import flash.display.DisplayObject;
	import away3d.core.math.Number3D;
	import away3d.core.math.Quaternion;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class Box extends DisplayNode
	{
		private var _shape:Shape;
		
		public function Box( pos:Number3D, rot:Quaternion, size:Number3D, nodeName:String, renderPriority:uint = 0 )
		{
			this._shape = new Shape;
			super(Shape, pos, rot, size, nodeName, renderPriority, true);
		}
		
		public function drawFill( corLinha:Number, corFill:Number ):void
		{
			_shape.graphics.beginFill( corFill );
			drawLinha(corLinha);
			_shape.graphics.endFill();
		}
		
		public function drawLinha(corLinha:Number):void
		{
			_shape.graphics.lineStyle( 3, corLinha ) //style(1, color, 100);
			
			// face 1
			_shape.graphics.moveTo( IsoTools.iso2xFla(0-_size.x/2,			0,				0+_size.z-_size.z/2),		IsoTools.iso2yFla(0-_size.x/2,			0,			0+_size.z-_size.z/2) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0-_size.x/2,			0+_size.y,		0+_size.z-_size.z/2),		IsoTools.iso2yFla(0-_size.x/2,			0+_size.y,	0+_size.z-_size.z/2) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0+_size.x-_size.x/2,	0+_size.y,		0+_size.z-_size.z/2),		IsoTools.iso2yFla(0+_size.x-_size.x/2,	0+_size.y,	0+_size.z-_size.z/2) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0+_size.x-_size.x/2,	0,				0+_size.z-_size.z/2),		IsoTools.iso2yFla(0+_size.x-_size.x/2,	0,			0+_size.z-_size.z/2) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0-_size.x/2,			0,				0+_size.z-_size.z/2),		IsoTools.iso2yFla(0-_size.x/2,			0,			0+_size.z-_size.z/2) );
			
			// face 2
			_shape.graphics.moveTo( IsoTools.iso2xFla(0+_size.x-_size.x/2,	0,				0-_size.z/2),				IsoTools.iso2yFla(0+_size.x-_size.x/2,	0,			0-_size.z/2) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0+_size.x-_size.x/2,	0+_size.y,		0-_size.z/2),				IsoTools.iso2yFla(0+_size.x-_size.x/2,	0+_size.y,	0-_size.z/2) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0+_size.x-_size.x/2,	0+_size.y,		0+_size.z-_size.z/2),		IsoTools.iso2yFla(0+_size.x-_size.x/2,	0+_size.y,	0+_size.z-_size.z/2) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0+_size.x-_size.x/2,	0,				0+_size.z-_size.z/2),		IsoTools.iso2yFla(0+_size.x-_size.x/2,	0,			0+_size.z-_size.z/2) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0+_size.x-_size.x/2,	0,				0-_size.z/2),				IsoTools.iso2yFla(0+_size.x-_size.x/2,	0,			0-_size.z/2) );

			// top face
			_shape.graphics.moveTo( IsoTools.iso2xFla(0-_size.x/2,			0+_size.y,		0-_size.z/2),				IsoTools.iso2yFla(0-_size.x/2,			0+_size.y,	0-_size.z/2) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0-_size.x/2,			0+_size.y,		0+_size.z-_size.z/2),		IsoTools.iso2yFla(0-_size.x/2,			0+_size.y,	0+_size.z-_size.z/2) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0+_size.x-_size.x/2,	0+_size.y,		0+_size.z-_size.z/2),		IsoTools.iso2yFla(0+_size.x-_size.x/2,	0+_size.y,	0+_size.z-_size.z/2) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0+_size.x-_size.x/2,	0+_size.y,		0-_size.z/2),				IsoTools.iso2yFla(0+_size.x-_size.x/2,	0+_size.y,	0-_size.z/2) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0-_size.x/2,			0+_size.y,		0-_size.z/2),				IsoTools.iso2yFla(0-_size.x/2,			0+_size.y,	0-_size.z/2) );
/*
			// face 1
			_shape.graphics.moveTo( IsoTools.iso2xFla(0,			0,				0+_size.z),		IsoTools.iso2yFla(0,			0,			0+_size.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0,			0+_size.y,		0+_size.z),		IsoTools.iso2yFla(0,			0+_size.y,	0+_size.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0+_size.x,	0+_size.y,		0+_size.z),		IsoTools.iso2yFla(0+_size.x,	0+_size.y,	0+_size.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0+_size.x,	0,				0+_size.z),		IsoTools.iso2yFla(0+_size.x,	0,			0+_size.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0,			0,				0+_size.z),		IsoTools.iso2yFla(0,			0,			0+_size.z) );
			
			// face 2
			_shape.graphics.moveTo( IsoTools.iso2xFla(0+_size.x,	0,				0),				IsoTools.iso2yFla(0+_size.x,	0,			0) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0+_size.x,	0+_size.y,		0),				IsoTools.iso2yFla(0+_size.x,	0+_size.y,	0) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0+_size.x,	0+_size.y,		0+_size.z),		IsoTools.iso2yFla(0+_size.x,	0+_size.y,	0+_size.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0+_size.x,	0,				0+_size.z),		IsoTools.iso2yFla(0+_size.x,	0,			0+_size.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0+_size.x,	0,				0),				IsoTools.iso2yFla(0+_size.x,	0,			0) );

			// top face
			_shape.graphics.moveTo( IsoTools.iso2xFla(0,			0+_size.y,		0),				IsoTools.iso2yFla(0,			0+_size.y,	0) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0,			0+_size.y,		0+_size.z),		IsoTools.iso2yFla(0,			0+_size.y,	0+_size.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0+_size.x,	0+_size.y,		0+_size.z),		IsoTools.iso2yFla(0+_size.x,	0+_size.y,	0+_size.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0+_size.x,	0+_size.y,		0),				IsoTools.iso2yFla(0+_size.x,	0+_size.y,	0) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(0,			0+_size.y,		0),				IsoTools.iso2yFla(0,			0+_size.y,	0) );
			
			
*/
/*
			_shape.graphics.moveTo( IsoTools.iso2xFla(_pos.x,			_pos.y,			_pos.z),		IsoTools.iso2yFla(_pos.x,			_pos.y,			_pos.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(_pos.x+size.x,	_pos.y,			_pos.z),		IsoTools.iso2yFla(_pos.x+size.x,	_pos.y,			_pos.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(_pos.x+size.x,	_pos.y+size.y,	_pos.z),		IsoTools.iso2yFla(_pos.x+size.x,	_pos.y+size.y,	_pos.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(_pos.x,			_pos.y+size.y,	_pos.z),		IsoTools.iso2yFla(_pos.x,			_pos.y+size.y,	_pos.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(_pos.x,			_pos.y,			_pos.z),		IsoTools.iso2yFla(_pos.x,			_pos.y,			_pos.z) );
			_shape.graphics.moveTo( IsoTools.iso2xFla(_pos.x,			_pos.y+size.y,	_pos.z),		IsoTools.iso2yFla(_pos.x,			_pos.y+size.y,	_pos.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(_pos.x+size.x,	_pos.y+size.y,	_pos.z),		IsoTools.iso2yFla(_pos.x+size.x,	_pos.y+size.y,	_pos.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(_pos.x+size.x,	_pos.y+size.y,	_pos.z+size.z),	IsoTools.iso2yFla(_pos.x+size.x,	_pos.y+size.y,	_pos.z+size.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(_pos.x,			_pos.y+size.y,	_pos.z+size.z),	IsoTools.iso2yFla(_pos.x,			_pos.y+size.y,	_pos.z+size.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(_pos.x,			_pos.y+size.y,	_pos.z),		IsoTools.iso2yFla(_pos.x,			_pos.y+size.y,	_pos.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(_pos.x,			_pos.y,			_pos.z),		IsoTools.iso2yFla(_pos.x,			_pos.y,			_pos.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(_pos.x,			_pos.y+size.y,	_pos.z),		IsoTools.iso2yFla(_pos.x,			_pos.y+size.y,	_pos.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(_pos.x,			_pos.y+size.y,	_pos.z+size.z),	IsoTools.iso2yFla(_pos.x,			_pos.y+size.y,	_pos.z+size.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(_pos.x,			_pos.y,			_pos.z+size.z),	IsoTools.iso2yFla(_pos.x,			_pos.y,			_pos.z+size.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(_pos.x,			_pos.y,			_pos.z),		IsoTools.iso2yFla(_pos.x,			_pos.y,			_pos.z) );
*/		}
		
		public override function draw( viewName:String ):void
		{
			drawLinha(0xff0000);
//			this._shape.y = - size.y/2;
			this._instances[viewName] = this._shape;
		}
	}
}
