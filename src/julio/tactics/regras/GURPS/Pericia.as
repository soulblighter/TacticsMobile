package julio.tactics.regras.GURPS
{
	import julio.tactics.regras.GURPS.enuns.EAtributo;
	import julio.tactics.regras.GURPS.enuns.EPericia;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Pericia
	{
		private var _id:EPericia;
		
		private var _nome:String;
		private var _descricao:String;
		private var _redutorPredefinido:int;
		private var _atributo:EAtributo;
		
		private var _baseMod:int;
		private var _incremento:int;
		
		public function Pericia( id:EPericia, nome:String, descricao:String, redutorPredefinido:int, atributo:EAtributo, baseMod:int, incremento:int )
		{
			this._id = id;
			this._nome = nome;
			this._descricao = descricao;
			this._redutorPredefinido = redutorPredefinido;
			this._atributo = atributo;
			this._baseMod = baseMod;
			this._incremento = incremento;
		}
		
		// converte pontos no bonus NH da perícia que deverá ser somado ao atributo
		public function Points2NH( points:uint ):int
		{
			if ( points == 0 )
				return this._redutorPredefinido;
			
			var result:int = this._baseMod;
			var incr:int = 1;
			
			while (points >= incr)
			{
				result += 1;
				
				if ( incr <= this._incremento )
					incr *= 2;
				else
					incr += this._incremento;
			}
			
			return result;
		}
		
		// recebe como parametro qts pontos estao gastos atualmente e retorna qts precisam pra proximo nivel
		public function points2NextNH( actualPoints:uint ):uint
		{
			if ( actualPoints == 0 )
				return 1;
			
			var atualNH:int = Points2NH(actualPoints);
			var d1:int = NH2Allpoints(atualNH + 1);
			var d2:int = NH2Allpoints(atualNH);
			return NH2Allpoints(atualNH + 1) - NH2Allpoints(atualNH);
		}
		
		
		// recebe como parametro o bonus de NH atual e retorna qts pontos precisam para proximo nivel de NH
		public function NH2points( actualNH:int ):uint // -2
		{
			if ( actualNH < this._baseMod )
				return 0;
			
			var result:int = this._baseMod;
			var incr:int = 1;
			
			while ( result < actualNH )
			{
				result += 1;
				if ( incr <= this._incremento )
					incr *= 2;
				else
					incr += this._incremento;
			}
			
			return incr;
		}
		
		// recebe como parametro o bonus de NH atual e retorna qts pontos precisam para esse nivel de NH
		public function NH2Allpoints( NH:int ):uint // 0
		{
			if ( NH < this._baseMod )
				return 0;
			
			var tempNH:int = this._baseMod;
			var incr:uint = 1;
			var result:uint = 0;
			
			while ( tempNH < NH )
			{
				result += incr;
				tempNH += 1;
				if ( incr <= this._incremento )
					incr *= 2;
				else
					incr += this._incremento;
			}
			
			return result;
		}
		
		public function get id():EPericia				{ return this._id; }
		public function get nome():String				{ return this._nome; }
		public function get descricao():String			{ return this._descricao; }
		public function get redutorPredefinido():int	{ return this._redutorPredefinido; }
		public function get atributo():EAtributo		{ return this._atributo; }
		public function get baseMod():int				{ return this._baseMod; }
		public function get incremento():int			{ return this._incremento; }
	}
}
