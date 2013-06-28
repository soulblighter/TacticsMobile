package julio
{
	import com.hydrotik.queueloader.QueueLoader;
	import com.hydrotik.queueloader.QueueLoaderEvent;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import julio.tactics.events.GameEvent;
	import julio.iso.MultBitmap2;
	/**
	 * ...
	 * @author ...
	 */
	public class AssetsManager
	{
		private var _comm:EventDispatcher;
		private var _assets:XML;
		private var _queueLoader:QueueLoader;
		private var _loaderContext:LoaderContext
		
		private var _char:Object;
		private var _sfx:Object;
		private var _tile:Object;
		private var _data:Object;
		
		public function AssetsManager( comm:EventDispatcher, assets:XML )
		{
			this._comm = comm;
			this._assets = assets;
			
			this._char = new Object;
			this._sfx = new Object;
			this._tile = new Object;
			this._data = new Object;
			
			_loaderContext = new LoaderContext( false, new ApplicationDomain(ApplicationDomain.currentDomain), null );
			
			_queueLoader = new QueueLoader(false, _loaderContext );//false, addedDefinitions, true, "defaultQueue");
			
			fromXML(assets);
		}
		
		private function fromXML( assets:XML ):void
		{
			
			for (var i:uint = 0; i < assets.asset.length(); i++)
			{
				var a:XML = assets.asset[i];
				trace( a.@id + " = " + a.@name + " | " + a.@type + " | " + a.@path );
				_queueLoader.addItem(a.@path, null, {title:a.@name});
			}
			
			
//			_queueLoader.addItem("../assets/Fighter_high_dbg.swf", null, {title:"Fighter_high"});
//			_queueLoader.addItem("../assets/Skelleton_high_dbg.swf", null, {title:"Skelleton_high"});
//			_queueLoader.addItem("../assets/tiles2.gif", null, {title:"tiles"});
//			_queueLoader.addItem("../assets/level3.xml", null, {title:"graph"} );
			
			
//			_queueLoader.addItem("../assets/IsoCharAs3.swf", null, {title:"Fighter_high"});
//			_queueLoader.addEventListener(QueueLoaderEvent.QUEUE_PROGRESS, loading, false, 0, false);
			_queueLoader.addEventListener(QueueLoaderEvent.QUEUE_COMPLETE, finishedLoading, false, 0, false);
			_queueLoader.execute();
			
		}
		
		public function loading( e:QueueLoaderEvent ):void
		{
			trace( (100*e.queuepercentage) + "%" );
		}
		
		public function finishedLoading( e:QueueLoaderEvent ):void
		{
//			trace(e);
			
			for (var i:uint = 0; i < _assets.asset.length(); i++)
			{
				var a:XML = _assets.asset[i];
				switch( String(a.@type) )
				{
					case "char":
//						var assetClass:Class = _queueLoader.getItemByTitle( a.@name ).loader.contentLoaderInfo.applicationDomain.getDefinition("ImageAsset");
						var assetClass:Sprite = _queueLoader.getItemByTitle( a.@name ).loader.content;
						var l:Loader = _queueLoader.getItemByTitle( a.@name ).loader;
//						var assetClass2:Class = l.contentLoaderInfo.applicationDomain.getDefinition("ImageAsset");
						var assetClass2:Object = l.contentLoaderInfo.applicationDomain.getDefinition("ImageAsset")
						this._char[a.@name] = assetClass2;
						break;
					
					case "tile":
//						var assetClass:Class = _queueLoader.getItemByTitle( a.@name ).loader.contentLoaderInfo.applicationDomain.getDefinition("ImageAsset");
						var tileSheet:Bitmap = _queueLoader.getItemByTitle( a.@name ).content as Bitmap;
						var m:MultBitmap2 = new MultBitmap2(tileSheet.bitmapData, uint(a.@rows), uint(a.@cols) );
						this._tile[a.@name] = m;
						break;
					
					case "graph":
//						var assetClass:Class = _queueLoader.getItemByTitle( a.@name ).loader.contentLoaderInfo.applicationDomain.getDefinition("ImageAsset");
						var graph:XML = _queueLoader.getItemByTitle( a.@name ).content;
						this._data[a.@name] = graph;
						break;
					
//					default:
//						throw new Error("invalid asset");
				}
			}
			
			_queueLoader.removeEventListener(QueueLoaderEvent.QUEUE_PROGRESS, loading, false);
			_queueLoader.removeEventListener(QueueLoaderEvent.QUEUE_COMPLETE, finishedLoading, false);
			
			this._comm.dispatchEvent( new GameEvent( GameEvent.FINISHED_LOADING ) );
		}
		
		public function getTile(id:String):MultBitmap2
		{
			return this._tile[id];
		}
		
		public function getChar(id:String):Object
		{
			return this._char[id];
		}
		
		public function getData(id:String):XML
		{
			return this._data[id];
		}
		
	}

}
