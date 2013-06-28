package julio.tactics.regras.GURPS.batalha
{
	import julio.tactics.regras.GURPS.Arma;
	import julio.tactics.regras.GURPS.Ataque;
	import julio.tactics.regras.GURPS.Pericia;
	import julio.tactics.regras.GURPS.Personagem;
	import julio.tactics.regras.GURPS.enuns.*;
	
	/**
	 * Classe que gerencia uma batalha simples entre dois personagens
	 * eh desconsiderado o cenário, basicamente os personagens n podem se mover
	 * e estao um a frente do outro, no limite do melee atack
	 * @author ...
	 */
	public class SimpleBattle
	{
		private const MAX_ORDEM_SIZE:int = 3;		// tamanho maximo da fila de ordem de personnagens
		private var numPersonagens:uint;			// Numero de personagens da batalha
		private var personagens:Object; 			// Lista de personagens da batalha (com iniciativas)
		private var ordemAcoes:Array; 				// Lista com a ordem dos ids dos personagem a agir
		private var turnoAtual:int;					// numero do turno atual
		
		public function SimpleBattle()
		{
			this.numPersonagens = 0;
			this.turnoAtual = 0;
			this.ordemAcoes = new Array;
			this.personagens = new Object;
		}
		
		public function init( p1:Personagem, p2:Personagem ):void
		{
			//p2.armaEquipada = a;
			
			trace( "p1.acerto: ", p1.acerto );
			trace( "p2.acerto: ", p2.acerto );
			
			pushChar( p1, "p1" );
			pushChar( p2, "p2" );
		}
		
		public function show():void
		{
			trace( personagens );
			trace( ordemAcoes );
		}
		
		public function start():void
		{
			
			// começa a batalha
			
			while ( !this.personagens["p1"].isDead() || !this.personagens["p2"].isDead() )
			{
				// começa o turno
				
				// atualiza ordem de personagens
				this.updateFila();
				
				// pega proximo a agir
				var subj:Object = this.proximoAgir();
				subj.char.restauraAcoes();
				
				// pega ação do personagem atual
				
				// executa ação
				
			} // termina o turno
			
		}
		
		// adiciona um personagem na lógica da batalha
		private function pushChar( personagem:Personagem, id:String ):void
		{
			var obj:Object = new Object;
			obj.char = personagem;
			obj.id = id;
			obj.init = 100.0 / personagem.velocidade;
			obj.realInit = 100.0 / personagem.velocidade;
			this.personagens[id] = obj;
			this.numPersonagens++;
		}
		
		// atualiaza a fila de ações dos personagens
		public function updateFila():void
		{
			// limpa a fila
			this.ordemAcoes.splice(0, ordemAcoes.length);
			
			for ( var a4:String in this.personagens )
					this.personagens[a4].init = this.personagens[a4].realInit;
				
			if( this.numPersonagens > 0 )
			// preenche 10 posições na fila de ações
			while( this.ordemAcoes.length < MAX_ORDEM_SIZE )
			{
				var baseInit:Number = 100;
				
				//	Procura entre todos os personagens o que tenha a menor iniciativa.
				for ( var a:String in this.personagens )
				{
					if( this.personagens[a].init < baseInit )
						baseInit = this.personagens[a].init;
				}
				
				//	Deduz esse valor da iniciativa de todos os personagens.
				for ( var a2:String in this.personagens )
					this.personagens[a2].init -= baseInit;
				
				//	Poe na fila de ações os personagens q ficaram com Iniciativa 0
				//	e faz suas iniciativas serem o valor da velocidade novamente.
				for ( var a3:String in this.personagens )
					if( this.ordemAcoes.length < MAX_ORDEM_SIZE )
						if( this.personagens[a3].init == 0 )
						{
							this.ordemAcoes.push( this.personagens[a3].id );
							this.personagens[a3].init = 100.0 / this.personagens[a3].char.velocidade;
						}
			}
		}
		

		// pega o proximo personagem a agir
		public function proximoAgir():Object
		{
			if( this.ordemAcoes.length == 0 )
				throw new Error("julio.GURSP.BATALHA::proximoAgir() ordem de ações vazia!");
			else
			{
				var next:Object = this.ordemAcoes[0];
//				if (pop)
//					this._ordemAcoes.splice(0, 1);
				return next;
			}
		}
		
		public function fullAction():void
		{
			if( this.ordemAcoes.length == 0 )
				throw new Error("julio.GURSP.BATALHA::fullAction() ordem de ações vazia!");
			else
			{
				var baseInit:Number = proximoAgir().realInit;
				for ( var a2:String in this.personagens )
				{
					this.personagens[a2].realInit -= baseInit;
				}
				proximoAgir().realInit = 100.0 / proximoAgir().char.velocidade;
			}
		}
		
		public function halfAction():void
		{
			if( this.ordemAcoes.length == 0 )
				throw new Error("julio.GURSP.BATALHA::halfAction() ordem de ações vazia!");
			else
			{
				var baseInit:Number = proximoAgir().realInit;
				for ( var a2:String in this.personagens )
					this.personagens[a2].realInit -= baseInit;
				proximoAgir().realInit = 50.0 / proximoAgir().char.velocidade;
			}
//			this._ordemAcoes.splice(0, 1);
		}
		
	}
	
}
