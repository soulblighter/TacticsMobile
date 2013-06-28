package julio.tactics.regras.GURPS.batalha
{
	import away3d.core.math.Number2D;
	import away3d.core.math.Number3D;
//	import julio.tactics.TerrainData;
	import julio.tactics.regras.GURPS.batalha.TileData;
	
	// grafo do cenário de um jogo de tatica estilo tactics ogre
	//
	// cada tile ocupa uma posição x, z
	// y define a altura do tile
	// nao pode haver 2 tiles com mesmo x e z, ou seja, nao pode haver dois tiles na mesma posição
	// cada tile pode ser ocupado por somente um objeto
	//
	// um objeto da batalha pode ser um personagem, um tesouro(baú, carta), obstáuclo(arvore, pedra)
	// cada objeto possui uma posição, e esse posição deve corresponder a um tile
	// o objeto tambem deve dizer se ele ocupa a posção em q está ou não
	// caso dois objetos ocupem as mesmas posições, entao um evento deve ser enviado para resolver o conflito imediatamente
	//
	// cada personagem possui um time
	// personagens do mesmo time podem andar atraves de um tile ocupado por outro personagem do mesmo time,
	// embora devam terminar o movimento sempre em um tile que nao tenha um obstáculo/personagem
	//
	// 2 x 3 ( 2 linha e 3 colunas )
	// 0123
	// 4567
	// 0, 1, 2, 3, 4, 5, 6, 7
	//
	// x,y - x*c + y (c = numero colunas)
	// 0,0 - 0
	// 0,1 - 1
	// 0,2 - 2
	// 0,3 - 3
	// 1,0 - 4
	// 1,1 - 5
	// 1,2 - 6
	// 1,3 - 7
	//
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class Grafo2
	{
		private var _numBlocos:uint;		// tamanho do tabuleiro
		private var _size_x:uint;			// tamanho do tabuleiro
		private var _size_z:uint;			// tamanho do tabuleiro
		private var _tabuleiro:Array;		// Vetor com as posições possiveis para vertices
		private var _numVertices:uint;		// Numero de Nós preenchidos do grafo
		
		private var _objetos:Array;			// lista objetos do cenário
		
		public function Grafo2()
		{
			this._numBlocos = 0;
			this._size_x = 0;
			this._size_z = 0;
			this._tabuleiro = new Array;
			
			this._numVertices = 0;
			this._objetos = new Array;
		}
		
		// cria um tabuleiro que servirá como base para o mapa
		// todos os vertices do mapa sao armazenados no vetor _tabuleiro
		//
		public function criarMapa( x:uint, z:uint ):void
		{
			this._numBlocos = x * z;
			this._size_x = x;
			this._size_z = z;
			for ( var a:uint = 0; a < x; a++ )
				for ( var b:uint = 0; b < z; b++ )
					this._tabuleiro.push( new Vertice( a, 0, b, null ) );
		}
		
		
		public function id2pos( id:uint ):Number2D
		{
			var n:Number2D = new Number2D;
			n.x = id / _size_z;
			n.y = id % _size_z;
			return n;
		}
		
		public function pos2id( x:int, z:int ):uint
		{
			return x * this._size_z + z;
		}
		
		public function inserirVertice( x:uint, y:uint, z:uint, data:TileData ):void
		{
			if ( existeVertice(x, z) )
				throw new Error("Vertice ja existe Grafo::inserirVertice( " + x + ", " + z +" )");
			
			this._tabuleiro[pos2id(x, z)].y = y;
			this._tabuleiro[pos2id(x, z)].data = data;
			
//			var v:Vertice =  new Vertice;
			
//			this._vertices[id] = tile;
//			this._suc[id] = new Array;
			
//			if ( !this._matriz[x] )
//				this._matriz[x] = new Object;
				
//			this._matriz[x][z] = v;
			
//			this._objetos[id] = new Array;
//			this._objetos[id].push( tile )
			
			this._numVertices++;
			
//			return pos2id(x, z);
		}
		
		public function get numVertices():int { return this._numVertices; }
		
		private function existeVertice( x:uint, z:uint ):Boolean
		{
			return this._tabuleiro[pos2id(x, z)].data != null;
//			return (this._matriz[x] && this._matriz[x][z])?true:false;
		}
		
		
		public function inserirArco( xOrigem:uint, zOrigem:uint, xDestino:uint, zDestino:uint ):void
		{
			if ( !existeVertice(xOrigem, zOrigem) )
				throw new Error("Origem nao existe em Grafo::inserirArco( " + xOrigem + ", " + zOrigem + ", " + xDestino + ", " + zDestino + " )");
			if ( !existeVertice(xDestino, zDestino) )
				throw new Error("Destino nao existe em Grafo::inserirArco( " + xOrigem + ", " + zOrigem + ", " + xDestino + ", " + zDestino + " )");
			if ( (xOrigem == xDestino) && (zOrigem == zDestino) )
				throw new Error("Origem igual Destino em Grafo::inserirArco( " + xOrigem + ", " + zOrigem + ", " + xDestino + ", " + zDestino + " )");
			
			this._tabuleiro[pos2id(xOrigem, zOrigem)].addSuc( pos2id(xDestino, zDestino) );
//			this._matriz[xOrigem][zOrigem].addSuc(xDestino, zDestino);
//			this._suc[origem].push(destino);
		}
		
		// testa se "obj" eh do tipo de alguma das classes contidas em "whiteList"
		public function isOneOf( obj:Object, witheList:Array ):Boolean
		{
			for each( var c:Class in witheList )
				if ( obj is c )
					return true;
			return false;
		}
		
		// testa se "obj" NÃO eh do tipo de alguma das classes contidas em "blackList"
		public function isNotOf( obj:Object, blackList:Array ):Boolean
		{
			for each( var c:Class in blackList )
				if ( obj is c )
					return false;
			return true;
		}
		
		public function podeFicar( x:uint, z:uint, o:ObjetoCenario ):Boolean
		{
			if( this._tabuleiro[pos2id(x, z)].objetoID != null )
				return this._objetos[this._tabuleiro[pos2id(x, z)].objetoID].canStay(o);
			else
				return true;
			
//			for each( var id:String in this._matriz[x][z].obj )
//				if ( !this._objetos[id].canStay( o ) )
//					return false;
//			return true;
		}
		public function podePassar( x:uint, z:uint, o:ObjetoCenario ):Boolean
		{
			if( this._tabuleiro[pos2id(x, z)].objetoID != null )
				return this._objetos[this._tabuleiro[pos2id(x, z)].objetoID].canPass(o);
			else
				return true;
			
//			for each( var id:String in this._matriz[x][z].obj )
//				if ( !this._objetos[id].canPass( o ) )
//					return false;
//			return true;
		}
		
		public function inserirObjeto( x:uint, z:uint, o:ObjetoCenario ):uint
		{
//			if ( this._objetos[id] )
//				throw new Error("Objeto com id \"" + id + "\" jah exite!");
			
//			if( this._objetos.indexOf(o) != -1 )
//				throw new Error("Objeto \"" + o + "\" jah exite!");
			
//			if ( !podeFicar(x, z, o) )
//				throw new Error("Posição \"" + x + "\",\"" + z + "\" jah estah ocupada!");
			
			o.idPos = pos2id(x, z);
			var id:uint = this._objetos.push(o);
//			this._objetos[id] = o;
			this._tabuleiro[pos2id(x, z)].addObj(id);
			return id;
//			this._matriz[x][z].addObj( id );
		}
		
/*		private function pos2ids( x:int, z:int ):Array
		{
			if ( !existeVertice(x, z) )
				throw new Error("Vertice nao existe Grafo::pos2ids( "+x+", "+z+" )");
			
			return this._matriz[x][z];
			
//			for (var key:String in this._vertices)
//				if (this._vertices[key].data.x == x && this._vertices[key].data.z == z)
//					return key;
//			throw new Error("Posição x,z nao existe no grafo em julio.tactics.Grafo::pos2id( "+x+", "+z+" )");
		}

		private function id2pos( id:String ):Number2D
		{
			if ( !this._objetos[id] )
				throw new Error("Objeto nao existe em julio.tactics.Grafo::id2pos( " + id + " )");
			
			return new Number2D(this._objetos[id].x, this._objetos[id].z);
		}
*/
		public function sucessores( x:int, z:int ):Array
		{
			if ( !existeVertice(x, z) )
				throw new Error("Vertice nao existe Grafo::sucessores( "+x+", "+z+" )");
			
			return this._tabuleiro[pos2id(x, z)].suc;
//			return this._matriz[x][z].suc;
		}
		
		public function antecessores( x:int, z:int ):Array
		{
			if ( !existeVertice(x, z) )
				throw new Error("Vertice nao existe Grafo::atecessores( "+x+", "+z+" )");
			
			return sucessores(x, z);
			// no grafo desse jogo os sucessores sempre sao igual a antecessores
			
//			var temp:Array = new Array;
//			for (var key:String in this._vertices)
//				for each(var id_suc:String in this._vertices[key])
//					if ( id_suc == id )
//						temp.push(key);
//			return temp;
		}
		public function grauSaida(x:int, z:int):int
		{
			if ( !existeVertice(x, z) )
				throw new Error("Vertice nao existe Grafo::grauSaida( "+x+", "+z+" )");
			
			return sucessores(x, z).length;
		}
		
		public function grauEntrada(x:int, z:int):int
		{
			if ( !existeVertice(x, z) )
				throw new Error("Vertice nao existe Grafo::grauEntrada( "+x+", "+z+" )");
			
			return antecessores(x, z).length;
		}
		
		public function grau(x:int, z:int):int
		{
			if ( !existeVertice(x, z) )
				throw new Error("Vertice nao existe Grafo::existeVertice( "+x+", "+z+" )");
			
			return grauSaida(x, z) + grauEntrada(x, z);
		}
		
		public function alturaTotal( x:uint, z:uint ):Number //, classType:Class ):Number // whiteList:Array = null, blackList:Array = null ):Number
		{
			return this._tabuleiro[pos2id(x, z)].y;// + this._objetos[this._tabuleiro[pos2id(x, z)].objetoID].altura;
			
//			var result:Number = 0;
			
//			for each( var id:String in this._matriz[x][z].obj )
//				if( this._objetos[id] is classType )
//					result += this._objetos[id].altura;

//			for each( var id:String in this._matriz[x][z].obj )
//				if( whiteList != null )
//					for each( var c:Class in whiteList )
//						if( this._objetos[id] is c )
//							if( blackList != null )
//								for each( var c2:Class in blackList )
//									if( !(this._objetos[id] is c2) )
//										result += this._objetos[id].altura;
			return result;
		}
		
		public function pesoTotal( x:uint, z:uint ):Number //, classType:Class ):Number
		{
			return this._objetos[this._tabuleiro[pos2id(x, z)].objetoID].peso;

//			var result:Number = 0;
//			for each( var id:String in this._matriz[x][z].obj )
//				if( this._objetos[id] is classType )
//					result += this._objetos[id].peso;
//			return result;
		}
		
		public function custoSimples( xOrigem:uint, zOrigem:uint, xDestino:uint, zDestino:uint ):uint
		{
			if ( !existeVertice(xOrigem, zOrigem) )
				throw new Error("Origem nao existe em Grafo::custoSimples( " + xOrigem + ", " + zOrigem + ", " + xDestino + ", " + zDestino + " )");
			if ( !existeVertice(xDestino, zDestino) )
				throw new Error("Destino nao existe em Grafo::custoSimples( " + xOrigem + ", " + zOrigem + ", " + xDestino + ", " + zDestino + " )");
			if ( (xOrigem == xDestino) && (zOrigem == zDestino) )
				throw new Error("Origem igual Destino em Grafo::custoSimples( " + xOrigem + ", " + zOrigem + ", " + xDestino + ", " + zDestino + " )");
			
//			for each( var n:Number2D in this._matriz[xOrigem][zOrigem].suc )
//			{
//				if ( (n.x == xDestino) && (n.y == zDestino) )
//				{
					return	Math.abs(xDestino - xOrigem) +
							Math.abs(zDestino - zOrigem) +
							Math.abs( alturaTotal( xDestino, zDestino ) - alturaTotal( xOrigem, zOrigem ) )
//				}
//			}
//			throw new Error("Grafo::custoSimples soh calcula o custo de nós adjacentes");
		}
/*
		public function distanciasDijkstra( idOrigem:String, ignorePass:Boolean = false, ignoreStay:Boolean = false, alcance:int = 99 ):Object
		{
			var origem:ObjetoCenario = this._objetos[idOrigem];
			
			if ( !existeVertice(origem.x, origem.z) )
				throw new Error("Vertice nao exite Grafo::distanciasDijkstra( " + origem.x + ", " + origem.z + " )");
			
			var distancias:Array = new Array;		// guarda as distancias do nó de origem aos outros
			var marcados:Array = new Array;			// guarda os nós que jah foram visitados
			
			// desmarca vertices
			// poe um valor alto inicialmente para todos os outor vertices
			// exceto à origem q tem distancia 0
			for ( var id:uint = 0; id < this._tabuleiro.length; id++ )
			{
				marcados.push(false);
				distancias.push(false);
				
				if( pos2id(origem.x, origem.z) == id )
					distancias[id] = 0;
				else
				{
					// marca bloqueados para passagem
//					if (!ignorePass)
//					{
//						if ( !podePassar(id2pos(id).x, id2pos(id).y, origem) ) //if( !this._objetos[idKey].canPass(origem) )
//							marcados[id] = true;
//					}
					distancias[id] = 9999;
				}
			}
			
			var naoMarcados:Array = new Array;						// Fila com os vertices a serem processados
			naoMarcados.push( new Number2D(origem.x, origem.z) );	// Poe a origem na fila
			marcados[pos2id(origem.x, origem.z)] = true;			// Marca a origem
			
			// para cada vertice nao marcado
			while ( naoMarcados.length > 0 )
			{
				//pega um vertice nao marcado
				var fst:Number2D = naoMarcados.shift();
				
				// pega os sucessores de um vertice
				var temp:Array = sucessores(fst.x, fst.y);
				
				// para cada sucessor desse vertice
				for( var a:int = 0; a < temp.length; a++ )
				{
					var suc:Number2D = id2pos(temp[a]);
					
					if( !marcados[pos2id(suc.x, suc.y)] )
					{
						//se d[v] > d[u] + w(u, v)
						if(	(distancias[pos2id(suc.x, suc.y)] > distancias[pos2id(fst.x, fst.y)] + custoSimples( fst.x, fst.y, suc.x, suc.y )) &&
							((distancias[pos2id(fst.x, fst.y)] + custoSimples( fst.x, fst.y, suc.x, suc.y )) <= alcance) )
						{
							distancias[pos2id(suc.x, suc.y)] = distancias[pos2id(fst.x, fst.y)] + custoSimples( fst.x, fst.y, suc.x, suc.y );
							naoMarcados.push( suc );
							marcados[pos2id(suc.x, suc.y)] = true;
						}
					}
				}
			}
			
			// marca bloqueados para ficar
			if (!ignoreStay)
			{
				for ( var idKey:int = 0; idKey < distancias.length; idKey++ )
					if( !podeFicar(id2pos(idKey).x, id2pos(idKey).y, origem) )
						distancias[idKey] = 9999;
				
//				for (var xKey3:String in distancias)
//					for (var zKey3:String in distancias[xKey3])
//						if( !podeFicar(uint(xKey3), uint(zKey3), origem) )
//							delete distancias[xKey3][zKey3];
			}
			
			for (var xKey2:String in distancias)
				for (var zKey2:String in distancias[xKey2])
					trace(xKey2, ",", zKey2, "|", distancias[xKey2][zKey2]);
			return distancias;
		}
*/
/*
		public function caminhosDijkstra( idOrigem:String, ignorePass:Boolean = false, ignoreStay:Boolean = false, alcance:int = 99 ):Object
		{
			var origem:ObjetoCenario = this._objetos[idOrigem];
			
			if ( !existeVertice(origem.x, origem.z) )
				throw new Error("Vertice nao exite em Grafo::caminhosDijkstra( " + origem + " )");
			
			var distancias:Object = new Object;		// guarda as distancias do nó de origem aos outros
			var marcados:Object = new Object;		// guarda os nós que jah foram visitados
			var caminhos:Object = new Object;		// guarda os caminhos do nó de origem aos outros
			
			// desmarca vertices
			// poe um valor alto inicialmente para todos os outor vertices
			// exceto à origem q tem distancia 0
			for (var xKey:String in this._matriz)
			{
				marcados[xKey] = new Object;
				distancias[xKey] = new Object;
				caminhos[xKey] = new Object;
				
				for (var zKey:String in this._matriz[xKey])
				{
					// marca bloqueados para passagem
					if (!ignorePass)
					{
						for each( var idKey:String in this._matriz[xKey][zKey].obj )
							if( !this._objetos[idKey].canPass(origem) )
								marcados[xKey][zKey] = true;
					}
					
					if( (String(origem.x) == xKey) && (String(origem.z) == zKey) )
						distancias[xKey][zKey] = 0;
					else
						distancias[xKey][zKey] = 9999;
					
					caminhos[xKey][zKey] = new Array;
				}
			}
			
			var naoMarcados:Array = new Array;						// Fila com os vertices a serem processados
			naoMarcados.push( new Number2D(origem.x, origem.z) );	// Poe a origem na fila
			marcados[origem.x][origem.z] = true;					// Marca a origem
			
			caminhos[origem.x][origem.z].push( new Number2D(origem.x, origem.z) );	// o caminho sempre começa da origem
			
			// para cada vertice nao marcado
			while ( naoMarcados.length > 0 )
			{
				//pega um vertice nao marcado
				var fst:Number2D = naoMarcados.shift();
				
				// pega os sucessores de um vertice
				var temp:Array = sucessores(fst.x, fst.y);
				
				// para cada sucessor desse vertice
				for( var a:int = 0; a < temp.length; a++ )
				{
					var suc:Number2D = temp[a];
					
					if( !marcados[suc.x][suc.y] )
					{
						//se d[v] > d[u] + w(u, v)
						if(	(distancias[suc.x][suc.y] > distancias[fst.x][fst.y] + custoSimples( fst.x, fst.y, suc.x, suc.y )) &&
							((distancias[fst.x][fst.y] + custoSimples( fst.x, fst.y, suc.x, suc.y )) <= alcance) )
						{
							distancias[suc.x][suc.y] = distancias[fst.x][fst.y] + custoSimples( fst.x, fst.y, suc.x, suc.y );
							
							// troca o caminho da lista pelo novo melhor encontrado
							caminhos[suc.x][suc.y].splice(0, caminhos[suc.x][suc.y].length);
							for ( var b:int = 0; b < caminhos[fst.x][fst.y].length; ++b )
								caminhos[suc.x][suc.y].push( caminhos[fst.x][fst.y][b] );
							caminhos[suc.x][suc.y].push( temp[a] );
							
							naoMarcados.push( new Number2D(suc.x, suc.y) );
							marcados[suc.x][suc.y] = true;
						}
					}
				}
			}
			
			// marca bloqueados para passagem
			if (!ignoreStay)
			{
				for (var xKey3:String in caminhos)
					for (var zKey3:String in caminhos[xKey3])
						if( !podeFicar(uint(xKey3), uint(zKey3), origem) )
							delete caminhos[xKey3][zKey3];
			}
			
			for (var xKey2:String in caminhos)
				for (var zKey2:String in caminhos[xKey2])
					trace(xKey2, ",", zKey2, "|", caminhos[xKey2][zKey2]);
			return caminhos;
		}
		
		public function alcanceDijkstra( x:uint, z:uint, alcance:uint, ignorarCusto:Boolean = true, ignoraOrigem:Boolean = false ):Array
		{
			var result:Array = new Array;
			
			if( !ignoraOrigem )
				result.push(new Number2D(x, z));
			
			var distancias:Object = new Object;		// guarda as distancias do nó de origem aos outros
			var marcados:Object = new Object;		// guarda os nós que jah foram visitados
			
			// desmarca vertices
			// poe um valor alto inicialmente para todos os outor vertices
			// exceto à origem q tem distancia 0
			for (var xKey:String in this._matriz)
			{
				marcados[xKey] = new Object;
				distancias[xKey] = new Object;
				
				for (var zKey:String in this._matriz[xKey])
				{
					marcados[xKey][zKey] = false;
					
					if( (String(x) == xKey) && (String(z) == zKey) )
						distancias[xKey][zKey] = 0;
					else
						distancias[xKey][zKey] = 9999;
				}
			}
			
			var naoMarcados:Array = new Array;			// Fila com os vertices a serem processados
			naoMarcados.push( new Number2D(x, z) );		// Poe a origem na fila
			
			// para cada vertice na fila
			while ( naoMarcados.length > 0 )
			{
				//pega um vertice da fila
				var fst:Number2D = naoMarcados.shift();
				
				// pega os sucessores do vertice
				var temp:Array = sucessores(fst.x, fst.y);
				
				// para cada sucessor desse vertice
				for each( var suc:Number2D in temp )
				{
					if( !marcados[suc.x][suc.y] )
					{
						var custo:uint = 1;
						if ( !ignorarCusto )
							custo = custoSimples( fst.x, fst.y, suc.x, suc.y )
						
						
						//se d[v] > d[u] + w(u, v)
						if(		(distancias[suc.x][suc.y] > distancias[fst.x][fst.y] + custo) &&
							(	(distancias[fst.x][fst.y] + custo) <= alcance) )
						{
							distancias[suc.x][suc.y] = distancias[fst.x][fst.y] + custo;
							naoMarcados.push( suc );
							marcados[suc.x][suc.y] = true;
							result.push(suc);
						}
					}
				}
			}
			
			return result;
		}
*/
/*
		// retorna matrix contendo as distancias da origem para todas os outros vertices
		public function distancias( idOrigem:String, ignorePass:Boolean = false, ignoreStay:Boolean = false, alcance:int = 99 ):Object
		{
			return distanciasDijkstra( idOrigem, ignorePass, ignoreStay, alcance );
		}
*/
/*		// retorna matrix contendo os caminhos da origem para todas os outros vertices
		public function caminhos( idOrigem:String, ignorePass:Boolean = false, ignoreStay:Boolean = false, alcance:int = 99 ):Object
		{
			return caminhosDijkstra( idOrigem, ignorePass, ignoreStay, alcance );
		}
		
		// retorna uma lista com todos os vertices alcancaveis a partir da posição x,z
		public function alcanceVertices( x:uint, z:uint, alcance:uint, ignorarCusto:Boolean = true, ignoraOrigem:Boolean = false ):Array
		{
			return alcanceDijkstra( x, z, alcance, ignorarCusto, ignoraOrigem );
		}
		
		// retorna todos os ObjetoCenario encontrados em cada vertice a partir de uma determinada origem
		// se a area for maior q 0, entao será feita mais uma busca em todos os vertices do alcance
		// a fim de encontrar todos os objetos na area;
		public function search( alcance:uint, area:uint, idOrigem:String, comparador:Function, ignoraOrigem:Boolean ):Object
		{
			var origem:ObjetoCenario = this._objetos[idOrigem];
			
			// pega todas vertices no alcance inicial
			var resultAlcance:Array = alcanceVertices( origem.x, origem.z, alcance, true );
			
			var result:Object = new Object;
			
//			trace("dbg1", "alcance: ", resultAlcance);
			
			// para cada vertice no alcance
			for each( var n:Number2D in resultAlcance )
			{
				// pega os vertices da área
				var resultArea:Array = alcanceVertices( n.x, n.y, area, true );
				
//				trace("dbg2", "area: ", resultArea);
				
				for each( var n2:Number2D in resultArea )
				{
//					trace("dbg3", "lenght: ", this._matriz[n2.x][n2.y].obj.length);
//					trace("dbg3", "obj: ", this._matriz[n2.x][n2.y].obj);
					
					if ( this._matriz[n2.x][n2.y].obj.length > 0 )
					{
						if( result[n.x] == undefined )
							result[n.x] = new Object;
						if( result[n.x][n.y] == undefined )
							result[n.x][n.y] = new Array;
						
//						trace( result[n.x][n.y] );
						// se passar no teste da dunção de comparação entao poe objetos no resultado
						for each( var id:String in this._matriz[n2.x][n2.y].obj )
						{
							if ( idOrigem == id )
							{
								if ( !ignoraOrigem )
								{
									if( comparador( this._objetos[id] ) )
										result[n.x][n.y].push(id);
								}
							} else {
								if( comparador( this._objetos[id] ) )
									result[n.x][n.y].push(id);
							}
						}
					}
				}
			}
			
			for (var xKey2:String in result)
				for (var zKey2:String in result[xKey2])
					trace(xKey2, ",", zKey2, "|", result[xKey2][zKey2]);
			return result;
		}*/
	}
}

import julio.tactics.regras.GURPS.batalha.TileData;

internal class Vertice
{
	public var x:int;
	public var z:int;
	public var y:int;
	public var data:TileData;		// void, grass, water, ...
	private var _suc:Array;			// lista de sucessores deste vertice
	private var _obj:Array;			// lista de objetos contidos no vertice
	
	public function Vertice( x:int, y:int, z:int, data:TileData )
	{
		this.x = x;
		this.z = z;
		this.y = y;
		this.data = data;
		this._obj = new Array;
		this._suc = new Array;
	}
	
	public function get obj():Array { return this._obj; }
	public function get suc():Array { return this._suc; }
	
	public function get numSuc():int { return this._suc.length; }
	public function get numObj():int { return this._obj.length; }
	
	public function addObj( id:uint ):void { if ( this._obj.indexOf(id) == -1 ) this._obj.push(id); }
	public function removeObj( id:uint ):void { var index:int = 0; while ( (index = this._obj.indexOf(id)) != -1 ) this._obj.splice(index, 1); }
	
	public function addSuc( id:uint ):void { if ( this._suc.indexOf(id) == -1 ) this._suc.push(id); }
	public function removeSuc( id:uint ):void { var index:int = 0; while ( (index = this._suc.indexOf(id)) != -1 ) this._suc.splice(index, 1); }
}
/*
internal class ObjetoCenario
{
	private var _id:String;
	public var x:int;
	public var z:int;
	
	public function ObjetoCenario( id:String, x:int, z:int )
	{
		this._id = id;
		this.x = x;
		this.z = z;
	}
	
	public function get id():String { return this._id; }
}

internal class TileCenario extends ObjetoCenario
{
	public var y:int;
	
	public function Tile( id:String, x:int, y:int, z:int )
	{
		super(id, x, z);
		this.y = y;
	}
	
	public function get id():String { return this._id; }
}


internal class PersonagemCenario extends ObjetoCenario
{
	public var allyCanPass:Boolean;		// marca se personagens d mesmo grupo podem passar pelo tile ocupado por esse personagem (id_grupo iguais)
	public var othersCanPass:Boolean;	// marca se todos (aliados e inimigos) podem passar pelo tile ocupado por esse personagem (id_grupo diferentes)
	public var id_grupo:String;
	
	public function PersonagemCenario( id:String, id_grupo:String, x:int, z:int )
	{
		super(id, x, z);
		this.id_grupo = id_grupo;
	}
}

internal class ItemCenario extends ObjetoCenario
{
	public var visible:Boolean;
	public function ItemCenario( id:String, x:int, z:int, visible:Boolean )
	{
		super(id, x, z);
		this.visible = visible;
	}
}

internal class ObstaculoCenario extends ObjetoCenario
{
	public function ObstaculoCenario( id:String, x:int, z:int )
	{
		super(id, x, z);
	}
}
*/
/*
Gambits

Targets: Foe, Ally, Self, Ally&Self

Especificadores: para ally
	higest HP
	lowest HP
	higest MP
	lowest MP
	highest max HP
	lowest max HP
	highest max MP
	lowest max MP
	highest level
	lowest level
	
*	strongest attack power
*	weakest attack power
*	strongest magic power
*	weakest magic power
*	strongest defense
*	weakest defense
*	strongest magic defense
*	weakest magic defense
*	strongest status defense
*	weakest status defense
*	strongest speed defense
*	weakest speed defense
	
	HP:			=0%, =100%, >0%, >10%, >20%, >30%, >40%, >50%, >60%, >70%, >80%, >90%, <10%, <20%, <30%, <40%, <50%, <60%, <70%, <80%, <90%, <100%
	MP:			=0%, =100%, >0%, >10%, >20%, >30%, >40%, >50%, >60%, >70%, >80%, >90%, <10%, <20%, <30%, <40%, <50%, <60%, <70%, <80%, <90%, <100%
	Status:		any, any debuff, any buff, KO, Sleep, Confuse, Blind, Poison, Silence, Immobilize, Slow, Protect, Shell, Haste, Invisible, Regen, Berserk, HP Critical(bloodied HP<50%), Near Death(HP<25%)

	elemental-weak:			fire, wind, water, earth, light, dark	(weak siginifica q o alvo recebe dano de fogo)
	elemental-vulnerable:	fire, wind, water, earth, light, dark	(vulnerable significa q o alvo recebe mais dano q o normal de fogo)

	undead
	flying

Especificadores: para foe
	higest HP
	lowest HP
	higest MP
	lowest MP
	highest max HP
	lowest max HP
	highest max MP
	lowest max MP
	highest level
	lowest level
	
	strongest attack power
	weakest attack power
	strongest magic power
	weakest magic power
	strongest defense
	weakest defense
	strongest magic defense
	weakest magic defense
	strongest status defense
	weakest status defense
	strongest speed defense
	weakest speed defense
	
	HP:			=0%, =100%, >0%, >10%, >20%, >30%, >40%, >50%, >60%, >70%, >80%, >90%, <10%, <20%, <30%, <40%, <50%, <60%, <70%, <80%, <90%, <100%
	MP:			=0%, =100%, >0%, >10%, >20%, >30%, >40%, >50%, >60%, >70%, >80%, >90%, <10%, <20%, <30%, <40%, <50%, <60%, <70%, <80%, <90%, <100%
	Status:		any, any debuff, any buff, KO, Sleep, Confuse, Blind, Poison, Silence, Immobilize, Slow, Protect, Shell, Haste, Invisible, Regen, Berserk, HP Critical(bloodied HP<50%), Near Death(HP<25%)

	elemental-weak:			fire, wind, water, earth, light, dark	(weak siginifica q o alvo recebe dano de fogo)
	elemental-vulnerable:	fire, wind, water, earth, light, dark	(vulnerable significa q o alvo recebe mais dano q o normal de fogo)

	undead
	flying
	
*	has item (para usar com steal)
*	party leaders target
*	any
*	nearest
*	furthest
*	targeting leader
*	targeting self
*	targeting ally
*	highest HP
	
*	self HP:		=100%, >10%, >20%, >30%, >40%, >50%, >60%, >70%, >80%, >90%, <10%, <20%, <30%, <40%, <50%, <60%, <70%, <80%, <90%, <100%	(referente ao HP de quem faz a ação e não ao alvo)
*	self MP:		=100%, >10%, >20%, >30%, >40%, >50%, >60%, >70%, >80%, >90%, <10%, <20%, <30%, <40%, <50%, <60%, <70%, <80%, <90%, <100%	(referente ao MP de quem faz a ação e não ao alvo)
*	seld Status:	any, any debuff, any buff, KO, Sleep, Confuse, Blind, Poison, Silence, Immobilize, Slow, Protect, Shell, Haste, Invisible, Regen, Berserk, bloodied(HP<50%), HP Critical(HP<25%) 	(referente ao status de quem faz a ação e não ao alvo)


Especificadores: para self
*	HP:			=0%, =100%, >0%, >10%, >20%, >30%, >40%, >50%, >60%, >70%, >80%, >90%, <10%, <20%, <30%, <40%, <50%, <60%, <70%, <80%, <90%, <100%
*	MP:			=0%, =100%, >0%, >10%, >20%, >30%, >40%, >50%, >60%, >70%, >80%, >90%, <10%, <20%, <30%, <40%, <50%, <60%, <70%, <80%, <90%, <100%
*	Status:		any, any debuff, any buff, KO, Sleep, Confuse, Blind, Poison, Silence, Immobilize, Slow, Protect, Shell, Haste, Invisible, Regen, Berserk, bloodied(HP<50%), HP Critical(HP<25%)
	facing 2 or more enemies
	facing 3 or more enemies
	facing 4 or more enemies


Movement: // Define como usar as ações de movimento em relação ao Target
	// Foe
	Agressive		// Move em direção ao inimigo
	Defensive		// Move para longe do inimigo
	Stationary		// Não move
	
	// Ally
	Helper			// Move em direção ao aliado
	Defensive		// Move para longe do inimigo
	Stationary		// Não move
	
	// Self
	Helper			// Move em direção ao aliado
	Agressive		// Move em direção ao inimigo
	Defensive		// Move para longe do inimigo
	Stationary		// Não move
	
	// Ally&Self
	Helper			// Move em direção ao aliado
	Agressive		// Move em direção ao inimigo
	Defensive		// Move para longe do inimigo
	Stationary		// Não move

*/
