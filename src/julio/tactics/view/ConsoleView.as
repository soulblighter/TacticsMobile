package julio.tactics.view
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import julio.AssetsManager;
	import julio.tactics.events.BattleEvent;
	import julio.tactics.events.DisplayEvent;
	import julio.tactics.GameTimer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.SimpleButton;
	import flash.text.TextFieldType;
	import julio.display.CustomButton;
	
//	import mx.controls.Button;
//	import mx.controls.TextArea;
//	import mx.controls.TextInput;
//	import mx.core.Container;
//	import mx.core.UIComponent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ConsoleView extends Sprite
	{
//		[Bindable]
//		public var inputData:XML;
		
		private var _gameTimer:GameTimer;
		private var _clickDelay:Number;	// tempo para reconhecer um botao apertado depois do outro
		
		// fps display
		public var _fpsText:TextField;
		public var _fpsLastTime:Number;
		public var _frameCount:Number;
		public var _FPS:Number;
		public var _fpsTimeElapsed:Number;
		public var _timer:Timer;
		public var _fpsCurrentTime:Number;
		public var _fpsTimeDelta:Number;
		
		private var displayQueue:Array;
		private var displayLock:Boolean;
		
		// keyboard
		private var _keyBoardKeys:Array;
		private var _keyDelay:Number;
		
//		private var _container:UIComponent;
		
		// combat log
//		private var combatlog:CombatLog;
		
		//console
//		private var _console:ChatConsole;
		private var _inputText:TextField;
		private var _sendButton:CustomButton;
		private var _textArea:TextField;
		
		// communicator
		private var _conm:EventDispatcher;
		
		// assets manager
		private var _assets:AssetsManager;
		
		// estado da batalha
		private var state:String;	// GET_ACTION,
		
		private var lastEvent:DisplayEvent;
		private var subjectID:uint;				// ID do personagem atual
//		private var subject:Char;				// personagem atual
		private var subjAction:uint;			// ID da ação
		private var subjSelectedTarget:uint;	// id do alvo
		private var subjActionList:XML;			// Lista de IDs de ações disponíveis do personagem atual
		
		public function ConsoleView( conm:EventDispatcher, assets:AssetsManager )
		{
			super();
			
			this._conm = conm;
			this._assets = assets;
			
//			_container = new UIComponent;
//			this.addChild(_container);
			
//			combatlog = new CombatLog;
//			combatlog.x = 500;
//			combatlog.y = 30;
//			combatlog.width = 300;
//			combatlog.height = 150;
			
//			_console = new ChatConsole;
//			_console.y = 0;
//			_console.width = 800;
			//_console.percentWidth = 100;
//			_console.height = 570;
			//_console.percentHeight = 100;
			
			_textArea = new TextField;
//			_textArea.editable = false;
			_textArea.width = 300;
			_textArea.height = 130;
			_textArea.y = 300;
			_textArea.background = true;
			_textArea.border = true;
			_textArea.borderColor = 0x000000;
			_textArea.multiline = true; 
            _textArea.wordWrap = true;
			
//			_textArea.liveScrolling = true;
/*			_textArea.setStyle("cornerRadius", 8);
			_textArea.setStyle("fontSize", 12);
//			_textArea.setStyle("backgroundAlpha", 0.0);
			_textArea.setStyle("alpha", 1.0);
			_textArea.setStyle("backgroundGradientAlphas", "[1.0, 1.0]");
			_textArea.setStyle("paddingLeft", 10);
			_textArea.setStyle("paddingRight", 10);
			_textArea.setStyle("paddingBotton", 10);
			_textArea.setStyle("paddingTop", 10);
			_textArea.setStyle("borderThickness", 0);*/
			
			_inputText = new TextField;
			_inputText.width = 230;
			_inputText.height = 30;
			_inputText.y = 430;
			_inputText.type = TextFieldType.INPUT;
			_inputText.background = true;
			_inputText.border = true;
			_inputText.borderColor = 0x000000;
			
/*			_inputText.setStyle("fontSize", 12);
			_inputText.setStyle("paddingLeft", 2);
			_inputText.setStyle("paddingRight", 2);
			_inputText.setStyle("paddingBotton", 2);
			_inputText.setStyle("paddingTop", 2);
			_inputText.setStyle("leading", 0);
			_inputText.setStyle("textIndent", 0);
			_inputText.setStyle("letterSpacing", 0);
			_inputText.setStyle("backgroundAlpha", 0.7);
			_inputText.setStyle("borderStyle", "solid");
			_inputText.setStyle("borderThickness", 0);
			_inputText.setStyle("cornerRadius", 8);*/
			
			_sendButton = new CustomButton;
//			_sendButton.label = "Send";
//			_sendButton.labelPlacement = "left";
			_sendButton.x = 230;
			_sendButton.y = 570;
			_sendButton.height = 30;
			_sendButton.width = 70;
			
			this._gameTimer = new GameTimer;
			
			_keyDelay = 0;
			_keyBoardKeys = new Array;
			for ( var i_:int = 0; i_ < 256; i_++)
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
			_fpsText.x = 750;
			_fpsText.y = 5;
			
			displayQueue = new Array;
			displayLock = false;
			
//			this.addChild( _console );
//			this.addChild(combatlog);
//			this.addChild( _fpsText );
			this.addChild( _textArea );
			this.addChild( _inputText );
			this.addChild( _sendButton );
			
			this._conm.addEventListener( DisplayEvent.TURN_START, processEvent, false, 0, true );
			this._conm.addEventListener( DisplayEvent.GET_ACTION, processEvent, false, 0, true );
			this._conm.addEventListener( DisplayEvent.MAP, processEvent, false, 0, true );
			this._conm.addEventListener( DisplayEvent.ADD_CHAR, processEvent, false, 0, true );
			this._conm.addEventListener( DisplayEvent.ACTION, processEvent, false, 0, true );
			
//			_sendButton.addEventListener(MouseEvent.CLICK, consoleSend); TODO: send with mouse click
			
//			this.addEventListener( KeyboardEvent..CONSOLE, consoleSend, false, 0, true );
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function addtxt2console( txt:String ):void
		{
			_textArea.htmlText += txt;
			_textArea.scrollV = _textArea.bottomScrollV;
//			_textArea.validateNow();
//			_textArea.verticalScrollPosition = _textArea.height;
		}
		
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			
			// entry point
//			startGC();
			
			_timer = new Timer( 40 );
//			_timer.addEventListener( TimerEvent.TIMER, controle );
//			_timer.start();
			
//			_console.addChat("Info");
//			_console.addChat("Debug");
//			_console.conm = _conm;
//			this._console.setFocus();
			
			this.addEventListener( Event.ENTER_FRAME, render, false, 0, true );
			this.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyPress, false, 0, true );
			this.stage.addEventListener( KeyboardEvent.KEY_UP, onKeyRelease, false, 0, true );
			
		}
		
		public function controle(timerEvent:TimerEvent):void
		{
			_gameTimer.refresh();
			
			_keyDelay -= _gameTimer.timeDelta;
		}
		
		public function render( framevent:Event ):void
		{
			this._fpsCurrentTime = getTimer();
			this._fpsTimeDelta = this._fpsCurrentTime - this._fpsLastTime;
			this._fpsText.text = "FPS: " + String(Math.round(calcFPS(this._fpsTimeDelta)*1000));
			this._fpsLastTime = this._fpsCurrentTime;
		}
		
		public function calcFPS( fpsTimeDelta:Number ):Number
		{
			_frameCount++;
			_fpsTimeElapsed += _fpsTimeDelta
			if(_fpsTimeElapsed >= 1000.0)
			{
				_FPS = _frameCount / _fpsTimeElapsed;
				_fpsTimeElapsed = 0.0;
				_frameCount = 0;
			}
			return _FPS;
		}
		
		public function onKeyPress( keyboardEvent:KeyboardEvent ):void
		{
			_keyBoardKeys[keyboardEvent.keyCode] = true;
			if ( keyboardEvent.keyCode == Keyboard.ENTER )
			{
				consoleSend( new DisplayEvent(DisplayEvent.CONSOLE, <data txt={_inputText.text} />) );
				_inputText.text = "";
			}
		}
		public function onKeyRelease( keyboardEvent:KeyboardEvent ):void
		{
			_keyBoardKeys[keyboardEvent.keyCode] = false;
		}
		
		// trata a entrada de dados do usuario
		private function consoleSend( e:DisplayEvent ):void
		{
			var select_regexp:RegExp = /^(select|sa|sp|sd).+$/;
			var select_action_regexp:RegExp = /^(select action|sa) (?P<action>[0-9]+)$/;
			var select_action_pos_regexp:RegExp = /^(select action|sa) (?P<action>[0-9]+) (pos|p) (?P<pos>[0-9]+)$/;
			var select_pos_regexp:RegExp = /^(select pos|sp) (?P<pos>[0-9]+)$/;
			var select_dir_regexp:RegExp = /^(select dir|sd) (?P<dir>[nswe])$/;
			
			// teste if is a selection command
			if (select_regexp.test(e.data.@txt))
			{
				var actionID:uint;
				var posID:uint;
				var actionName:String;
				var tempAction:XMLList;
				var tempRange:Array;
				
				// test if is selection action command
				if (select_action_regexp.test(e.data.@txt))
				{
					actionID = uint(select_action_regexp.exec(e.data.@txt).action);
					
					// verificar o estado
					// se ação eh auto-range
					if ( state != "GET_ACTION" )
					{
//						_console.addText2Chat( e.data.@chat, "<p>Não é possível selecinar ações agora.</p>" );
						addtxt2console( "<p>Não é possível selecinar ações agora.</p>" );
						return;
					}
					
					// verifica se ação está na lista recebida
					tempAction = subjActionList.action.(@id == actionID);
					if (tempAction.length() == 0)
					{
//						_console.addText2Chat( e.data.@chat, "<p>Ação [" + actionID + "] <font color='#ff2222'>Inválida!</font></p>" );
						addtxt2console( "<p>Ação [" + actionID + "] <font color='#ff2222'>Inválida!</font></p>" );
						return;
					}
					
					// obtem o nome da ação
					actionName = getActionName(uint(actionID));
					
					
					// verifica se ação não precisa de posição
					tempRange = String(subjActionList.action.(@id == actionID).@range).split(",");
					if (tempRange[0] == "") tempRange.shift();
					if ( tempRange.length != 0 )
					{
//						_console.addText2Chat( e.data.@chat, "<p>Ação [" + actionID + "] <font color='#00ff22'>"+actionName+"</font> <font color='#ff2222'>precisa determinar uma posição.</font></p>" );
						addtxt2console( "<p>Ação [" + actionID + "] <font color='#00ff22'>"+actionName+"</font> <font color='#ff2222'>precisa determinar uma posição.</font></p>" );
						return;
					}
					
					// manda para o servidor a ação escolhida
//					_console.addText2Chat( e.data.@chat, "<p>Ação [" + actionID + "] <font color='#00ff22'>"+actionName+"</font> selecionada</p>" );
					addtxt2console( "<p>Ação [" + actionID + "] <font color='#00ff22'>"+actionName+"</font> selecionada</p>" );
					_conm.dispatchEvent( new BattleEvent( BattleEvent.ACTION_SELECTED, <battle actionID={actionID} />) );
					return;
				}
				
				// test if is selection action_pos command
				if (select_action_pos_regexp.test(e.data.@txt))
				{
					actionID = uint(select_action_pos_regexp.exec(e.data.@txt).action);
					posID = uint(select_action_pos_regexp.exec(e.data.@txt).pos);
					
					// verifica se ação está na lista recebida
					tempAction = subjActionList.action.(@id == actionID);
					if (tempAction.length() == 0)
					{
//						_console.addText2Chat( e.data.@chat, "<p>Ação [" + actionID + "] <font color='#ff2222'>Inválida!</font></p>" );
						addtxt2console( "<p>Ação [" + actionID + "] <font color='#ff2222'>Inválida!</font></p>" );
						return;
					}
					
					// obtem o nome da ação
					actionName = getActionName(uint(actionID));
					
					// verifica se ação não precisa de posição
					tempRange = String(subjActionList.action.(@id == actionID).@range).split(",");
					if (tempRange[0] == "") tempRange.shift();
					if ( tempRange.length == 0 )
					{
//						_console.addText2Chat( e.data.@chat, "<p>Ação [" + actionID + "] <font color='#00ff22'>"+actionName+"</font> <font color='#ff2222'>não precisa determinar uma posição.</font></p>" );
						addtxt2console( "<p>Ação [" + actionID + "] <font color='#00ff22'>"+actionName+"</font> <font color='#ff2222'>não precisa determinar uma posição.</font></p>" );
						return;
					}
					
					// verifica se ação escolhida está no range
					if ( tempRange.indexOf(String(posID)) == -1 )
					{
						addtxt2console( "<p>Ação [" + actionID + "] <font color='#00ff22'>"+actionName+"</font> <font color='#ff2222'>posição inválida.</font></p>" );
						return;
					}
					
//					_console.addText2Chat( e.data.@chat, "<p>Ação [" + actionID + "] <font color='#00ff22'>"+actionName+"</font> selecionada, posição ["+posID+"]</p>" );
					addtxt2console( "<p>Ação [" + actionID + "] <font color='#00ff22'>"+actionName+"</font> selecionada, posição ["+posID+"]</p>" );
					_conm.dispatchEvent( new BattleEvent( BattleEvent.ACTION_SELECTED, <battle actionID={actionID} posID={posID} />) );
					return;
				}
				
//				_console.addText2Chat( e.data.@chat, "invalid selection" );
				addtxt2console( "invalid selection" );
				return;
			}
			
//			_console.addText2Chat( e.data.@chat, e.data.@txt );
			addtxt2console( String(e.data.@txt) );
		}
		
		// events sends by battle server
		private function processEvent( e:DisplayEvent ):void
		{
			lastEvent = e;
			
			switch(e.type)
			{
				case DisplayEvent.MAP:
//					_console.addText2Chat( "Info", "<p><b>Server enviou o mapa.</b></p>" );
					addtxt2console( "<p><b>Server enviou o mapa.</b></p>" );
					break;
				
				case DisplayEvent.ADD_CHAR:
//					_console.addText2Chat( "Info", "<p><b>Server enviou o personagem "+ e.data.@id +".</b></p>" );
					addtxt2console( "<p><b>Server enviou o personagem "+ e.data.@id +".</b></p>" );
					break;
				
				case DisplayEvent.TURN_START:
//					_console.addText2Chat( "Info", "<p><b>Começou o turno do <font color='#00ff22'>[Char " + e.data.@charID + "]</font></b></p>" );
					addtxt2console( "<p><b>Começou o turno do <font color='#00ff22'>[Char " + e.data.@charID + "]</font></b></p>" );
					subjectID = uint(e.data.@charID);
					break;
				
				case DisplayEvent.GET_ACTION:
					state = "GET_ACTION";
//					_console.addText2Chat( "Info", "<p>Escolha ação: " + e.data.@actionList + "</p>" );
					addtxt2console( "<p>Escolha ação: " + e.data.@actionList + "</p>" );
					subjActionList = e.data
					
					var actionList:Array = String(e.data.@actionList).split(",");
					for each( var actionId:String in actionList )
					{
						var rangeList:Array = String(e.data.action.(@id == actionId).@range).split(",");
						if (rangeList[0] == "")
							rangeList.shift();
						rangeList.sort();
						
						var actionName:String = getActionName(uint(actionId));
						
						// para ação sem range (ações que tem area de efeito automatica, sem escolha do usuário)
						if ( rangeList.length == 0 )
//							_console.addText2Chat( "Info", "<p>\tAção [" + actionId + "] <font color='#0011ff'>"+actionName+"</font>: auto-range*</p>" );
							addtxt2console( "<p>\tAção [" + actionId + "] <font color='#0011ff'>"+actionName+"</font>: auto-range*</p>" );
						else
//							_console.addText2Chat( "Info", "<p>\tAção [" + actionId + "] <font color='#0011ff'>"+actionName+"</font>: range: " + rangeList + "</p>" );
							addtxt2console( "<p>\tAção [" + actionId + "] <font color='#0011ff'>"+actionName+"</font>: range: " + rangeList + "</p>" );
					}
					break;
				
				case DisplayEvent.ACTION:
//					_console.addText2Chat( "Info", "<p><b>Server enviou o ação: subject: "+e.data.@subject+", object: "+e.data.@object+", result: "+e.data.@result+".</b></p>" );
					addtxt2console( "<p><b>Server enviou o ação: subject: "+e.data.@subject+", object: "+e.data.@object+", result: "+e.data.@result+".</b>"+(e.data.@damage)?(", dano: <font color='#ff1100'>"+e.data.@damage+"</font>"):("")+"</p>" );
					break;
				
				case DisplayEvent.MOVE:
//					_console.addText2Chat( "Info", "<p><font color='#00ff22'>[Char " + e.data.@target + "]</font>  moveu para "+e.data.@end+".</p>" );
					addtxt2console( "<p><font color='#00ff22'>[Char " + e.data.@target + "]</font>  moveu para "+e.data.@end+".</p>" );
					break;
				
				default:
//					_console.addText2Chat( "Info", "<p>invalid server message</p>" );
					addtxt2console( "<p>invalid server message</p>" );
					break;
			}
		}
		
		private function getActionName( actionID:uint ):String
		{
			switch(actionID)
			{
				case 0: return "Ataque";
					break;
				case 1: return "Mover";
					break;
				case 2: return "End";
					break;
				default: return "Unknow action";
					break;
			}
		}
		
	}

}
