package julio.tactics.regras.GURPS.batalha
{
	import away3d.core.math.Number2D;
	import away3d.core.math.Number3D;
	import julio.tactics.regras.GURPS.batalha.TileData;
	import julio.tactics.regras.GURPS.enuns.ETile;
	import julio.tactics.regras.GURPS.enuns.EArc;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class Grafo3
	{
		private var _vertices:Array;		// Vetor com os vertices
		private var _numVertices:uint;		// Numero de vertices do grafo
		private var _objetos:Array;			// lista objetos do cenário
		private var _numObjetos:uint;		// Numero de vertices do grafo
		
		public function Grafo3()
		{
			this._vertices = new Array;
			this._numVertices = 0;
			this._objetos = new Array;
			this._numObjetos = 0;
		}
		
		public function inserirVertice( id:uint, data:TileData ):uint
		{
//			this._vertices.push( new Vertice( data ) );
			this._vertices[id] = new Vertice( data );
			return this._numVertices++;
		}
		
		public function existeVertice( id:uint ):Boolean
		{
			return (this._vertices[id] != undefined || this._vertices[id] != null)
		}
		
		public function fromXML( grafo:XML ):void
		{
			// vertices
//			var v:Array = [];
			
			var dbg1:uint = grafo.tile.length();
			var dbg2:uint = grafo.arco.length();
			
			for ( var a:uint = 0; a < grafo.tile.length(); a++ )
			{
				var vertice:XML = grafo.tile[a];
				var type:ETile;
				var id:uint = uint(vertice.@id);
				
				switch( String(vertice.@tipo) )
				{
					case "PLAIN": type = ETile.PLAIN; break;
					case "GRASS": type = ETile.GRASS; break;
					case "ROCK": type = ETile.ROCK; break;
					case "SAND": type = ETile.SAND; break;
					case "ICE": type = ETile.ICE; break;
					case "WATER": type = ETile.WATER; break;
					case "LAVA": type = ETile.LAVA; break;
					default: type = ETile.PLAIN;
				}
//				v[uint(vertice.@id)] = inserirVertice( new TileData( vertice.@x, vertice.@y, vertice.@z, vertice.@h, type ) );
				inserirVertice( uint(vertice.@id), new TileData( vertice.@x, vertice.@y, vertice.@z, vertice.@h, type ) );
			}
			
			for ( var b:uint = 0; b < grafo.arco.length(); b++ )
			{
				var arco:XML = grafo.arco[b];
				var arcType:EArc;
				
				switch( String(arco.@tipo) )
				{
					case "SIMPLE": arcType = EArc.SIMPLE; break;
					case "HJUMP": arcType = EArc.HJUMP; break;
					case "DJUMP": arcType = EArc.DJUMP; break;
					default: arcType = EArc.SIMPLE;
				}
//				inserirArco( v[uint(arco.@origem)], v[uint(arco.@destino)], new ArcData( arcType ) );
				inserirArco( uint(arco.@origem), uint(arco.@destino), new ArcData( arcType ) );
			}
		}
		
		public function get numVertices():int { return this._numVertices; }
//		public function get vertices():Array { return this._vertices; }
		
		public function getData( id:uint ):TileData { return this._vertices[id].data; }
		public function getObjects( id:uint ):Array { return this._vertices[id].obj; }
		
		public function inserirArco( origem:uint, destino:uint, data:ArcData ):void
		{
			if ( !existeVertice(origem) )
				throw new Error("Origem nao existe em Grafo::inserirArco( " + origem + ", " + destino + " )");
			if ( !existeVertice(destino) )
				throw new Error("Destino nao existe em Grafo::inserirArco( " + origem + ", " + destino + " )");
			if ( origem == destino )
				throw new Error("Origem igual Destino em Grafo::inserirArco( " + origem + ", " + destino + " )");
			
			this._vertices[origem].addSuc( destino, data );
			this._vertices[destino].addSuc( origem, data );
		}
		
		public function inserirObjeto( id:uint, o:ObjetoCenario ):uint
		{
			this._objetos.push(o);
			this._numObjetos++;
			this._vertices[id].addObj( this._numObjetos );
			return this._numObjetos;
		}
	
		public function numObjetos( id:uint ):uint
		{
			return this._vertices[id].obj.length;
		}
	
		public function sucessores( id:uint ):Object
		{
			if ( !existeVertice(id) )
				throw new Error("Vertice nao existe Grafo::sucessores( "+id+" )");
			
			return this._vertices[id].suc;
		}
		
		public function antecessores( id:uint ):Object
		{
//			if ( !existeVertice(id) )
//				throw new Error("Vertice nao existe Grafo::atecessores( "+id+" )");
			
			return sucessores(id);
			// no grafo desse jogo os sucessores sempre sao igual a antecessores
		}
		
		public static function getLength(o:Object):uint
		{
			var len:uint = 0;
			for (var item:* in o)
				if (item != "mx_internal_uid")
					len++;
			return len;
		}
		
		public function grauSaida( id:uint ):int
		{
//			if ( !existeVertice(id) )
//				throw new Error("Vertice nao existe Grafo::grauSaida( "+id+" )");
			
			return getLength(sucessores(id));
		}
		
		public function grauEntrada( id:uint ):int
		{
//			if ( !existeVertice(x, z) )
//				throw new Error("Vertice nao existe Grafo::grauEntrada( "+id+" )");
			
//			return antecessores(id).length;
			return getLength(antecessores(id));
		}
		
		public function grau( id:uint ):int
		{
//			if ( !existeVertice(id) )
//				throw new Error("Vertice nao existe Grafo::existeVertice( "+id+" )");
			
			return grauSaida(id) + grauEntrada(id);
		}
		
		public function custoSimples( origem:uint, destino:uint ):uint
		{
			if ( !existeVertice(origem) )
				throw new Error("Origem nao existe em Grafo::custoSimples( " + origem + ", " + destino + " )");
			if ( !existeVertice(destino) )
				throw new Error("Destino nao existe em Grafo::custoSimples( " + origem + ", " + destino + " )");
			if ( origem == destino )
				throw new Error("Origem igual Destino em Grafo::custoSimples( " + origem + ", " + destino + " )");
			
			var o:TileData = this._vertices[origem].data;
			var d:TileData = this._vertices[destino].data;
			
			return	Math.abs(d.x - o.x) +					// diferença em x
					Math.abs(d.z - o.z) +					// deferença em z
					Math.abs( (d.y + d.h) - (o.y + o.h) );	// diferença na altura
		}
		
		
		public function distanciasDijkstra( idOrigem:uint, calculaCusto:Function, podePassar:Function, podeFicar:Function, extra:*, alcance:int = 99 ):Array
		{
			if ( !existeVertice(idOrigem) )
				throw new Error("Vertice nao exite Grafo::distanciasDijkstra( " + idOrigem + " )");
			
			var origem:Vertice = this._vertices[idOrigem];
			
			
			var distancias:Array = new Array;		// guarda as distancias do nó de origem aos outros
			var marcados:Array = new Array;			// guarda os nós que jah foram visitados
			
			// desmarca vertices
			// poe um valor alto inicialmente para todos os outor vertices
			// exceto à origem q tem distancia 0
//			for ( var id:uint = 0; id < this._vertices.length; id++ )
			for ( var key:String in this._vertices )
			{
				var id:uint = uint(key);
				marcados[id] = false;
				
				if( idOrigem == id )
					distancias[id] = 0;
				else
				{
					// marca bloqueados para passagem
//					if( podePassar )
						if ( !podePassar( id, extra ) )
							marcados[id] = true;
					
					distancias[id] = 9999;
				}
			}
			
			var naoMarcados:Array = new Array;						// Fila com os vertices a serem processados
			naoMarcados.push( idOrigem );							// Poe a origem na fila
			marcados[idOrigem] = true;								// Marca a origem
			
			// para cada vertice nao marcado
			while ( naoMarcados.length > 0 )
			{
				//pega um vertice nao marcado
				var fst:uint = naoMarcados.shift();
				
				// pega os sucessores de um vertice
				var temp:Object = sucessores(fst);
				
				// para cada sucessor desse vertice
//				for( var a:int = 0; a < temp.length; a++ )
				for ( var a:String in temp )
				{
					var suc:uint = uint(a);
					
					if( !marcados[suc] )
					{
						//se d[v] > d[u] + w(u, v)
						var custo:Number = calculaCusto( this._vertices[fst].data, this._vertices[suc].data, this._vertices[fst].suc[suc] );
//						var custo:Number = custoSimples( fst, suc );
						
						if(	(distancias[suc] > distancias[fst] + custo) && ( (distancias[fst] + custo) <= alcance) )
						{
							distancias[suc] = distancias[fst] + custo;
							naoMarcados.push( suc );
							marcados[suc] = true;
						}
					}
				}
			}
			
			// marca bloqueados para ficar
//			if( podeFicar )
				for ( var c:int = 0; c < distancias.length; c++ )
					if( !podeFicar(c, extra) )
						distancias[c] = 9999;
				
//			for ( var idKey:int = 0; idKey < distancias.length; idKey++ )
//				trace(idKey, " | ", distancias[idKey]);
			
			return distancias;
		}
		

		public function caminhosDijkstra( idOrigem:uint, calculaCusto:Function, podePassar:Function, podeFicar:Function, extra:*, extra2:*, alcance:int = 99 ):Array
		{
			if ( !existeVertice(idOrigem) )
				throw new Error("Vertice nao exite Grafo::distanciasDijkstra( " + idOrigem + " )");
			
			var origem:Vertice = this._vertices[idOrigem];
			
			
			var distancias:Array = new Array;		// guarda as distancias do nó de origem aos outros
			var marcados:Array = new Array;			// guarda os nós que jah foram visitados
			var caminhos:Array = new Array;			// guarda os caminhos do nó de origem aos outros
			
			// desmarca vertices
			// poe um valor alto inicialmente para todos os outor vertices
			// exceto à origem q tem distancia 0
//			for ( var id:uint = 0; id < this._vertices.length; id++ )
			for ( var key:String in this._vertices )
			{
				var id:uint = uint(key);
				marcados[id] = false;
				caminhos[id] = new Array;
				
				if( idOrigem == id )
					distancias[id] = 0;
				else
				{
					// marca bloqueados para passagem
//					if( podePassar != undefined || podePassar != null )
						if ( !podePassar( this._vertices[id].data, this._vertices[id].obj, extra ) )
							marcados[id] = true;
					
					distancias[id] = 9999;
				}
			}
			
			var naoMarcados:Array = new Array;					// Fila com os vertices a serem processados
			naoMarcados.push( idOrigem );						// Poe a origem na fila
			marcados[idOrigem] = true;							// Marca a origem
			caminhos[idOrigem].push(idOrigem);
			
			// para cada vertice nao marcado
			while ( naoMarcados.length > 0 )
			{
				//pega um vertice nao marcado
				var fst:uint = naoMarcados.shift();
				
				// pega os sucessores de um vertice
				var temp:Object = sucessores(fst);
				
				// para cada sucessor desse vertice
//				for( var a:int = 0; a < temp.length; a++ )
				for ( var a:String in temp )
				{
					var suc:uint = uint(a);
					
					if( !marcados[suc] )
					{
						//se d[v] > d[u] + w(u, v)
						var custo:Number = calculaCusto( this._vertices[fst].data, this._vertices[suc].data, this._vertices[fst].suc[suc], extra2 );
//						var custo:Number = custoSimples( fst, suc );
						
						if(	(distancias[suc] > distancias[fst] + custo) && ( (distancias[fst] + custo) <= alcance) )
						{
							distancias[suc] = distancias[fst] + custo;
							naoMarcados.push( suc );
							marcados[suc] = true;
							
							// troca o caminho da lista pelo novo melhor encontrado
							caminhos[suc].splice(0, caminhos[suc].length);
							for ( var b:int = 0; b < caminhos[fst].length; ++b )
								caminhos[suc].push( caminhos[fst][b] );
							caminhos[suc].push( {id:suc, type:this._vertices[fst].suc[suc].type} );
						}
					}
				}
			}
			
			// marca bloqueados para ficar
//			if( podeFicar != undefined || podeFicar != null )
				for ( var c:String in this._vertices )
				{
					var cid:uint = uint(c);
					if ( !podeFicar(this._vertices[cid].data, this._vertices[cid].obj, extra) )
					{
						distancias[cid] = 9999;
						caminhos[cid] = [];
					}
				}
			
			
//			for ( var idKey:int = 0; idKey < caminhos.length; idKey++ )
//				trace(idKey, " | ", distancias[idKey], " | ", caminhos[idKey]);
			
			return caminhos;
		}
		
		
		public function alcanceDijkstra( idOrigem:uint, alcance:uint, calculaCusto:Function, extra:*, ingnoraOrigem:Boolean = false ):Array
		{
			if ( !existeVertice(idOrigem) )
				throw new Error("Vertice nao exite Grafo::distanciasDijkstra( " + idOrigem + " )");
			
			var origem:Vertice = this._vertices[idOrigem];
			
			var result:Array = new Array;
			var distancias:Array = new Array;		// guarda as distancias do nó de origem aos outros
			var marcados:Array = new Array;			// guarda os nós que jah foram visitados
			
			// desmarca vertices
			// poe um valor alto inicialmente para todos os outor vertices
			// exceto à origem q tem distancia 0
//			for ( var id:uint = 0; id < this._vertices.length; id++ )
			for ( var key:String in this._vertices )
			{
				var id:uint = uint(key);
				marcados[id] = false;
				
				if( idOrigem == id )
					distancias[id] = 0;
				else
					distancias[id] = 9999;
			}
			
			var naoMarcados:Array = new Array;						// Fila com os vertices a serem processados
			naoMarcados.push( idOrigem );							// Poe a origem na fila
			marcados[idOrigem] = true;								// Marca a origem
			
			if (!ingnoraOrigem) result.push(idOrigem);
			
			// para cada vertice nao marcado
			while ( naoMarcados.length > 0 )
			{
				//pega um vertice nao marcado
				var fst:uint = naoMarcados.shift();
				
				// pega os sucessores de um vertice
				var temp:Object = sucessores(fst);
				
				// para cada sucessor desse vertice
//				for( var a:int = 0; a < temp.length; a++ )
				for ( var a:String in temp )
				{
					var suc:uint = uint(a);
					
					if( !marcados[suc] )
					{
						//se d[v] > d[u] + w(u, v)
						var custo:Number = calculaCusto( this._vertices[fst].data, this._vertices[suc].data, this._vertices[fst].suc[suc], extra );
//						var custo:Number = custoSimples( fst, suc );
//						var custo:Number = 1.0;
						
						if(	(distancias[suc] > distancias[fst] + custo) && ( (distancias[fst] + custo) <= alcance) )
						{
							distancias[suc] = distancias[fst] + custo;
							naoMarcados.push( suc );
							marcados[suc] = true;
							result.push( suc );
						}
					}
				}
			}
			
//			for ( var idKey:int = 0; idKey < result.length; idKey++ )
//				trace(idKey, " | ", result[idKey]);
			
			return result;
		}
		
		
		
		
		
		// retorna todos os ObjetoCenario encontrados em cada vertice a partir de uma determinada origem
		// se a area for maior q 0, entao será feita mais uma busca em todos os vertices do alcance
		// a fim de encontrar todos os objetos na area;
		public function search( origem:uint, alcance:uint, area:uint, comparador:Function, calculaCusto:Function, extra:*, ignoraOrigem:Boolean ):Object
		{
			// pega todas vertices no alcance inicial
			var resultAlcance:Array = alcanceDijkstra( origem, alcance, calculaCusto, extra, ignoraOrigem );
			
			var result:Array = new Array;
			
//			trace("dbg1", "alcance: ", resultAlcance);
			
			// para cada vertice no alcance
			for each( var n:uint in resultAlcance )
			{
				// pega os vertices da área
				var resultArea:Array = alcanceDijkstra( n, area, calculaCusto, extra, ignoraOrigem );
				
				result[n] = new Array;
//				trace("dbg2", "area: ", resultArea);
				
				for each( var n2:uint in resultArea )
				{
//					trace("dbg3", this._vertices[n2].obj.length, " | ", this._vertices[n2].obj);
					//result[n].push(n2);
					
					
					if ( this._vertices[n2].obj.length > 0 )
					{
//						if( result[n] == undefined )
//							result[n] = new Array;
						
//						trace( result[n] );
						// se passar no teste da dunção de comparação entao poe objetos no resultado
						for each( var id:uint in this._vertices[n2].obj )
						{
							if ( origem == id )
							{
								if ( !ignoraOrigem )
								{
									if( comparador( this._objetos[id] ) )
										result[n].push(id);
								}
							} else {
								if( comparador( this._objetos[id] ) )
									result[n].push(id);
							}
						}
					}
				}
			}
			
			for (var Key2:String in result)
				trace(Key2, " | ", result[uint(Key2)]);
			return result;
		}
		
		
/*
		
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
		
		
		private function pos2ids( x:int, z:int ):Array
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
*/
		

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
import julio.tactics.regras.GURPS.batalha.ArcData;

internal class Vertice
{
	public var data:TileData;		// void, grass, water, ...
	private var _obj:Array;			// lista de objetos contidos no vertice
	private var _suc:Object;		// sucessores deste vertice
	private var _numSuc:uint;
	
	public function Vertice( data:TileData )
	{
		this.data = data;
		this._numSuc = 0;
		this._obj = new Array;
		this._suc = new Object;
	}
	
	public function get obj():Array { return this._obj; }
	public function get suc():Object { return this._suc; }
	
	public function get numObj():int { return this._obj.length; }
	public function get numSuc():int { return this._numSuc; }
	
	public function addObj( id:uint ):void { if ( this._obj.indexOf(id) == -1 ) this._obj.push(id); }
	public function removeObj( id:uint ):void { var index:int = 0; while ( (index = this._obj.indexOf(id)) != -1 ) this._obj.splice(index, 1); }
	
	public function hasSuc( id:uint ):Boolean { return ( (this._suc[id] != undefined) && (this._suc[id] != null) ); }
	
	public function addSuc( id:uint, data:ArcData ):void { if ( !hasSuc(id) ) { this._suc[id] = data; this._numSuc++; } }
	public function removeSuc( id:uint ):void { if ( hasSuc(id) ) delete this._suc[id]; }
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
