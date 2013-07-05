package julio.tactics.view
{
	import away3d.core.math.Matrix3D;
	import away3d.core.math.Number2D;
	import away3d.core.math.Number3D;
	import away3d.core.math.Quaternion;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import gs.*;
	import gs.easing.*;
	import gs.plugins.*;
	import julio.AssetsManager;
	import julio.iso.*;
	import julio.iso.events.TerrainBlockEvent;
	import julio.resource.CharAsset;
	import julio.scenegraph.*;
	import julio.tactics.*;
//	import julio.tactics.display.ActionsPanel;
//	import julio.tactics.display.CombatLog;
	import julio.tactics.events.ActionPanelEvent;
	import julio.tactics.events.BattleEvent;
	import julio.tactics.events.DisplayEvent;
	import julio.tactics.regras.GlobalDispatcher;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class CenaBatalha extends Sprite
	{
		[Bindable]
		public var inputData:XML;
		
		private var _gameTimer:GameTimer;
		private var _clickDelay:Number; // tempo para reconhecer um botao apertado depois do outro
//		private var _batalha:Batalha;
		private var _zoom:Number;
		
		// fps display
		public var _fpsText:TextField;
		public var _fpsLastTime:Number;
		public var _frameCount:Number;
		public var _FPS:Number;
		public var _fpsTimeElapsed:Number;
		public var _timer:Timer;
		public var _fpsCurrentTime:Number;
		public var _fpsTimeDelta:Number;
		
		private var count:Number;
		private var map:Terrain;
		private var tileSize:Number3D;
		private var scene:SceneGraph;
		private var charsNode:Object;
		private var displayQueue:Array;
		private var displayLock:Boolean;
		private var view2id:uint
		
		// keyboard
		private var _keyBoardKeys:Array;
		private var _keyDelay:Number;
		
//		private var _container:Group;
		
		// combat log
//		private var combatlog:CombatLog;
		
		// communicator
		private var _conm:EventDispatcher;
		
		// assets manager
		private var _assets:AssetsManager;
		
		//
//		private var _actionPanel:ActionsPanel;
		
		private var myLine:Shape;
		
		
/*		// Dados enviados pelo servidor
		private var lastEvent:DisplayEvent;
		private var subjectID:uint;				// ID do personagem atual
//		private var subject:Char;				// personagem atual
		private var subjAction:uint;			// ID da ação
		private var subjSelectedTarget:uint;	// id do alvo
		private var subjActionList:XML;			// Lista de IDs de ações disponíveis do personagem atual
		*/
		
		public function CenaBatalha(conm:EventDispatcher, assets:AssetsManager)
		{
			super();
			
			this._conm = conm;
			this._assets = assets;
			
			_zoom = 1.0;
			
//			_container = new Group;
			
//			combatlog = new CombatLog;
//			combatlog.x = 500;
//			combatlog.y = 30;
//			combatlog.width = 350;
//			combatlog.height = 150;
			
			this._gameTimer = new GameTimer;
			
			_keyDelay = 0;
			_keyBoardKeys = new Array;
			for (var i_:int = 0; i_ < 256; i_++)
				_keyBoardKeys.push(false);
			
			this._clickDelay = 100;
			
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
			
			displayQueue = new Array;
			displayLock = false;
			
			view2id = 0;
			
			count = 0;
			
			scene = new SceneGraph(this);
			
			charsNode = new Object;
			
			var cn:CordsNode = new CordsNode;
			
			scene.root.addChildNode(cn);
			
			scene.update(0);
			scene.defaultView.addNode(scene.root, true);
			
//			this.addChild(combatlog);
			this.addChild(_fpsText);
			TweenPlugin.activate([BezierPlugin]);
			
			scene.defaultView.x_pos -= 400;
			scene.defaultView.y_pos -= 200;
			
			this._conm.addEventListener(DisplayEvent.TURN_START, processEvent, false, 0, true);
			this._conm.addEventListener(DisplayEvent.GET_ACTION, processEvent, false, 0, true);
			this._conm.addEventListener(DisplayEvent.MAP, processEvent, false, 0, true);
			this._conm.addEventListener(DisplayEvent.ADD_CHAR, processEvent, false, 0, true);
			this._conm.addEventListener(DisplayEvent.MOVE, processEvent, false, 0, true);
			this._conm.addEventListener(DisplayEvent.ACTION, processEvent, false, 0, true);
			
			this._conm.addEventListener(DisplayInstruction.MAP, addToDisplayQueue, false, 0, true);
			this._conm.addEventListener(DisplayInstruction.ADD_CHAR, addToDisplayQueue, false, 0, true);
			this._conm.addEventListener(DisplayInstruction.MOVE, addToDisplayQueue, false, 0, true);
			this._conm.addEventListener(DisplayInstruction.MOVE_CAMERA, addToDisplayQueue, false, 0, true);
			this._conm.addEventListener(DisplayInstruction.MOVE_MAP, addToDisplayQueue, false, 0, true);
			this._conm.addEventListener(DisplayInstruction.ANIMATION, addToDisplayQueue, false, 0, true);
			this._conm.addEventListener(DisplayInstruction.LOOK, addToDisplayQueue, false, 0, true);
			this._conm.addEventListener(DisplayInstruction.SHOW_DAMAGE, addToDisplayQueue, false, 0, true);
			this._conm.addEventListener(DisplayInstruction.WAIT, addToDisplayQueue, false, 0, true);
//			this._conm.addEventListener( DisplayInstruction.GET_TARGET, addToDisplayQueue, false, 0, true );
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
//			startGC();
			
			_timer = new Timer(40);
			_timer.addEventListener(TimerEvent.TIMER, controle);
			_timer.start();
			
			this.addEventListener(Event.ENTER_FRAME, render, false, 0, true);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress, false, 0, true);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease, false, 0, true);
			this.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseScroll, false, 0, true);
//			this.stage.addEventListener(MouseEvent., onMouseMidleClick, false, 0, true);
		
		}
		
		public function onMouseScroll(event:MouseEvent):void
		{
			_zoom += event.delta*0.1;
			map.zoom(_zoom, _zoom, _zoom);
		}
		
		public function controle(timerEvent:TimerEvent):void
		{
			_gameTimer.refresh();
			
			var changed:Boolean = false;
			
			if (_keyBoardKeys[Keyboard.LEFT])
			{
				scene.defaultView.x_pos -= 20;
			}
			if (_keyBoardKeys[Keyboard.RIGHT])
			{
				scene.defaultView.x_pos += 20;
			}
			if (_keyBoardKeys[Keyboard.UP])
			{
				scene.defaultView.y_pos -= 20;
			}
			if (_keyBoardKeys[Keyboard.DOWN])
			{
				scene.defaultView.y_pos += 20;
			}
			
/*			
			if (_keyBoardKeys[Keyboard.PAGE_UP])
			{
				_zoom += 0.1;
				map.zoom(_zoom, _zoom, _zoom);
			}
			if (_keyBoardKeys[Keyboard.PAGE_DOWN])
			{
				_zoom -= 0.1;
				map.zoom(_zoom, _zoom, _zoom);
			}*/
			if (_keyBoardKeys[Keyboard.END])
			{
				_zoom = 1.0;
				map.zoom(_zoom, _zoom, _zoom);
			}
			
/*
			if (map)
			{
				if (_keyBoardKeys[65]) // a
				{
					map.local_pos_x -= 10;
				}
				if (_keyBoardKeys[68]) // d
				{
					map.local_pos_x += 10;
				}
				if (_keyBoardKeys[87]) // w
				{
					map.local_pos_z -= 10;
				}
				if (_keyBoardKeys[83]) // s
				{
					map.local_pos_z += 10;
				}
			}
*/
			if (_keyBoardKeys[74]) // j
			{
				scene.getView(view2id).x_pos -= 20;
			}
			if (_keyBoardKeys[76]) // l
			{
				scene.getView(view2id).x_pos += 20;
			}
			if (_keyBoardKeys[73]) // i
			{
				scene.getView(view2id).y_pos -= 20;
			}
			if (_keyBoardKeys[75]) // k
			{
				scene.getView(view2id).y_pos += 20;
			}
			
			if (_keyDelay <= 0)
			{
				if (_keyBoardKeys[81]) // q
				{
					count++;
					_keyDelay = 300;
					changed = true;
				}
				if (_keyBoardKeys[69]) // e
				{
					count--;
					_keyDelay = 300;
					changed = true;
				}
			}
			
			if (changed)
				scene.root.local_rot_angle = Math.PI * (count % 4) / 2; // new Quaternion(0, 1, 0, Math.PI * ( count % 4) / 2);
			
			// personagem jah deve ser posicionado na altura correta na criação/ações
//			for each( var csn:CharSpriteNode in this.charsNode )
			//if ( csn.local_pos_y != map.getHeight( csn.local_pos_x, csn.local_pos_z ) )
//					csn.local_pos_y = map.getHeight( csn.local_pos_x, csn.local_pos_z );
			
			_keyDelay -= _gameTimer.timeDelta;
			scene.update(_gameTimer.timeDelta);
		/*
		   if ( view2id != 0 && charsNode["0"] )
		   {
		   scene.getView(view2id).x_pos = charsNode["0"].flashPos_x + 35;
		   scene.getView(view2id).y_pos = charsNode["0"].flashPos_y + 20;
		   }
		 */
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
		
		public function onKeyPress(keyboardEvent:KeyboardEvent):void
		{
			_keyBoardKeys[keyboardEvent.keyCode] = true;
		}
		
		public function onKeyRelease(keyboardEvent:KeyboardEvent):void
		{
			_keyBoardKeys[keyboardEvent.keyCode] = false;
		}
		
		private function centerCameraOn(x:int, y:int):void
		{
			TweenMax.to(scene.defaultView, 2, {x_pos: x - 400, y_pos: y - 300, ease: Expo.easeOut});
		}
		
//		private function centerMapOn( x:int, z:int ):void
//		{
//			TweenMax.to( map, 2, {local_pos_x:(-x*map.size.x-map.size.x/2), local_pos_z:(-z*map.size.z-map.size.z/2), ease:Expo.easeOut});
//		}
		
		private function centerMapOn(x:int, y:int, z:int):void
		{
			TweenMax.to(map, 2, {local_pos_x: (-x * map.size.x - map.size.x / 2), local_pos_y: (-y * map.size.y - map.size.y / 2), local_pos_z: (-z * map.size.z - map.size.z / 2), ease: Expo.easeOut});
		}
		
		// events sends by battle server
		private function processEvent(e:DisplayEvent):void
		{
			switch (e.type)
			{
				case DisplayEvent.MAP:
					_conm.dispatchEvent(new DisplayInstruction(DisplayInstruction.MAP, e.data));
					break;
				
				case DisplayEvent.ADD_CHAR:
					_conm.dispatchEvent(new DisplayInstruction(DisplayInstruction.ADD_CHAR, e.data));
					break;
				
				case DisplayEvent.TURN_START:
//					this.combatlog.addLog("Começou o turno de " + e.data.@charID);
					break;
				
				case DisplayEvent.GET_ACTION:
					_conm.dispatchEvent(new DisplayInstruction(DisplayInstruction.MOVE_MAP,  <mapa type="char" id={e.data.@charID} />));//<camera type="char" id={e.data.@charID}/>));
					break;
				
				case DisplayEvent.MOVE:
					_conm.dispatchEvent(new DisplayInstruction(DisplayInstruction.MOVE, e.data));
					break;
				
				case DisplayEvent.ACTION:
					// <display actionID="1" subject="0" object="1" result="hit" damage={danoFinal} />
					// <display actionID="1" subject="0" object="1" result="miss" />
					switch(uint(e.data.@actionID))
					{
						case 1: // basic melee attack
							if (e.data.@result == "hit")
							{
								//	<animation target="joao" value="run" reset="true" play="true" loop="true"/>
								// <look target="0" from="15" to="17"/>
								// <damage target="0" value="15" color="0xff0000" duration="2"/>
								
								//  attacante vira para direção do alvo
								_conm.dispatchEvent(new DisplayInstruction(DisplayInstruction.LOOK, <look target={e.data.@subject} from={e.data.@subjectPos} to={e.data.@objectPos}/>));
								
								// atacante muda de animação para attack
								_conm.dispatchEvent(new DisplayInstruction(DisplayInstruction.ANIMATION, <animation target={e.data.@subject} value="attack" reset="true" play="true" loop="false"/>, true));
								// alvo muda de animação para hit
								_conm.dispatchEvent(new DisplayInstruction(DisplayInstruction.ANIMATION, <animation target={e.data.@object} value="hit" reset="true" play="true" loop="false"/>, true));
								// mostra dano
								_conm.dispatchEvent(new DisplayInstruction(DisplayInstruction.SHOW_DAMAGE, <damage target={e.data.@object} value={e.data.@damage} color="0xff0000" duration="2"/>, true));
							} else if (e.data.@result == "miss")
							{
								//  attacante vira para direção do alvo
								_conm.dispatchEvent(new DisplayInstruction(DisplayInstruction.LOOK, <look target={e.data.@subject} from={e.data.@subjectPos} to={e.data.@objectPos}/>));
								
								// atacante muda de animação para attack
								_conm.dispatchEvent(new DisplayInstruction(DisplayInstruction.ANIMATION, <animation target={e.data.@subject} value="attack" reset="true" play="true" loop="false"/>, true));
								// alvo muda de animação para hit
//								_conm.dispatchEvent(new DisplayInstruction(DisplayInstruction.ANIMATION, <animation target={e.data.@object} value="hit" reset="true" play="true" loop="false"/>, true));
								// mostra dano
								_conm.dispatchEvent(new DisplayInstruction(DisplayInstruction.SHOW_DAMAGE, <damage target={e.data.@object} value="miss" color="0x0000ff" duration="2"/>, true));
							}
							break;
					}
					break;
				
				default:
//					this.combatlog.addLog("Invalid event: " + e.type);
			}
		}
		
		// funções q controlam a ordem de como os efeitos grafico ocorrem
		public function addToDisplayQueue(e:DisplayInstruction):void
		{
			if (this.displayLock == true)
			{
				this.displayQueue.push(e);
			}
			else
			{
				
				executeDisplayEvent(e);
			}
		}
		
		private function executeDisplayEvent(e:DisplayInstruction):void
		{
			if (!e.imediato)
				this.displayLock = true;
			
			var i:InstructionInterpreter = new InstructionInterpreter(e);
			
			switch (e.type)
			{
				case DisplayInstruction.MAP:
					i.instruction = buildMap;
					break;
				case DisplayInstruction.ADD_CHAR:
					i.instruction = addChar;
					break;
				case DisplayInstruction.MOVE:
					i.instruction = actionMove;
					break;
				case DisplayInstruction.MOVE_CAMERA:
					i.instruction = moveCamera;
					break;
				case DisplayInstruction.MOVE_MAP:
					i.instruction = moveMapa;
					break;
				case DisplayInstruction.ANIMATION:
					i.instruction = mudarAnimacao;
					break;
				case DisplayInstruction.LOOK:
					i.instruction = lookTo;
					break;
				case DisplayInstruction.SHOW_DAMAGE:
					i.instruction = showDamage;
					break;
				case DisplayInstruction.WAIT:
					i.instruction = waitTime;
					break;
				case DisplayInstruction.GET_ACTION:
					i.instruction = getAction;
					break;
//				case DisplayInstruction.GET_TARGET:	i.instruction = actionTileSelect; break;
				
				default:
					throw new Error("\"" + e.type + "\" não eh um tipo de DisplayInstruction válido!");
			}
			
			if (e.imediato)
				i.endExecution = endOfDisplayEventImediate;
			else
				i.endExecution = endOfDisplayEvent;
			
			i.startExecution();
		}
		
		private function endOfDisplayEvent():void
		{
			this.displayLock = false;
			while (this.displayQueue.length > 0)
			{
				var di:DisplayInstruction = displayQueue.shift();
				
				executeDisplayEvent(di);
//				addToDisplayQueue( di );
				
				if (di.imediato == false)
					break;
			}
		}
		
		private function endOfDisplayEventImediate():void
		{
		
		}
		
		// cria o mapa
		//
		//
		public function buildMap(data:XML, i:InstructionInterpreter):void
		{
			//	<grafo>
			//		<tile id="0" x="0" y="0" z="0" h="1" tipo="PLAIN" />
			//		<tile id="1" x="0" y="0" z="1" h="1" tipo="LAVA" />
			//		<arco origem="0" destino="1" tipo="SIMPLE"/>
			//	</grafo>
			var multBitmap:MultBitmap2 = this._assets.getTile("tiles");
			tileSize = new Number3D(71.55, 16, 71.55);
			
			map = new Terrain(data, multBitmap, new Number3D(0, 0, 0), new Quaternion(0, 0, 0, 0), new Number3D(tileSize.x, tileSize.y, tileSize.z), "map");
			map.local_pos_x = 0;
			map.local_pos_z = 0;
			scene.root.addChildNode(map);
			scene.root.update(0, Matrix3D.IDENTITY, true);
			scene.addToAllViews(map, true);
			
			i.endExecution(); // endOfDisplayEvent();
		}
		
		// adiciona um personagem ao jogo
		private function addChar(data:XML, i:InstructionInterpreter):void
		{
			//	<char id="0" pos="0"> <display asset="Fighter_high"/> </char>
			
//			var assetClass:Class = _queueLoader.getItemByTitle(data.display.@asset).loader.contentLoaderInfo.applicationDomain.getDefinition("ImageAsset");
			var assetClass:CharAsset = this._assets.getChar(String(data.display.@asset));
			
			var pos3d:Number3D = map.getPos(data.@pos);
			var char_x:int = pos3d.x;
			var char_z:int = pos3d.z;
			var char_y:int = pos3d.y; // map.getHeight(char_x, char_y); //
			
			if (!assetClass.isCached())
				assetClass.cache();
			
			var cNode:CharSpriteNode = new CharSpriteNode(assetClass, new Number3D(char_x * tileSize.x + tileSize.x / 2, char_y * tileSize.y, char_z * tileSize.z + tileSize.z / 2), new Quaternion(0, 1, 0, Math.PI / 2), new Number3D(30, 70, 30), data.@id);
//			cNode.local_pos_y = char_y*map.size.y; // map.getHeight( cNode.local_pos_x, cNode.local_pos_z );
//			cNode.update(0, new Matrix3D, false);
			cNode.changeAnimation("running");
			cNode.AnimTime = 500;
			cNode.play(-1);
			//cNode.gotoAndStop(0);
//			cNode.stop();
			cNode.dispatcher = GlobalDispatcher.dispatcher;
			
			map.addChildNode(cNode);
//			scene.defaultView.addNode( cNode, true );
			scene.addToAllViews(cNode, true);
			charsNode[data.@id] = cNode;
			
//			BindingUtils.bindProperty( scene.getView(view2id), "x_pos",  charsNode[data.@id], "flashPos_x" );
//			BindingUtils.bindProperty( scene.getView(view2id), "y_pos",  charsNode[data.@id], "flashPos_y" );
			
			scene.update(0);
			
//			combatlog.addLog("Char \"" + data.@id + "\" addeded");
			
			i.endExecution(); // endOfDisplayEvent();
		}
		
		private function anguloEntreVetores(a:Number2D, b:Number2D):Number
		{
			var x:Number = Math.acos(((a.x * b.x) + (a.y * b.y)) / (a.modulo * b.modulo));
			return b.y >= 0 ? x : -x;
		}
		
		// personagem anda pelo cenário
		private function actionMove(data:XML, i:InstructionInterpreter):void
		{
			//	[old] exemplo: <move target="0" track="0,1,2,3,9,10,11" animation="run"/> // contem a origem no track
			//	exemplo:
			//	<move target="0" animation="run" start="0">
			//		<step type="HJUMP" value="1"/>
			//		<step type="SIMPLE" value="2"/>
			//		<step type="DJUMP" value="4"/>
			//		<step type="DJUMP" value="16"/>
			//		<step type="SIMPLE" value="15"/>
			//	</move>
			const TIME_STEP:Number = 1.0;
			
			var char:CharSpriteNode = charsNode[data.@target];
			
			// garda a posição antiga do personagem
			var old_pos:Number3D = map.getPos(uint(data.@start));
			
			myLine = new Shape();
			myLine.graphics.lineStyle(10, 0x00ffff);
			this.addChild(myLine);
			
			var dbg1:Number = IsoTools.iso2xFla(old_pos.x * tileSize.x + tileSize.x / 2, old_pos.y * tileSize.y, old_pos.z * tileSize.z + tileSize.z / 2);
			var dbg2:Number = IsoTools.iso2yFla(old_pos.x * tileSize.x + tileSize.x / 2, old_pos.y * tileSize.y, old_pos.z * tileSize.z + tileSize.z / 2);
			
			myLine.graphics.moveTo(dbg1 - scene.defaultView.x_pos, dbg2 - scene.defaultView.y_pos);
			
			var tweenerArray:Array = new Array;
			for each (var a:XML in data.step)
			{
				var pos:Number3D = map.getPos(uint(a.@value));
				
				var radian:Number = anguloEntreVetores(new Number2D(1, 0), new Number2D(pos.x - old_pos.x, pos.z - old_pos.z));
				
				// gira personagem para nova direção
				tweenerArray.push({target: char, time: 0.1, local_rot_angle: -radian + Math.PI / 2});
				
				switch (String(a.@type))
				{
					case "SIMPLE":
//					tweenerArray.push( {	target:char, time:TIME_STEP,
//											local_pos_x:( pos.x * map.size.x + map.size.x / 2),
//											local_pos_y:( pos.y ),
//											local_pos_z:( pos.z * map.size.z + map.size.z / 2),
//											ease:Linear.easeNone } );
						// posição final
						var x0:Number = pos.x * tileSize.x + tileSize.x / 2;
						var y0:Number = pos.y * tileSize.y;
						var z0:Number = pos.z * tileSize.z + tileSize.z / 2;
						
						tweenerArray.push({target: char, time: TIME_STEP, bezierThrough: [ //{ local_pos_x:old_pos.x * map.size.x + map.size.x / 2, local_pos_y:old_pos.y, local_pos_z:old_pos.z * map.size.z + map.size.z / 2 },
								{local_pos_x: x0, local_pos_y: y0, local_pos_z: z0}], ease: Linear.easeNone});
//															orientToBezier:[["local_pos_x", "local_pos_z", "local_rot_angle", -90/180*Math.PI]] } );
						
						myLine.graphics.lineTo(IsoTools.iso2xFla(x0, y0, z0) - scene.defaultView.x_pos, IsoTools.iso2yFla(x0, y0, z0) - scene.defaultView.y_pos);
						break;
					case "HJUMP":
					case "DJUMP":
						// pega a posição média entre a posição anterior o a nova
						var x1:Number = (pos.x + old_pos.x) / 2 * tileSize.x + tileSize.x / 2;
						var y1:Number = Math.max(pos.y, old_pos.y) * tileSize.y + tileSize.y / 2;
						var z1:Number = (pos.z + old_pos.z) / 2 * tileSize.z + tileSize.z / 2;
						
						// posição final
						var x2:Number = pos.x * tileSize.x + tileSize.x / 2;
						var y2:Number = pos.y * tileSize.y;
						var z2:Number = pos.z * tileSize.z + tileSize.z / 2;
						
						tweenerArray.push({target: char, time: TIME_STEP, bezierThrough: [ //{ local_pos_x:old_pos.x * map.size.x + map.size.x / 2, local_pos_y:old_pos.y, local_pos_z:old_pos.z * map.size.z + map.size.z / 2 },
								{local_pos_x: x1, local_pos_y: y1, local_pos_z: z1}, {local_pos_x: x2, local_pos_y: y2, local_pos_z: z2}], ease: Expo.easeIn});
//															orientToBezier:[["local_pos_x", "local_pos_z", "local_rot_angle", -90/180*Math.PI]], ease:Expo.easeIn } );
						
						myLine.graphics.curveTo(IsoTools.iso2xFla(x1, y1, z1) - scene.defaultView.x_pos, IsoTools.iso2yFla(x1, y1, z1) - scene.defaultView.y_pos, IsoTools.iso2xFla(x2, y2, z2) - scene.defaultView.x_pos, IsoTools.iso2yFla(x2, y2, z2) - scene.defaultView.y_pos);
						break;
				}
				old_pos = pos;
			}
			
			charsNode[data.@target].animation = data.@animation;
			charsNode[data.@target].play(-1);
//			charsNode[data.@target].AnimTime = 2000;
			
			var myGroup:TweenGroup = new TweenGroup(tweenerArray, TweenMax, TweenGroup.ALIGN_SEQUENCE);
			myGroup.onComplete = actionMoveEnd;
			myGroup.onCompleteParams = [data, i];
		}
		
		private function actionMoveEnd(data:XML, i:InstructionInterpreter):void
		{
			this.removeChild(myLine);
			myLine = null;
			charsNode[data.@target].animation = "attack";
			charsNode[data.@target].gotoAndStop(0);
//			charsNode[data.@target].AnimTime = 2000;
			
			i.endExecution(); // endOfDisplayEvent();
			// GlobalDispatcher.dispatchEvent( new BattleEvent(BattleEvent.RETURN) );
		}
		
		// Move a posição da camera
		private function moveCamera(data:XML, i:InstructionInterpreter):void
		{
			//	<camera type="char" id="1"/>
			
			if (String(data.@type) == "char")
			{
				var char:CharSpriteNode = charsNode[String(data.@id)];
				centerCameraOn(char.flashPos_x, char.flashPos_y);
			}
			if (String(data.@type) == "tile")
			{
				var block:TerrainBlock = map.searchChildNodeByName("t" + String(data.@id), false) as TerrainBlock;
				centerCameraOn(block.flashPos_x, char.flashPos_y);
			}
			
			i.endExecution(); // endOfDisplayEvent();
		}
		
		// Move a posição do mapa
		private function moveMapa(data:XML, i:InstructionInterpreter):void
		{
			//	<mapa type="tile" id="10"/>
			
			if (String(data.@type) == "char")
			{
				var char:CharSpriteNode = charsNode[String(data.@id)];
				centerMapOn(char.final_pos_x, char.final_pos_y, char.final_pos_z);
			}
			if (String(data.@type) == "tile")
			{
				var block:TerrainBlock = map.searchChildNodeByName("t" + String(data.@id), false) as TerrainBlock;
				centerMapOn(block.final_pos_x, block.final_pos_y, block.final_pos_z);
			}
			
			//centerMapOn(data.@x, data.@y, data.@z);
			
			i.endExecution(); // endOfDisplayEvent();
		}
		
		// muda a aniamação do personagem
		private function mudarAnimacao(data:XML, i:InstructionInterpreter):void
		{
			// requisitos:
			// mudar de animação pelo nome
			// determinar o objecto que terá sua animação alterada
			// se a animação deve ter um loop, e quantas vezes deve repedir
			// tempo q a animação deve durar
			// quando a animação acabar, poder determinar outra animação em seguida,
			//		ou se a animação anterior deve continuar
			// poder determinar quantos % da animação deve ser feita
			
			//	<animation target="0" value="hit" loop="2" time="500" from="30" to="70" />
			
			// ppersonagem com ID "0",			// ID do target q vai ter sua animação alterada
			// muda para animação "hit",		// nome da animação
			// faz a animação infinitas vezes,	// -1 para loop infinito, 0 pra n repetir e >0 pra quantidade exata
			// a animação deve durar 500 milesegundos	// tempo total da animação
			//		(no caso, por causa do loop=2 ele vai executar cada animação em meio segundo num total de 1 segundo)
			// no final da animção ele deve mudar pra animação "run"	// "default" muda pra animação anterior, outro valor muda pra animação especifica
			// começa a partir de 30%
			// e deve fazer ate 70% da animação		// um valor entre 0% e 100%, a animação será feita somente até 70% dos frames
			//		// ex.: se a animação tem 20 frames começa do frame 6 e termina no frame 14
			// resumindo, faz a nimação hit 2 vezes começanco do frame 30% até o 70%, tudo em 1 em segundo (time * loop)
			
			//	<animation target="1" value="run" reset="true" play="true" loop="true"/>
			
			var char:CharSpriteNode = charsNode[data.@target];
			
			char.animation = data.@value;
			
//			if( Boolean(data.@reset) )
			char.resetAnim();
			
			if (uint(data.@time))
				char.AnimTime = uint(data.@time);
			
			if (Boolean(data.@play))
				char.play(int(data.@loop));
			
			i.endExecution(); // endOfDisplayEvent();
		}
		
		// muda a direção do personagem, a direção eh encontrada baseada nas posições de "from" e "to"
		private function lookTo(data:XML, i:InstructionInterpreter):void
		{
			// <look target="0" from="15" to="17"/>
			
			var char:CharSpriteNode = charsNode[data.@target];
			
			var from:Number3D = map.getPos(uint(data.@from));
			var to:Number3D = map.getPos(uint(data.@to));
			
			var radian:Number = anguloEntreVetores(new Number2D(1, 0), new Number2D(to.x - from.x, to.z - from.z));
			
			// gira personagem para nova direção
			char.local_rot_angle = -radian + Math.PI / 2;
			
			i.endExecution(); // endOfDisplayEvent();
		}
		
		// mostra dano
		private function showDamage(data:XML, i:InstructionInterpreter):void
		{
			// <damage target="0" value="15" color="0xff0000" duration="2"/>
			
//			combatlog.addLog("Damage: " + data.@value);
			
			var char:CharSpriteNode = charsNode[data.@target];
			
			var text:TextField = new TextField;
			text.text = data.@value;
			text.selectable = false;
			text.textColor = int(data.@color);
			text.x = IsoTools.iso2xFla(char.final_pos_x, char.final_pos_y, char.final_pos_z) + 400;
			text.y = IsoTools.iso2yFla(char.final_pos_x, char.final_pos_y, char.final_pos_z) + 200 - char.size.y;
			
			this.addChild(text);
			
			TweenMax.to(text, Number(data.@duration), {y: text.y - 20, ease: Expo.easeOut, onComplete: endShowDamage, onCompleteParams: [data, i, text]});
		}
		
		private function endShowDamage(data:XML, i:InstructionInterpreter, text:TextField):void
		{
			this.removeChild(text);
			i.endExecution(); // endOfDisplayEvent();
		}
		
		// espera tempo determinado
		private function waitTime(data:XML, i:InstructionInterpreter):void
		{
			// <wait time="5"/>
//			var tween:TweenMax = new TweenMax(
			TweenMax.to(this, Number(data.@time), {onComplete: endWaitTime, onCompleteParams: [data, i]});
		}
		
		private function endWaitTime(data:XML, i:InstructionInterpreter):void
		{
			i.endExecution(); // endOfDisplayEvent();
		}
		
		// escolha ação de uma lista
		private function getAction(data:XML, i:InstructionInterpreter):void
		{
			// mostra menu de opções
			// espera usuario selecionar ação
			// addEventListener( TurnEvent.ACTION_SELECT, actionSelected, true, 0, true );
			
			// pega a lista de ações disponiveis para esse personagem
			var acoes:XML = data;
			
//			if ( subj.char.acaoPadrao == false && subj.char.acaoMovimento == false )
//			{
//				var be:BattleEvent = new BattleEvent( BattleEvent.RETURN );
//				be.data = <return><actionId>0</actionId></return>;
//			}
//			else
//			{

//			_actionPanel = new ActionsPanel(acoes);
//			_actionPanel.x = 50;
//			_actionPanel.y = 200;
			
//			this.addChild(_actionPanel);
//			_actionPanel.addEventListener(ActionPanelEvent.ACTION_SELECTED, actionSelected);
//			}
			i.endExecution();
		}
		
		private function actionSelected(e:ActionPanelEvent):void
		{
//			trace("CenaBatalha::actionSelected( "+e.actionId+" )");
//			_actionPanel.removeEventListener(ActionPanelEvent.ACTION_SELECTED, actionSelected);
//			this.removeChild(_actionPanel);
			
			// retorna resultado
			var be:BattleEvent = new BattleEvent(BattleEvent.ACTION_SELECTED,  <data id={e.actionId}/>);
			this._conm.dispatchEvent(be);
			// this._batalha.execute(subj.id, e.data.@idAcao); // ?
		}
		
		// escolhe um tile para executao acao
		private function actionTileSelect(data:XML, i:InstructionInterpreter):void
		{
			// exemplo: <select result="obje" x="1" z="2" color="3" type="enemy" alcance="1" text="Selecione inimigo a ser atingido"/>
			this.map.setAllTileButtons();
			
			// pega os tiles q devem ser selecionaveis
//			var alcance:Array = this._batalha.grafo.alcance( this._batalha.grafo.pos2id(e.data.@x, e.data.@z), select.@alcance, true, true );
			
			var alcance:Array = String(data.@tiles).split(",");
			
//			var n:int = 13;
//			var area:Array = String(data.selection.(@id == n).@area).split(",");
			
			// muda a cor dos TileButtons q sao alcançaveis
			this.map.setTileButtons(alcance, 3);
			
			// adiciona eventListener pra esperar jogador clickar em um tile valido
			addEventListener(TerrainBlockEvent.TILE_CLICK, actionTileSelected, true, 0, true);
			i.endExecution();
		}
		
		private function actionTileSelected(e:TerrainBlockEvent):void
		{
			removeEventListener(TerrainBlockEvent.TILE_CLICK, actionTileSelected, true);
			
			this.map.setAllTileButtons();
			
			this._conm.dispatchEvent(new BattleEvent(BattleEvent.TARGET_SELECTED,  <target id={e.id}/>));
		}
	
// ======================================================================================================
	/*
	 * Descriçao Classe Batalha
	 *
	 *
	 *
	 *
	 *
	 *
	 *
	 * Eventos da batalha
	 *
	 * 0: Inicio da batalha
	 * 		- pega personagem q vai agira atualmente
	 * 		- pega lista de açoes disponiveis do personagem (proprio personagem deve gerar um XML com todos as opções com ids únicos)
	 * 		- cria botões, combobox, etc, todos os opções de escolha do personagem baseado no XML de ações
	 * 		- poe um event listener em cada opção disponibilizada atraves do menu
	 * 			-> 10: opção de atacar
	 * 			-> 20: opção de mover
	 * 			-> 30: opção de terminar
	 *
	 * 10: Jogador escolheu uma ação de ataque
	 * 		- set visible = false nos menus de opções
	 * 		- pega o alcance da ação
	 * 		- pega no mapa todos os TileButtons que estao dentro do alcance da ação
	 * 		- muda o upState dos TileButtons da area
	 * 		- addiciona addEventListener( onClick ) nos tilebuttons
	 * 			-> se personagem clicar em algum dos tiles vai para 11
	 *
	 * 11: Jogador escolheu um tile depois de ação de ataque
	 * 		- muda a direção do personagem para onde está o alvo
	 *		- muda a animação do personagem para atack
	 * 		- poe um evento listener no fim da execução da animação
	 * 			-> vai para 0 quando a animação acabar
	 *
	 * 20: Jogador escolheu a opção de mover
	 * 		- pega caminho da posição atual do personagem para o destino
	 * 		- gera o Tweener
	 * 			- pega a posição de cada tile no caminho
	 * 			- muda a animação do personagem para run
	 * 			- poe cada posição no TweenerGroup (com as respectivas mudanças de direção quando necessário)
	 * 			- muda a animação do personagem para stop
	 * 			- poe no final do TweenerGroup a execução da função
	 * 				- quando o personagem chegar no tile q executara a ação
	 * 					-> vai para 0
	 *
	 * 30: Jogador escolheu terminar ou jah andou e atacou
	 * 		- se personagem soh fez 1 ação entao remove ele da lista de ações com halfAction
	 * 		- se personagem jah faz todas ações disponiveis entao remove ele com fullAction
	 * 		-> vai para 0
	 */
	}
}

