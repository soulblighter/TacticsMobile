/**
 * DATA STRUCTURES FOR GAME PROGRAMMERS
 * Copyright (c) 2007 Michael Baczynski, http://www.polygonal.de
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package de.polygonal.ds
{
	import de.polygonal.ds.Graph;
	import de.polygonal.ds.GraphNode;
	import de.polygonal.ds.Iterator;

	public class GraphIterator implements Iterator
	{
		private var _nodes:Array;
		private var _cursor:int;
		private var _size:int;

		public function GraphIterator(graph:Graph)
		{
			_nodes = graph.nodes;
			_size = graph.maxSize;
		}
		
		public function get data():*
		{
			var n:GraphNode = _nodes[_cursor];
			if (n) return n.data;
		}

		public function set data(obj:*):void
		{
			var n:GraphNode = _nodes[_cursor];
			if (n) n.data = obj;
		}
		
		public function start():void
		{
			_cursor = 0;
		}
		
		public function hasNext():Boolean
		{
			return _cursor < _size;
		}

		public function next():*
		{
			if (_cursor < _size)
			{
				var item:* = _nodes[_cursor];
				if (item)
				{
					_cursor++;
					return item;
				}
				
				while (_cursor < _size)
				{
					item = _nodes[_cursor++];
					if (item) return item;
				}
			}
			return null;
		}
	}
}