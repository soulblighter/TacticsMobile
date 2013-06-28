package julio.iso
{
	import away3d.core.math.Number2D;
	import away3d.core.math.Number3D;
	import away3d.core.math.Matrix3D;
	import away3d.core.math.Quaternion;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import julio.iso.*;
	import julio.scenegraph.*;
	//import julio.tactics.*;
	//import julio.tactics.cenas.*;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class DisplayNode extends Node implements IDrawable
	{
		protected var _instances:Object;			// Copias do objeto nas diferentes views
		protected var _viewsRegistereds:Array;		// lista de views q estao relacionadas com o nó
		protected var _onlyDefaultRender:Boolean;	// marca se somente uma view pode exibir o objeto
		protected var _renderPriority:uint;			// prioridade da renderização do objeto (maior siginifica q o objeto ficará por cima dos outros)
		protected var _displayType:Class;			// Tipo do displayObject q será utilizado
		protected var _regPoints:Number2D;			// Pontos q deslocam a posição final do objeto
		protected var _depthPoints:Number3D;		// Pontos q deslocam a posição final do objeto na hora de fazer o sawp depth
		protected var _renderChanged:Boolean;		// Marca se eh necessario recalcula o depth do objeto
//		protected var _zoom:Number;					// Escala a imagem bitmap
		protected var _debugBox:Box;
//		protected var _useDebugBox:Boolean;
		
		public function DisplayNode( displayType:Class, pos:Number3D, rot:Quaternion, size:Number3D, nodeName:String, renderPriority:uint = 0, onlyDefaultRender:Boolean = false )
		{
			super(pos, rot, size, nodeName);
			
			this._onlyDefaultRender = onlyDefaultRender;
			this._instances = new Object;
			this._viewsRegistereds = new Array;
			this._renderPriority = renderPriority;
			this._displayType = displayType;
			this._regPoints = new Number2D;
			this._depthPoints = new Number3D;
			this._renderChanged = false;
//			this._zoom = 1.0;
			
/*			
			if( !(this is Box) && !(this is CordsNode) )
			{
				this._debugBox = new Box( new Number3D(0, 0, 0), new Quaternion(), size, "Box_" + nodeName, renderPriority );
				this.addChildNode( this._debugBox );
			}
*/			
			
			
//			this._debugBox = new Box( pos, rot, size, "box" + nodeName, renderPriority );
		}
		
		public function get flashPos_x():int { return IsoTools.iso2xFla(this.final_pos_x, this.final_pos_y, this.final_pos_z) + _regPoints.x; }
		public function get flashPos_y():int { return IsoTools.iso2yFla(this.final_pos_x, this.final_pos_y, this.final_pos_z) + _regPoints.y; }
		
//		public function get zoom():Number { return this._zoom; }
//		public function set zoom(value:Number):void { this._zoom = value; this.local_scale_x = _zoom; this.local_scale_y = _zoom; this.local_scale_z = _zoom; }
		
		
		public function get depthPoint_x():Number { return this.final_pos_x + this._depthPoints.x; }
		public function get depthPoint_y():Number { return this.final_pos_y + this._depthPoints.y; }
		public function get depthPoint_z():Number { return this.final_pos_z + this._depthPoints.z; }
		public function get regPoints():Number2D { return this._regPoints; }
		public function get displayType():Class { return this._displayType; }
		public function get onlyDefaultRender():Boolean { return this._onlyDefaultRender; }
		public function get renderPriority():uint { return this._renderPriority; }
		
		public function register( view:IViewport ):void
		{
			this._viewsRegistereds.push( view );
			this._instances[view.viewName] = new _displayType;
			draw( view.viewName );
		}
		
		public function unregister( view:IViewport ):void
		{
			delete this._instances[view.viewName];
			this._viewsRegistereds.splice( _viewsRegistereds.indexOf(view.viewName) );
		}
		
		public function getDisplayObject( viewName:String ):DisplayObject
		{
			return this._instances[viewName];
		}
		
		public override function update( timeDelta:Number, parentTransformation:Matrix3D, parentChanged:Boolean = false, recursive:Boolean = true ):void
		{
			if( this._transformChanged == true || parentChanged == true )
				this._renderChanged = true;
			
			super.update(timeDelta, parentTransformation, parentChanged, recursive);
			
			if(_renderChanged == true)
				for each( var v:IViewport in this._viewsRegistereds )
				{
					if ( (this.final_pos_x+this.final_pos_z) % 2 == 0 )
						this._instances[v.viewName].x = Math.floor( IsoTools.iso2xFla(this.final_pos_x, this.final_pos_y, this.final_pos_z) + _regPoints.x );
					else
						this._instances[v.viewName].x = Math.ceil( IsoTools.iso2xFla(this.final_pos_x, this.final_pos_y, this.final_pos_z) + _regPoints.x );
					
					if ( this.final_pos_y % 2 == 0 )
						this._instances[v.viewName].y = Math.floor( IsoTools.iso2yFla(this.final_pos_x, this.final_pos_y, this.final_pos_z) + _regPoints.y );
					else
						this._instances[v.viewName].y = Math.ceil( IsoTools.iso2yFla(this.final_pos_x, this.final_pos_y, this.final_pos_z) + _regPoints.y );
					
					this._instances[v.viewName].scaleX = this.local_scale_x;
					this._instances[v.viewName].scaleY = this.local_scale_y;
					this._instances[v.viewName].scaleZ = this.local_scale_z;
//					this._instances[v.viewName].x = Math.round( IsoTools.iso2xFla(this.final_pos_x, this.final_pos_y, this.final_pos_z) + _regPoints.x );
//					this._instances[v.viewName].y = Math.round( IsoTools.iso2yFla(this.final_pos_x, this.final_pos_y, this.final_pos_z) + _regPoints.y );
					v.update( this );
					_renderChanged = false;
				}
		}
		
		public function draw( viewName:String ):void
		{
			
		}
/*
		public function drawDebugBox( viewName:String, xPadding:Number = 0, yPadding:Number = 0 ):void
		{
			var _shape:Shape = new Shape;
			
			var corLinha:Number = 0xff0000;
			var corFill:Number = 0x00ff00;
			var Tpos:Number3D = new Number3D(0, 0, 0);
			
//			_shape.graphics.beginFill( corFill );
			
			_shape.graphics.lineStyle( 3, corLinha ) //style(1, color, 100);
			// face 1
			_shape.graphics.moveTo( IsoTools.iso2xFla(Tpos.x,			Tpos.y,				Tpos.z+_size.z),	IsoTools.iso2yFla(Tpos.x,			Tpos.y,			Tpos.z+_size.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(Tpos.x,			Tpos.y+_size.y,		Tpos.z+_size.z),	IsoTools.iso2yFla(Tpos.x,			Tpos.y+_size.y,	Tpos.z+_size.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(Tpos.x+_size.x,	Tpos.y+_size.y,		Tpos.z+_size.z),	IsoTools.iso2yFla(Tpos.x+_size.x,	Tpos.y+_size.y,	Tpos.z+_size.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(Tpos.x+_size.x,	Tpos.y,				Tpos.z+_size.z),	IsoTools.iso2yFla(Tpos.x+_size.x,	Tpos.y,			Tpos.z+_size.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(Tpos.x,			Tpos.y,				Tpos.z+_size.z),	IsoTools.iso2yFla(Tpos.x,			Tpos.y,			Tpos.z+_size.z) );
			
			// face 2
			_shape.graphics.moveTo( IsoTools.iso2xFla(Tpos.x+_size.x,	Tpos.y,				Tpos.z),			IsoTools.iso2yFla(Tpos.x+_size.x,	Tpos.y,			Tpos.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(Tpos.x+_size.x,	Tpos.y+_size.y,		Tpos.z),			IsoTools.iso2yFla(Tpos.x+_size.x,	Tpos.y+_size.y,	Tpos.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(Tpos.x+_size.x,	Tpos.y+_size.y,		Tpos.z+_size.z),	IsoTools.iso2yFla(Tpos.x+_size.x,	Tpos.y+_size.y,	Tpos.z+_size.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(Tpos.x+_size.x,	Tpos.y,				Tpos.z+_size.z),	IsoTools.iso2yFla(Tpos.x+_size.x,	Tpos.y,			Tpos.z+_size.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(Tpos.x+_size.x,	Tpos.y,				Tpos.z),			IsoTools.iso2yFla(Tpos.x+_size.x,	Tpos.y,			Tpos.z) );

			// top face
			_shape.graphics.moveTo( IsoTools.iso2xFla(Tpos.x,			Tpos.y+_size.y,		Tpos.z),			IsoTools.iso2yFla(Tpos.x,			Tpos.y+_size.y,	Tpos.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(Tpos.x,			Tpos.y+_size.y,		Tpos.z+_size.z),	IsoTools.iso2yFla(Tpos.x,			Tpos.y+_size.y,	Tpos.z+_size.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(Tpos.x+_size.x,	Tpos.y+_size.y,		Tpos.z+_size.z),	IsoTools.iso2yFla(Tpos.x+_size.x,	Tpos.y+_size.y,	Tpos.z+_size.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(Tpos.x+_size.x,	Tpos.y+_size.y,		Tpos.z),			IsoTools.iso2yFla(Tpos.x+_size.x,	Tpos.y+_size.y,	Tpos.z) );
			_shape.graphics.lineTo( IsoTools.iso2xFla(Tpos.x,			Tpos.y+_size.y,		Tpos.z),			IsoTools.iso2yFla(Tpos.x,			Tpos.y+_size.y,	Tpos.z) );
			
//			_shape.graphics.endFill();
			_shape.x = xPadding;
			_shape.y = yPadding;
			
			this._instances[viewName].addChild( _shape );
		}*/
	}
}
