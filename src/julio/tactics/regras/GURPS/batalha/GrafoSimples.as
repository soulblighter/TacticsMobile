package julio.tactics.regras.GURPS.batalha
{
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class GrafoSimples
	{
		private var _vertices:Array;		// Vetor com os vertices
		private var _numVertices:int;
		
		public function GrafoSimples()
		{
			this._numVertices = 0;
			this._vertices = new Array;
		}
		
		public function inserirVertice( data:* ):uint
		{
			var v:Vertice =  new Vertice(data);
			this._vertices.push(v);
			return this._numVertices++;
		}
		
		public function get numVertices():int { return this._numVertices; }
		
		public function inserirArco( origem:uint, destino:uint, /*custo:Number,*/ data:* ):void
		{
			if ( !existeVertice(origem) )
				throw new Error("Origem nao existe em Grafo::inserirArco( " + origem + ", " + destino + " )");
			if ( !existeVertice(destino) )
				throw new Error("Destino nao existe em Grafo::inserirArco( " + origem + ", " + destino + " )");
			if ( origem == destino )
				throw new Error("Origem igual Destino em Grafo::inserirArco( " + origem + ", " + destino + " )");
			
			this._vertices[origem].addSuc(new Arco(destino, /*custo,*/ data));
		}
		
		private function existeVertice( id:uint ):Boolean
		{
			return this._vertices[id]!=undefined;
		}
		
		public function sucessores( id:uint ):Array
		{
			if ( !existeVertice(id) )
				throw new Error("Vertice nao existe Grafo::sucessores( "+id+" )");
			
			return this._vertices[id].suc;
		}
		public function listaSucessores( id:uint ):Array
		{
			if ( !existeVertice(id) )
				throw new Error("Vertice nao existe Grafo::sucessores( "+id+" )");
			
			var temp:Array = new Array;
			for each( var key:Arco in this._vertices[id].suc)
				temp.push(key.destino);
			return temp;
		}
		
		public function antecessores( id:uint ):Array
		{
			if ( !existeVertice(id) )
				throw new Error("Vertice nao existe Grafo::atecessores( "+id+" )");
			
//			return sucessores(x, z);
			// no grafo desse jogo os sucessores sempre sao igual a antecessores
			
			var temp:Array = new Array;
			for (var key:uint = 0; key < this._vertices.length; key++ )
				for each(var arco:Arco in this._vertices[key].suc)
					if ( arco.destino == id )
						temp.push(this._vertices[key]);
			return temp;
		}
		
		public function listaAntecessores( id:uint ):Array
		{
			if ( !existeVertice(id) )
				throw new Error("Vertice nao existe Grafo::atecessores( "+id+" )");
			
//			return sucessores(x, z);
			// no grafo desse jogo os sucessores sempre sao igual a antecessores
			
			var temp:Array = new Array;
			for (var key:uint = 0; key < this._vertices.length; key++ )
				for each(var arco:Arco in this._vertices[key].suc)
					if ( arco.destino == id )
						temp.push(key);
			return temp;
		}
		public function grauSaida( id:uint ):int
		{
			if ( !existeVertice(id) )
				throw new Error("Vertice nao existe Grafo::grauSaida( "+id+" )");
			
			return sucessores(id).length;
		}
		
		public function grauEntrada( id:uint ):int
		{
			if ( !existeVertice(id) )
				throw new Error("Vertice nao existe Grafo::grauEntrada( "+id+" )");
			
			return antecessores(id).length;
		}
		
		public function grau( id:uint ):int
		{
			if ( !existeVertice(id) )
				throw new Error("Vertice nao existe Grafo::existeVertice( "+id+" )");
			
			return grauSaida(id) + grauEntrada(id);
		}
		
		public function distanciasDijkstra( origem:uint, calculaCusto:Function, extra:* ):Array
		{
			if ( !existeVertice(origem) )
				throw new Error("Vertice nao exite GrafoSimples::distanciasDijkstra( " + origem + " )");
			
			var distancias:Array = new Array;	// guarda as distancias do nó de origem aos outros
			var marcados:Array = new Array;		// guarda os nós que jah foram visitados
			
			// desmarca vertices
			// poe um valor alto inicialmente para todos os outor vertices
			// exceto à origem q tem distancia 0
			for (var key:uint = 0; key < this._vertices.length; key++)
			{
				marcados.push(false);
				
				if( origem == key )
					distancias.push(0);
				else
					distancias.push(9999);
			}
			
			var naoMarcados:Array = new Array;	// Fila com os vertices a serem processados
			naoMarcados.push( origem );			// Poe a origem na fila
			marcados[origem] = true;			// Marca a origem
			
			// para cada vertice nao marcado
			while ( naoMarcados.length > 0 )
			{
				//pega um vertice nao marcado
				var fst:uint = naoMarcados.shift();
				
				// pega os sucessores de um vertice
				var temp:Array = sucessores(fst);
				
				// para cada sucessor desse vertice
				for( var a:int = 0; a < temp.length; a++ )
				{
					if( !marcados[temp[a].destino] )
					{
						var custo:Number = calculaCusto(this._vertices[fst].data, this._vertices[temp[a].destino].data, extra);
						//se d[v] > d[u] + w(u, v)
						if ( (distancias[temp[a].destino] > distancias[fst] + custo ) )//&& (distancias[temp[a].destino] <= alcance) )
						{
							distancias[temp[a].destino] = distancias[fst] + custo; // temp[a].custo;
							naoMarcados.push( temp[a].destino );
							marcados[temp[a].destino] = true;
						}
					}
				}
			}
			return distancias;
		}
	}
}

internal class Vertice
{
	private var _suc:Array;		// lista de sucessores deste vertice
	public var data:*;			// dados contidos no vertice
	
	public function Vertice( data:* )
	{
		this._suc = new Array;
		this.data = data;
	}
	
	public function get suc():Array { return this._suc; }
	public function get numSuc():int { return this._suc.length; }
	
	public function addSuc( arco:Arco ):void
	{
		for ( var i:uint = 0; i < this._suc.length; i++ )
			if ( this._suc[i].destino == arco.destino )
				throw new Error("Vertice jah possui esse arco em Vertice::addSuc( [" + arco.destino + ", " + arco.data + "] )");
		
		this._suc.push(arco);
	}
	
	public function removeSuc( id:uint ):void
	{
		for ( var i:uint = 0; i < this._suc.length; i++ )
			if ( this._suc[i].destino == id )
			{
				this._suc.splice(i, 1);
				return;
			}
		
		throw new Error("Vertice nao possui esse arco em Vertice::removeSuc( " + id + " )");
	}
	
	public function toString():String
	{
		return "[Vertice: " + data + " [Sucessores: " + this._suc + "]";
	}
}

internal class Arco
{
	public var destino:uint;
//	public var custo:Number;
	public var data:*;			// dados contidos no arco
	
	public function Arco( destino:uint, /*custo:Number,*/ data:* )
	{
		this.destino = destino;
//		this.custo = custo;
		this.data = data;
	}
	
	public function toString():String
	{
		return "[Arco: " + destino + /*"-" + custo +*/ "-" + data + "]";
	}
}
