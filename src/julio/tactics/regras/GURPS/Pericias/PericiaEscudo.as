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
	 * @author Júlio Cézar
	 */
	public class PericiaEscudo extends Pericia implements IModAcerto, IModAparar, IModNumBloquear/*, IModBloquear, IModDanoGDP, IModDanoBAL*/
	{
		private var _redutorAcerto:Number;			// Redutor no acerto que o escudo infringe ao usuario
		private var _redutorAparar:Number;			// Redutor no aparar q o escudo coloca ao usuario
		private var _bloquearBase:Number;			// multiplicador do NH da pericia para usar como bloquear (normal 1/2)
		private var _nBloquear:uint;				// Numero Bloquear por turno q a pericia disponibiliza
		private var _nBloquearDefesaTotal:uint;		// Numero Bloquear por turno q a pericia disponibiliza em uma defesa total
		
		public function PericiaEscudo( id:EPericia, nome:String, descricao:String, redutorPredefinido:int, atributo:EAtributo, baseMod:int, incremento:int,
										redutorAcerto:Number, redutorAparar:Number, bloquearBase:Number, nBloquear:uint, nBloquearDefesaTotal:uint )
		{
			super( id, nome, descricao, redutorPredefinido, atributo, baseMod, incremento );
			
			this._redutorAcerto = redutorAcerto;
			this._redutorAparar = redutorAparar;
			this._bloquearBase = bloquearBase;
			this._nBloquear = nBloquear;
			this._nBloquearDefesaTotal = nBloquearDefesaTotal;
		}
		
		public function get redutorAcerto():Number			{ return this._redutorAcerto; }
		public function get redutorAparar():Number			{ return this._redutorAparar; }
		public function get bloquearBase():Number			{ return this._bloquearBase; }
		public function get nBloquear():uint				{ return this._nBloquear; }
		public function get nBloquearDefesaTotal():uint		{ return this._nBloquearDefesaTotal; }
		
		
		public function ModAcerto( personagem:Personagem ):int
		{
			return this._redutorAcerto;
		}

		public function ModAparar( personagem:Personagem ):int
		{
			return this._redutorAparar;
		}
		
		public function ModNumBloquear( personagem:Personagem ):int
		{
			if( personagem.defesaTotal == true )
				return nBloquearDefesaTotal;
			else
				return nBloquear;
		}
		
/*
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
*/
	}
}
