package julio.tactics.regras.GURPS.Pericias
{
	import julio.tactics.regras.GURPS.enuns.EAtributo;
	import julio.tactics.regras.GURPS.enuns.EPericia;
	import julio.tactics.regras.GURPS.Pericia;
	import julio.tactics.regras.GURPS.Personagens.*;
	import julio.tactics.regras.GURPS.Personagem;
	import julio.tactics.regras.GURPS.Dados;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PericiaCombate extends Pericia implements /*IModAcerto,*/ IModAparar, IModNumAparar, IModDanoGDP, IModDanoBAL
	{
		private var _danoBonusMod:Number;		// Bonus no dano (baseado no NH)
		private var _apararBase:Number;			// Chance em % que a aperica dah no aparar (baseado no NH) (ex.: se _apararBase for 0.5 entao o aparar base será metade do NH na pericia
		private var _nAparar:uint;				// Numero aparar por turno q a pericia disponibiliza
		private var _nApararDefesaTotal:uint;	// Numero aparar por turno q a pericia disponibiliza em uma defesa total
		private var _nHands:uint;				// se a pericia eh de arma de duas maos ou uma mao
		private var _desarmado:Boolean;			// Flag if this skill is for unarmed combat
		
		public function PericiaCombate( id:EPericia, nome:String, descricao:String, redutorPredefinido:int, atributo:EAtributo, baseMod:int, incremento:int,
										danoBonusMod:Number, apararBase:Number, nAparar:Number, nApararDefesaTotal:Number, nHands:uint, desarmado:Boolean = false )
		{
			super( id, nome, descricao, redutorPredefinido, atributo, baseMod, incremento );
			
			this._danoBonusMod = danoBonusMod;
			this._apararBase = apararBase;
			this._nAparar = nAparar;
			this._nApararDefesaTotal = nApararDefesaTotal;
			this._nHands = nHands;
			this._desarmado = desarmado;
		}
		
		public function get danoBonusMod():Number			{ return this._danoBonusMod; }
		public function get apararBase():Number				{ return this._apararBase; }
		public function get nAparar():uint					{ return this._nAparar; }
		public function get nApararDefesaTotal():uint		{ return this._nApararDefesaTotal; }
		public function get nHands():uint					{ return this._nHands; }
		public function get desarmado():Boolean				{ return this._desarmado; }
		
		
/*		public function ModAcerto( personagem:Personagem ):int
		{
			var NH:int  = personagem.getNHEmPericia( id );
			return NH;
		}
*/
		public function ModAparar( personagem:Personagem ):int
		{
			var NH:int  = personagem.getNHEmPericia( id );
			return NH * this._apararBase;
		}
		
		public function ModDanoBAL( personagem:Personagem ):Dados
		{
			var dados:Dados = personagem.danoBAL;
			return new Dados( dados.nDados, dados.bonus + this._danoBonusMod );
		}
		
		public function ModDanoGDP( personagem:Personagem ):Dados
		{
			var dados:Dados = personagem.danoGDP;
			return new Dados( dados.nDados, dados.bonus + this._danoBonusMod );
		}
		
		public function ModNumAparar( personagem:Personagem ):int
		{
			if( personagem.defesaTotal == true )
				return nApararDefesaTotal;
			else
				return nAparar;
		}
	}
}
