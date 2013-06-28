package julio.tactics.regras.GURPS.Pericias
{
	import julio.tactics.regras.GURPS.Personagens.IModListaAcoes;
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
	public class PericiaMagicaD extends Pericia implements IModListaAcoes
	{
		
		public var _idAcao:String;
		
		public function PericiaMagicaD( id:EPericia, nome:String, descricao:String, idAcao:String )
		{
			super( id, nome, descricao, -5, EAtributo.IQ, -3, 2 );
			
			this._idAcao = idAcao;
		}
		
		public function ModListaAcoes( personagem:Personagem ):XML
		{
			return <acao id={this._idAcao}/>;
		}
	}

}
