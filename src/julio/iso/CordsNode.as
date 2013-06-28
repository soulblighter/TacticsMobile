package julio.iso
{
	import away3d.core.math.Number3D;
	import away3d.core.math.Matrix3D;
	import away3d.core.math.Quaternion;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class CordsNode extends DisplayNode
	{
		public function CordsNode( nodeName:String = "cordenadas", renderPriority:uint = 0, onlyDefaultRender:Boolean = false )
		{
			super(Shape, new Number3D(0,0,0), new Quaternion(0,1,0,0), new Number3D(1000,1000,1000), nodeName, renderPriority, onlyDefaultRender);
		}
		
		public override function draw( viewName:String ):void
		{
			this._instances[viewName].graphics.lineStyle( 3, 0xff0000 );
			this._instances[viewName].graphics.moveTo( IsoTools.iso2xFla(_pos.x, _pos.y, _pos.z),			IsoTools.iso2yFla(_pos.x, _pos.y, _pos.z) );
			this._instances[viewName].graphics.lineTo( IsoTools.iso2xFla(_pos.x+size.x, _pos.y, _pos.z),	IsoTools.iso2yFla(_pos.x+size.x, _pos.y, _pos.z) );
			this._instances[viewName].graphics.lineStyle( 3, 0x00ff00 );
			this._instances[viewName].graphics.moveTo( IsoTools.iso2xFla(_pos.x, _pos.y, _pos.z),			IsoTools.iso2yFla(_pos.x, _pos.y, _pos.z) );
			this._instances[viewName].graphics.lineTo( IsoTools.iso2xFla(_pos.x, _pos.y+size.y, _pos.z),	IsoTools.iso2yFla(_pos.x, _pos.y+size.y, _pos.z) );
			this._instances[viewName].graphics.lineStyle( 3, 0x0000ff );
			this._instances[viewName].graphics.moveTo( IsoTools.iso2xFla(_pos.x, _pos.y, _pos.z),			IsoTools.iso2yFla(_pos.x, _pos.y, _pos.z) );
			this._instances[viewName].graphics.lineTo( IsoTools.iso2xFla(_pos.x, _pos.y, _pos.z+size.z),	IsoTools.iso2yFla(_pos.x, _pos.y, _pos.z+size.z) );
		}
	}
}
