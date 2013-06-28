package julio.tactics
{
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class DisplayInstruction extends Event
	{
		public var imediato:Boolean;		// marca se o evento eh imediato
		// um evento imediato naum eh executado imediatamente quando posto na fila,
		// nesse jogo turn-based, quando esse evento começa a ser executado, os eventos
		// posteriores sao executados imediatamente, ateh começar a execução de um evento não imediato
		
		// os paddings são os delays para começar e para terminar a instrução
		// a instrução soh começera a ser executada quando o tempo do prefixo passar
		// e depois ela espera o tempo do sufix acabar para terminar a intrução completamente
		// sendo assim o tempo total de execução da instrução eh: prefix + tempo normal da instrução + sufix
		public var prefixPadding:Number;
		public var sufixPadding:Number;
		
		// tipos válidos para as intruções:							// Dados que devem contar no XML
		public static const MAP:String = "_MAP";						// <map> ... grafo do mapa </map>
		public static const ADD_CHAR:String = "_ADD_CHAR";			// <char id="0" pos="0"> <display asset="Fighter_high"/> </char>
//		public static const TURN_START:String = "_TURN_START";		// <turn .../>
		
		public static const MOVE:String = "_MOVE";					// <move target="0" animation="run" start="0">	<step type="HJUMP" value="1"/> <step type="SIMPLE" value="2"/> </move>
		public static const MOVE_CAMERA:String = "_MOVE_CAMERA";		// <camera x="100" y="40"/>
		public static const MOVE_MAP:String = "_MOVE_MAP";			// <mapa x="100" y="10" z="40"/>
		public static const ANIMATION:String = "_ANIMATION";			// <animation target="0" value="run" reset="true" play="true" loop="true"/>
		public static const LOOK:String = "_LOOK";					// <look target="0" from="15" to="17"/>
		public static const SHOW_DAMAGE:String = "_SHOW_DAMAGE";		// <damage target="0" value="15" color="0xff0000"/>
		public static const WAIT:String = "_WAIT";					// <wait time="15"/>
		
		public static const GET_ACTION:String = "_GET_ACTION";		// <acao .../>
		public static const GET_TARGET:String = "_GET_TARGET";		// <tile .../>
		
		
		
		
		
		public static const WALK:String = "_WALK";					// <move target="subj" track="2,4,2,3,5,11" animation="walk"/> // contem a origem no track
		public static const CHANGEDIR:String = "_CHANGEDIR";			// <display object="joao" value="sw"/>
		public static const ROTATE:String = "_ROTATE";				// <display object="map" value="90"/> // value eh graus em sentido horario, ou seja se object estiver direcionado a sw com value 1 ficara nw, se -> sw, value = 2: ne -> sw, somente 4 direções possives [ne, nw, se, sw]
		
		public static const FX:String = "_FX";						// <display value="explosion.swf" x="10" y="0" z="40"/>
		public static const TALK:String = "_TALK";					// <display subject="João" portratil="fighter_1.png" value="Vai morrer, seu miserável!"/>
		
		public static const START:String = "_START";
		public static const TELEPORT:String = "_TELEPORT";
		
//		public var tipo:String;
		
		public var _data:XML;			// dados extras
		
		public function DisplayInstruction( type:String, data:XML, imediato:Boolean = false, prefixPadding:Number = 0.0, sufixPadding:Number = 0.0 )
		{
			super( type, false, false );
			
//			this.type = type;
			this.imediato = imediato;
			this.prefixPadding = prefixPadding;
			this.sufixPadding = sufixPadding;
			this._data = data;
		}
		public override function clone():Event
		{
			return new DisplayInstruction( type, data, imediato, prefixPadding, sufixPadding );
		}
		
		public override function toString():String
		{
			return formatToString( "DisplayInstruction", "type", "eventPhase", "data" );
		}
		
		public function get data():XML { return this._data; }
		
	}
}
