package julio.tactics.regras.Basic
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
		
		public function inserirVertice( id:uint, data:* ):uint
		{
			var v:Vertice =  new Vertice(data);
			this._vertices[id] = v;
			return this._numVertices++;
		}
		
		public function get numVertices():int { return this._numVertices; }
		
		public function getVertice( id:uint ):* { return this._vertices[id]; }
		public function getArco( origem:uint, destino:uint ):* { return this._vertices[origem].suc[destino]; }
		
		public function inserirArco( origem:uint, destino:uint, data:* ):void
		{
			if ( !existeVertice(origem) )
				throw new Error("Origem nao existe em Grafo::inserirArco( " + origem + ", " + destino + " )");
			if ( !existeVertice(destino) )
				throw new Error("Destino nao existe em Grafo::inserirArco( " + origem + ", " + destino + " )");
			if ( origem == destino )
				throw new Error("Origem igual Destino em Grafo::inserirArco( " + origem + ", " + destino + " )");
			
				this._vertices[origem].addSuc(new Arco(destino, data));
				this._vertices[destino].addSuc(new Arco(origem, data));
		}
		
		public function existeVertice( id:uint ):Boolean
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
		
		public function fromXML( grafo:XML ):void
		{
			for ( var a:uint = 0; a < grafo.tile.length(); a++ )
			{
				var vertice:XML = grafo.tile[a];
				var id:uint = uint(vertice.@id);
				
				inserirVertice( uint(vertice.@id), vertice );
			}
			
			for ( var b:uint = 0; b < grafo.arco.length(); b++ )
			{
				var arco:XML = grafo.arco[b];
				
				inserirArco( uint(arco.@origem), uint(arco.@destino), arco );
			}
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
	public var data:*;			// dados contidos no arco
	
	public function Arco( destino:uint, /*custo:Number,*/ data:* )
	{
		this.destino = destino;
		this.data = data;
	}
	
	public function toString():String
	{
		return "[Arco: " + destino + "-" + data + "]";
	}
}
