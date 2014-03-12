package julio.tactics.view 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import julio.AssetsManager;
	import julio.display.FpsDisplay;
	import julio.iso.CordsNode;
	import julio.iso.MultBitmap2;
	import julio.iso.Terrain;
	import julio.scenegraph.SceneGraph;
	import flash.ui.Keyboard;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import julio.tactics.GameTimer;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	/**
	 * ...
	 * @author Júlio Cézar M Menezes
	 */
	public class CenaEvento extends Sprite
	{
		// fps display
		public var FPS:FpsDisplay;
		
		private var gameTimer:GameTimer;
		
		// Graphics
		private var map:Terrain;
		private var scene:SceneGraph;
		private var timer:Timer;
		private var zoom:Number;
		private var view2id:uint
		private var assets:AssetsManager;
		
		// keyboard
		private var keyBoardKeys:Array;
		private var keyDelay:Number;
		private var cameraRotation:Number;
		
		public function CenaEvento(conm:EventDispatcher, assets:AssetsManager) 
		{
			scene = new SceneGraph(this);
			
			this.assets = assets;
			
			var cn:CordsNode = new CordsNode;
			
			view2id = 0;
			cameraRotation = 0;
			zoom = 1.0;
			
			scene.root.addChildNode(cn);
			
			scene.update(0);
			scene.defaultView.addNode(scene.root, true);
			
			this.gameTimer = new GameTimer;
			
			keyBoardKeys = new Array;
			for (var i:int = 0; i < 256; i++) {
				keyBoardKeys.push(false);
			}
			
			FPS = new FpsDisplay();
			FPS.x = 10;
			FPS.y = 10;
			
			this.addChild(FPS);
			
			buildMap();
			
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			timer = new Timer(40);
			timer.addEventListener(TimerEvent.TIMER, controle);
			timer.start();
			
			this.addEventListener(Event.ENTER_FRAME, render, false, 0, true);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress, false, 0, true);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease, false, 0, true);
			this.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseScroll, false, 0, true);
		
		}
		
		public function onMouseScroll(event:MouseEvent):void
		{
			zoom += event.delta*0.1;
			map.zoom(zoom, zoom, zoom);
		}
		
		public function controle(timerEvent:TimerEvent):void
		{
			gameTimer.refresh();
			
			var changed:Boolean = false;
			
			if (keyBoardKeys[Keyboard.LEFT])
			{
				scene.defaultView.x_pos -= 20;
			}
			if (keyBoardKeys[Keyboard.RIGHT])
			{
				scene.defaultView.x_pos += 20;
			}
			if (keyBoardKeys[Keyboard.UP])
			{
				scene.defaultView.y_pos -= 20;
			}
			if (keyBoardKeys[Keyboard.DOWN])
			{
				scene.defaultView.y_pos += 20;
			}
			
			if (keyBoardKeys[Keyboard.END])
			{
				zoom = 1.0;
				map.zoom(zoom, zoom, zoom);
			}
			
			if (keyBoardKeys[74]) // j
			{
				scene.getView(view2id).x_pos -= 20;
			}
			if (keyBoardKeys[76]) // l
			{
				scene.getView(view2id).x_pos += 20;
			}
			if (keyBoardKeys[73]) // i
			{
				scene.getView(view2id).y_pos -= 20;
			}
			if (keyBoardKeys[75]) // k
			{
				scene.getView(view2id).y_pos += 20;
			}
			
			if (keyDelay <= 0)
			{
				if (keyBoardKeys[81]) // q
				{
					cameraRotation++;
					keyDelay = 300;
					changed = true;
				}
				if (keyBoardKeys[69]) // e
				{
					cameraRotation--;
					keyDelay = 300;
					changed = true;
				}
			}
			
			if (changed)
				scene.root.local_rot_angle = Math.PI * (cameraRotation % 4) / 2;
			
			keyDelay -= gameTimer.timeDelta;
			scene.update(gameTimer.timeDelta);
		}
		
		public function render(framevent:Event):void
		{
			FPS.update();
		}
		
		public function onKeyPress(keyboardEvent:KeyboardEvent):void
		{
			keyBoardKeys[keyboardEvent.keyCode] = true;
		}
		
		public function onKeyRelease(keyboardEvent:KeyboardEvent):void
		{
			keyBoardKeys[keyboardEvent.keyCode] = false;
		}
		
		
		
		
		// cria o mapa
		//
		//
		public function buildMap():void
		{
			//	<grafo>
			//		<tile id="0" x="0" y="0" z="0" h="1" tipo="PLAIN" />
			//		<tile id="1" x="0" y="0" z="1" h="1" tipo="LAVA" />
			//		<arco origem="0" destino="1" tipo="SIMPLE"/>
			//	</grafo>
			
			var data:XML = <grafo name="levelTest">
						
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
					
					</grafo>;
			
			var multBitmap:MultBitmap2 = this.assets.getTile("tiles");
			
			map = new Terrain(data, multBitmap, new Vector3D(0, 0, 0), new Vector3D(0, 0, 0), new Vector3D(71.55, 16, 71.55), "map");
			map.local_pos_x = 0;
			map.local_pos_z = 0;
			scene.root.addChildNode(map);
			scene.root.update(0, new Matrix3D, true);
			scene.addToAllViews(map, true);
		}

		
	}

}