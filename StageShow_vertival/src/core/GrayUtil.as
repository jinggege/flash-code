package core
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;

	public class GrayUtil
	{
		public function GrayUtil()
		{
		}
		
		private static var matrix:Array = [ 0.5,0.5,0.082,0,0,0.5,0.5,0.082,0,0,0.5,0.5,0.082,0,0,0,0,0,1,0 ];
		
		/**
		 * 置灰
		 * @param disObj
		 * 
		 */		
		public static function setGray(disObj:DisplayObject):void
		{
			var colorMat:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			disObj.filters = [colorMat];
		}
	}
}