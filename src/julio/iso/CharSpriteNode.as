package julio.iso
{
	import away3d.core.math.Matrix3D;
	import away3d.core.math.Number3D;
	import away3d.core.math.Quaternion;
	import flash.display.Bitmap;
	import flash.media.SoundChannel;
	import julio.iso.*;
	import julio.scenegraph.*;
	import julio.resource.CharAsset;
//	import br.com.stimuli.loading.BulkProgressEvent;
//	import br.com.stimuli.loading.lazyloaders.LazyXMLLoader;
	
	//import julio.tactics.*;
	//import julio.tactics.cenas.*;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class CharSpriteNode extends AnimatedNode
	{
		private var _sfxSoundChannel:SoundChannel;	// Channel para os sons do personagem
		
		private var _attackSfx:Class;
		private var _hitSfx:Class;
		private var _runSfx:Class;
		private var _deathSfx:Class;
		
		private var _animations:Object;
		private var _aniDir:Array;
		private var _frames:Object;
		
//		private var _loader:LazyXMLLoader;
//		private var _loadingProgress:int = 0;
		
		private var _currentAnim:String;
		private var _currentDir:String;
		
		// Loader utilizado para carregar o swf com as animações
//		private var _loader2:Loader;
		
		public function CharSpriteNode( charAsset:CharAsset, pos:Number3D, rot:Quaternion, size:Number3D, nodeName:String, renderPriority:uint = 0, onlyDefaultRender:Boolean = false )
		{
			super(Bitmap, pos, rot, size, nodeName, renderPriority, onlyDefaultRender);
			
			var desc:XML = charAsset.desc();
			
			_animations = new Object;
			for each( var s:XML in desc.anim )
			{
				_animations[s.@name] = s.@size;
			}
			
			//_animations =  //CharAsset["desc"]();// ["attack", "hit", "run", "death"];
			_aniDir = ["ne", "nw", "se", "sw"];
			
			_currentAnim = "run";
			_currentDir = "se";
			frameAmount = _animations[_currentAnim];
			
			_frames = new Object();
			
			for ( var a:String in _animations )
			{
				_frames[a] = new Object();
				for ( var b:int = 0; b < _aniDir.length; b++ )
				{
					_frames[a][_aniDir[b]] = new Array();
				}
			}
			
			_regPoints.x = - charAsset["sizeX"] / 2.0; // -64;
			_regPoints.y = - charAsset["sizeY"] * 0.75; // -96;
			_depthPoints.x = - charAsset["sizeX"] * 0.1; // - 10;
			_depthPoints.z = - charAsset["sizeY"] * 0.1; // - 10;
			
			for ( var a2:String in _animations )
				for ( var b2:int = 0; b2 < _aniDir.length; b2++ )
					for ( var c2:int = 0; c2 < _animations[a2]; c2++ )
						_frames[a2][_aniDir[b2]].push( charAsset.data(a2, _aniDir[b2], c2) );
			
//						_frames[a2][_aniDir[b2]].push( CharAsset["data"](a2+"_"+_aniDir[b2]+"_"+c2) as BitmapData );
			
//			_loader2 = new Loader();
//			_loader2.contentLoaderInfo.addEventListener(Event.INIT, initHandler);
//			_loader2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
//			_loader2.load(new URLRequest(file));
		}
		
		public function get animation():String { return this._currentAnim; }
		public function set animation(value:String):void { changeAnimation(value); }
		
		public override function update( timeDelta:Number, parentTransformation:Matrix3D, parentChanged:Boolean = false, recursive:Boolean = true ):void
		{
			super.update(timeDelta, parentTransformation, parentChanged, recursive);
			
			// change animation direction based on real direction
			if ( Math.round( this.final_dir_z ) == 1 && Math.round( this.final_dir_x ) == 0 )
			{	_currentDir = "sw"; redraw();	}
			if ( Math.round( this.final_dir_z ) == 0 && Math.round( this.final_dir_x ) == -1 )
			{	_currentDir = "se"; redraw();	}
			if ( Math.round( this.final_dir_z ) == 0 && Math.round( this.final_dir_x ) == 1 )
			{	_currentDir = "nw"; redraw();	}
			if ( Math.round( this.final_dir_z ) == -1 && Math.round( this.final_dir_x ) == 0 )
			{	_currentDir = "ne"; redraw();	}
		}
		
		public function startRunning():void
		{
			this.animation = "run";
		}
		public function endAnimation():void
		{
			this.animation = "attack";
			this.gotoAndStop(0);
		}
		
		
		
		
		
		
/*
		private function ioErrorHandler(event:IOErrorEvent):void
		{
            trace("ioErrorHandler: " + event);
		}
		
		private function initHandler(event:Event):void
		{
			var CharAsset:Class = _loader2.contentLoaderInfo.applicationDomain.getDefinition("CharAsset") as Class;
			
			for ( var a:int = 0; a <_aniNames.length; a++ )
				for ( var b:int = 0; b < _aniDir.length; b++ )
					for ( var c:int = 0; c < _frameAmount; c++ )
						_frames[_aniNames[a]][_aniDir[b]].push( CharAsset["data"](_aniNames[a]+"_"+_aniDir[b]+"_"+c) as BitmapData );
		}
		
		public function get loadindProgress():int { return this._loadingProgress; }
		
		private function onLoadingProgress(event:BulkProgressEvent):void
		{
			_loadingProgress = Math.floor( 100 * event.ratioLoaded );
		}
*/
		public function changeAnimation( anim:String, reset:Boolean = true ):void
		{
			_currentAnim = anim;
			frameAmount = _animations[_currentAnim];
			
			if ( reset ) resetAnim();
		}
		
		public override function redraw():void
		{
			for each( var v:IViewport in this._viewsRegistereds )
				if( _frames[_currentAnim][_currentDir][frameNr] )
					this._instances[v.viewName].bitmapData = _frames[_currentAnim][_currentDir][frameNr].bitmapData;
//					this._instances[v.viewName].bitmapData = _frames[_currentAnim][_currentDir][_frameNr];
		}
		
		public override function draw( viewName:String ):void
		{
//			trace("CharSpriteNode::draw() "+ _currentAnim + "/" + _currentDir + "/" + frameNr);
			if( _frames[_currentAnim][_currentDir][frameNr] )
				this._instances[viewName].bitmapData = _frames[_currentAnim][_currentDir][frameNr].bitmapData;
//				this._instances[viewName].bitmapData = _frames[_currentAnim][_currentDir][_frameNr];
			
			this._instances[viewName].x += _regPoints.x;
			this._instances[viewName].y += _regPoints.y;
			
		}
	}
}
