package core
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;

	public class DisplayUtil
	{
		public function DisplayUtil()
		{
		}
		
		public static function stopMc(mc:MovieClip):void
		{
			mc.stop();
			var num:int = mc.numChildren;
			for (var i:int=0; i<num; ++i)
			{
				if (mc.getChildAt(i) is MovieClip)
				{
					stopMc(mc.getChildAt(i) as MovieClip);
				}
			}
		}
		
		public static function playMc(mc:MovieClip):void
		{
			mc.play();
			var num:int = mc.numChildren;
			for (var i:int=0; i<num; ++i)
			{
				if (mc.getChildAt(i) is MovieClip)
				{
					playMc(mc.getChildAt(i) as MovieClip);
				}
			}
		}
		
		/**
		 * 设置显示对象颜色
		 * @param disObj
		 * @param color
		 * 
		 */		
		public static function setDisObjColor(disObj:DisplayObject, color:int):void
		{
			var colorTrans:ColorTransform = disObj.transform.colorTransform;
			colorTrans.color = color;
			disObj.transform.colorTransform = colorTrans;
		}
		
	}
}