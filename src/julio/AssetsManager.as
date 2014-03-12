package julio
{
//	import com.hydrotik.queueloader.QueueLoader;
//	import com.hydrotik.queueloader.QueueLoaderEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import julio.resource.CharAsset;
	import julio.resource.HarryTheOrc;
	import julio.resource.RedKnight;
	import julio.tactics.events.GameEvent;
	import julio.iso.MultBitmap2;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AssetsManager
	{
		private var _comm:EventDispatcher;
		private var _assets:XML;
//		private var _queueLoader:QueueLoader;
		private var _loaderContext:LoaderContext
		
		private var _char:Object;
		private var _sfx:Object;
		private var _tile:Object;
		private var _data:Object;
		
		private var totalNum:int;
		private var loadedNum:int;
		
//		[Embed(source = '../../assets/Fighter_high_dbg.swf')]
//		private var Fighter_high_dbg:Class;
		
		[Embed(source = '../../assets/tiles2.gif')]
		private var tiles2:Class;
		
		[Embed(source = '../../assets/defense_tiles.gif')]
		private var defense_tiles:Class;
		
		[Embed(source = '../../assets/level3.xml')]
		private var level3:Class;
		
		[Embed(source = '../../assets/defense_lvl_1.xml')]
		private var defense_lvl_1:Class;
		
		public function AssetsManager( comm:EventDispatcher, assets:XML )
		{
			this._comm = comm;
			this._assets = assets;
			
			this._char = new Object;
			this._sfx = new Object;
			this._tile = new Object;
			this._data = new Object;
			
			totalNum = 0;
			loadedNum = 0;
			
//			_loaderContext = new LoaderContext( false, new ApplicationDomain(ApplicationDomain.currentDomain), null );
//			_queueLoader = new QueueLoader(false, _loaderContext );//false, addedDefinitions, true, "defaultQueue");
		}
		
		public function startLoading():void
		{
//			fromXML(assets);
			fromEmbed();
		}
		
		private function fromEmbed():void
		{
			var _fighter:CharAsset = new HarryTheOrc();// RedKnight();//
//			var _fighter_o:Object = _fighter.contentLoaderInfo.applicationDomain.getDefinition("ImageAsset");
//			var _tiles2:MultBitmap2 = new MultBitmap2(Bitmap(new tiles2()).bitmapData, 3, 3);
			var _tiles2:MultBitmap2 = new MultBitmap2(Bitmap(new tiles2() as Bitmap).bitmapData, 3, 3);
			var _defense_tiles:MultBitmap2 = new MultBitmap2(Bitmap(new defense_tiles()).bitmapData, 4, 5);
			var _level3:XML = XML(new level3());
			var _defense_lvl_1:XML = XML(new defense_lvl_1());
			
			this._char["Fighter_high"] = _fighter;
			this._tile["tiles"] = _tiles2;
			this._tile["defense_tiles"] = _defense_tiles;
			this._data["map"] = _level3;
			this._data["defense_map"] = _defense_lvl_1;
			
			
			this._comm.dispatchEvent( new GameEvent( GameEvent.FINISHED_LOADING ) );
		}
		
		private function fromXML( assets:XML ):void
		{
			
			for (var i:uint = 0; i < assets.asset.length(); i++)
			{
				var a:XML = assets.asset[i];
				trace( a.@id + " = " + a.@name + " | " + a.@type + " | " + a.@path );
//				_queueLoader.addItem(a.@path, null, { title:a.@name } );
				
				//var path:String = File.applicationDirectory.resolvePath(a.@path);
				/*
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
				loader.load(new URLRequest(a.@path));
				totalNum++;*/
			}
			
			
//			_queueLoader.addEventListener(QueueLoaderEvent.QUEUE_COMPLETE, finishedLoading, false, 0, false);
//			_queueLoader.execute();
			
		}
		
		public function onComplete(e:Event):void
		{
			loadedNum++;
			
			if (loadedNum == totalNum)
			{
				trace( "Terminal Loading" );
			}
			
		}
/*
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
*/	
		public function getTile(id:String):MultBitmap2
		{
			return this._tile[id];
		}
		
		public function getChar(id:String):CharAsset
		{
			return this._char[id];
		}
		
		public function getData(id:String):XML
		{
			return this._data[id];
		}
		
	}

}
