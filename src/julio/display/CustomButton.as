package julio.display
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	
	public class CustomButton extends SimpleButton
	{
		private var upColor:uint = 0xFFCC00;
		private var overColor:uint = 0xCCFF00;
		private var downColor:uint = 0x00CCFF;
		private var size:uint = 80;
		
		public function CustomButton()
		{
			super();
			downState = createShape(downColor, size);
			overState = createShape(overColor, size);
			upState = createShape(upColor, size);
			hitTestState = createShape(upColor, size * 2);
			hitTestState.x = -(size / 4);
			hitTestState.y = hitTestState.x;
			useHandCursor = true;
		}
		
		private function createShape(bgColor:uint, size:uint):Shape
		{
			var s:Shape = new Shape();
			s.graphics.beginFill(bgColor);
			s.graphics.drawRect(0, 0, size, size);
			s.graphics.endFill();
			return s;
		}
		
		
	}

}