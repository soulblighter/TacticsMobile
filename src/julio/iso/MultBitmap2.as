package julio.iso
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Math;
//	import mx.collections.ArrayList;
	
	/**
	 * Classe que gerencia um bitmap com varias imagens separadas
	 * @author Júlio Cézar
	 */
	public class MultBitmap2
	{
		// O buffer que amazena todo o bitmap
//		private var _buffer:BitmapData;
		
		// O buffer que amazena cada imagem do bitmap
		private var _bitmaps:Array;
		
		// Numero de imagens q tem no bitmap
		private var _numImagens:int;
		
		// Point object usado para copyPixels
//		private var _point:Point;
		
		// Rectangle object usado para copyPixels
//		private var _rect:Rectangle;
		
		// Numero de linhas que a imagem eh dividida
		private var _rows:int;
		
		// Numero de colunas que a imagem eh dividida
		private var _coluns:int;
		
		// largura de 1 tile da imagem
		private var _width:int;
		
		// altura de 1 tile da imagem
		private var _height:int;
		
		private var _pixelSnapping:String;
		private var _smoothing:Boolean;
		private var _transparent:Boolean;
		
		public function MultBitmap2(	bitmap:BitmapData,
									rows:int,
									coluns:int,
									transparent:Boolean = true,
									pixelSnapping:String = "auto",
									smoothing:Boolean = false)
		{
//			super(new BitmapData(bitmap.width/coluns, bitmap.height/rows, transparent, 0x00000000), pixelSnapping, smoothing);
			
			var _buffer:BitmapData;
			
			// copia os dados
			_buffer = bitmap;
			
			_pixelSnapping = pixelSnapping;
			_smoothing = smoothing;
			_transparent = transparent;
			
			_rows = rows;
			_coluns = coluns;
			
			// calcula o numero de imagens no bitmap
			_numImagens = _rows * _coluns;
			
			var _rect:Rectangle = new Rectangle(0, 0, _buffer.width / coluns, _buffer.height / rows);
			_width = _buffer.width / coluns;
			_height = _buffer.height / rows;
			
			_bitmaps = new Array;
			for ( var i:uint = 0; i < _numImagens; i++ )
			{
				var w:int = Math.floor(i % _coluns) * _rect.width;
				var h:int = Math.floor(i / _coluns) * _rect.height;
				
				var bitmapData:BitmapData = new BitmapData( _width, _height, _transparent, 0x00000000);
				bitmapData.copyPixels(_buffer, new Rectangle(w, h, w + _width, h + _height), new Point(0, 0));
				_bitmaps.addItem( bitmapData );
//				_bitmaps.addItem( new Bitmap(bitmapData, pixelSnapping, smoothing) );
			}
			
//			_buffer = bitmap.clone();
//			_point = new Point(0, 0);
			
		}
		
		public function getImage( i:uint ):Bitmap
		{
			return new Bitmap( _bitmaps.getItemAt(i) as BitmapData, _pixelSnapping, _smoothing );
		}
	}
}
