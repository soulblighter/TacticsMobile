package 
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import julio.resource.RedKnight;
	import julio.tactics.view.CenaBatalha;
	import julio.tactics.view.CenaEvento;
	import julio.tactics.regras.Basic.Batalha;
	import flash.events.EventDispatcher;
	import julio.tactics.events.GameEvent;
	import julio.AssetsManager;
	import julio.tactics.view.ConsoleView;
	
	
	/**
	 * ...
	 * @author Soulblighter
	 */
	public class Main extends Sprite 
	{
		// fps display
		public var _fpsText:TextField;
		public var _fpsLastTime:Number;
		public var _frameCount:Number;
		public var _FPS:Number;
		public var _fpsTimeElapsed:Number;
		public var _timer:Timer;
		public var _fpsCurrentTime:Number;
		public var _fpsTimeDelta:Number;
		
		private var gameData:XML;
		private var assetsData:XML;
		private var assets:AssetsManager;
		private var conm:EventDispatcher;
		
		public function Main():void 
		{
			conm = new EventDispatcher;
			
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// entry point
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			
			// new to AIR? please read *carefully* the readme.txt files!
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			// FPS
			_frameCount = 0;
			_FPS = 0;
			_fpsTimeElapsed = 0;
			_fpsLastTime = getTimer();
			_fpsText = new TextField();
			_fpsText.text = "0";
			_fpsText.selectable = false;
			_fpsText.textColor = 0xFF0000;
			_fpsText.x = 10;
			_fpsText.y = 10;
			
			//this.addChild(_fpsText);
			
//			_timer = new Timer(40);
//			_timer.addEventListener(TimerEvent.TIMER, controle);
//			_timer.start();
			
			
			conm.addEventListener(GameEvent.FINISHED_LOADING, initTactics, false, 0, false);
			assetsData =
						<assets>
							<asset id="0" name="Fighter_high"	type="char" path="../../assets/Fighter_high_dbg.swf"/>
							<asset id="2" name="tiles"			type="tile" path="../../assets/tiles2.gif" rows="3" cols="3"/>
							<asset id="3" name="defense_tiles"	type="tile" path="../../assets/defense_tiles.gif" rows="4" cols="3"/>
							<asset id="4" name="map"			type="graph" path="../../assets/level3.xml"/>
							<asset id="5" name="defense_map"	type="graph" path="../../assets/defense_lvl_1.xml"/>
						</assets>;
			assets = new AssetsManager(conm, assetsData);
			assets.startLoading();
			
			
			
			
//			this.addEventListener(Event.ENTER_FRAME, render, false, 0, true);
		}
		
		
		public function controle(event:Event):void
		{
			
		}
		
		
		public function render(framevent:Event):void
		{
			this._fpsCurrentTime = getTimer();
			this._fpsTimeDelta = this._fpsCurrentTime - this._fpsLastTime;
			this._fpsText.text = "FPS: " + String(Math.round(calcFPS(this._fpsTimeDelta) * 1000));
			this._fpsLastTime = this._fpsCurrentTime;
		}
		
		public function calcFPS(fpsTimeDelta:Number):Number
		{
			_frameCount++;
			_fpsTimeElapsed += _fpsTimeDelta
			if (_fpsTimeElapsed >= 1000.0)
			{
				_FPS = _frameCount / _fpsTimeElapsed;
				_fpsTimeElapsed = 0.0;
				_frameCount = 0;
			}
			return _FPS;
		}
		
		public function initTactics(e:GameEvent):void
		{
			conm.removeEventListener(GameEvent.FINISHED_LOADING, initTactics, false);
			gameData =
				<battle>
					<grafo name="levelTest">
						
						<tile id="0" x="0" y="0" z="0" h="1" tipo="PLAIN" />
						<tile id="1" x="0" y="0" z="1" h="1" tipo="PLAIN" />
						<tile id="2" x="0" y="0" z="2" h="1" tipo="PLAIN" />
						<tile id="3" x="0" y="0" z="3" h="1" tipo="PLAIN" />
						<tile id="4" x="0" y="0" z="4" h="1" tipo="PLAIN" />
						<tile id="5" x="0" y="0" z="5" h="1" tipo="PLAIN" />
						
						<tile id="6"  x="1" y="0" z="0" h="1" tipo="PLAIN" />
						<tile id="7"  x="1" y="0" z="1" h="1" tipo="PLAIN" />
						<tile id="8"  x="1" y="0" z="2" h="1" tipo="PLAIN" />
						<tile id="9"  x="1" y="0" z="3" h="1" tipo="PLAIN" />
						<tile id="10" x="1" y="0" z="4" h="1" tipo="PLAIN" />
						<tile id="11" x="1" y="0" z="5" h="1" tipo="PLAIN" />

						<tile id="12" x="2" y="0" z="0" h="1" tipo="PLAIN" />
						<tile id="13" x="2" y="0" z="1" h="1" tipo="PLAIN" />
						<tile id="14" x="2" y="0" z="2" h="1" tipo="PLAIN" />
						<tile id="15" x="2" y="0" z="3" h="1" tipo="PLAIN" />
						<tile id="16" x="2" y="0" z="4" h="1" tipo="PLAIN" />
						<tile id="17" x="2" y="0" z="5" h="1" tipo="PLAIN" />
						
						<tile id="18" x="3" y="0" z="0" h="1" tipo="PLAIN" />
						<tile id="19" x="3" y="0" z="1" h="1" tipo="PLAIN" />
						<tile id="20" x="3" y="0" z="2" h="1" tipo="PLAIN" />
						<tile id="21" x="3" y="0" z="3" h="1" tipo="PLAIN" />
						<tile id="22" x="3" y="0" z="4" h="1" tipo="PLAIN" />
						<tile id="23" x="3" y="0" z="5" h="1" tipo="PLAIN" />
						
						<tile id="24" x="4" y="0" z="0" h="1" tipo="PLAIN" />
						<tile id="25" x="4" y="0" z="1" h="1" tipo="PLAIN" />
						<tile id="26" x="4" y="0" z="2" h="1" tipo="PLAIN" />
						<tile id="27" x="4" y="0" z="3" h="1" tipo="PLAIN" />
						<tile id="28" x="4" y="0" z="4" h="1" tipo="PLAIN" />
						<tile id="29" x="4" y="0" z="5" h="1" tipo="PLAIN" />
						
						<tile id="30" x="5" y="0" z="0" h="1" tipo="PLAIN" />
						<tile id="31" x="5" y="0" z="1" h="1" tipo="PLAIN" />
						<tile id="32" x="5" y="0" z="2" h="1" tipo="PLAIN" />
						<tile id="33" x="5" y="0" z="3" h="1" tipo="PLAIN" />
						<tile id="34" x="5" y="0" z="4" h="1" tipo="PLAIN" />
						<tile id="35" x="5" y="0" z="5" h="1" tipo="PLAIN" />
						
						
						
						<arco origem="0" destino="1" tipo="SIMPLE"/>
						<arco origem="0" destino="6" tipo="SIMPLE"/>
						
						<arco origem="1" destino="2" tipo="SIMPLE"/>
						<arco origem="1" destino="7" tipo="SIMPLE"/>
						
						<arco origem="2" destino="3" tipo="SIMPLE"/>
						<arco origem="2" destino="8" tipo="SIMPLE"/>
						
						<arco origem="3" destino="4" tipo="SIMPLE"/>
						<arco origem="3" destino="9" tipo="SIMPLE"/>
						
						<arco origem="4" destino="5" tipo="SIMPLE"/>
						
						<arco origem="4" destino="10" tipo="SIMPLE"/>
						<arco origem="5" destino="11" tipo="SIMPLE"/>
						
						<arco origem="6" destino="7" tipo="SIMPLE"/>
						<arco origem="6" destino="12" tipo="SIMPLE"/>
						
						<arco origem="7" destino="8" tipo="SIMPLE"/>
						<arco origem="7" destino="13" tipo="SIMPLE"/>
						
						<arco origem="8" destino="9" tipo="SIMPLE"/>
						<arco origem="8" destino="14" tipo="SIMPLE"/>
						
						<arco origem="9" destino="15" tipo="SIMPLE"/>
						
						<arco origem="9" destino="10" tipo="SIMPLE"/>
						
						<arco origem="10" destino="11" tipo="SIMPLE"/>
						<arco origem="10" destino="16" tipo="SIMPLE"/>
						<arco origem="11" destino="17" tipo="SIMPLE"/>
						
						<arco origem="12" destino="13" tipo="SIMPLE"/>
						<arco origem="12" destino="18" tipo="SIMPLE"/>
						
						<arco origem="13" destino="14" tipo="SIMPLE"/>
						<arco origem="13" destino="19" tipo="SIMPLE"/>
						
						<arco origem="14" destino="15" tipo="SIMPLE"/>
						<arco origem="14" destino="20" tipo="SIMPLE"/>
						
						<arco origem="15" destino="16" tipo="SIMPLE"/>
						<arco origem="15" destino="21" tipo="SIMPLE"/>
						
						<arco origem="16" destino="17" tipo="SIMPLE"/>
						<arco origem="16" destino="22" tipo="SIMPLE"/>
						
						<arco origem="17" destino="23" tipo="SIMPLE"/>
						
						
						<arco origem="18" destino="19" tipo="SIMPLE"/>
						<arco origem="18" destino="24" tipo="SIMPLE"/>
						
						<arco origem="19" destino="20" tipo="SIMPLE"/>
						<arco origem="19" destino="25" tipo="SIMPLE"/>
						
						<arco origem="20" destino="21" tipo="SIMPLE"/>
						<arco origem="20" destino="26" tipo="SIMPLE"/>
						
						<arco origem="21" destino="22" tipo="SIMPLE"/>
						<arco origem="21" destino="27" tipo="SIMPLE"/>
						
						<arco origem="22" destino="23" tipo="SIMPLE"/>
						<arco origem="22" destino="28" tipo="SIMPLE"/>
						
						<arco origem="23" destino="29" tipo="SIMPLE"/>
						
						
						<arco origem="24" destino="25" tipo="SIMPLE"/>
						<arco origem="24" destino="30" tipo="SIMPLE"/>
						
						<arco origem="25" destino="26" tipo="SIMPLE"/>
						<arco origem="25" destino="31" tipo="SIMPLE"/>
						
						<arco origem="26" destino="27" tipo="SIMPLE"/>
						<arco origem="26" destino="32" tipo="SIMPLE"/>
						
						<arco origem="27" destino="28" tipo="SIMPLE"/>
						<arco origem="27" destino="33" tipo="SIMPLE"/>
						
						<arco origem="28" destino="29" tipo="SIMPLE"/>
						<arco origem="28" destino="34" tipo="SIMPLE"/>
						
						<arco origem="29" destino="35" tipo="SIMPLE"/>
						
						
						<arco origem="30" destino="31" tipo="SIMPLE"/>
						
						<arco origem="31" destino="32" tipo="SIMPLE"/>
						
						<arco origem="32" destino="33" tipo="SIMPLE"/>
						
						<arco origem="33" destino="34" tipo="SIMPLE"/>
						
						<arco origem="34" destino="35" tipo="SIMPLE"/>
						
						
						<!--/*<arco origem="12" destino="14" tipo="DJUMP"/>
						<arco origem="32" destino="34" tipo="DJUMP"/>*/-->
					
					</grafo>
					
					<team id="0" name="PlayerTeam">
						<char id="0" pos="0">
							<display assetID="0"/>
							<personagem>
								<ST>10</ST>
								<DX>10</DX>
								<IQ>10</IQ>
								<HT>10</HT>
							</personagem>
						</char>
					</team>
					
					<team id="0" name="MonsterTeam">
						<char id="1" pos="1">
							<display assetID="1"/>
							<personagem>
							
							</personagem>
						</char>
					</team>
					
				</battle>;
			
			this.addChild(new CenaBatalha(conm, assets));
			this.addChild(new ConsoleView(conm, assets));
			
			var b:Batalha = new Batalha(conm, gameData);
			b.run();
			
			//this.addChild(new CenaEvento(conm, assets));
		}
		
	}
	
}