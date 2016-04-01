package module.solitaire
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;

	public class SolitaireConst
	{
		/**点亮下一盏灯需要点击的次数*/
		public static const NEXT_LIGHT_CLICK_NEED:Array = [1,2,3,5,10];
		
		public static const LIGHT_COUNT:int = 10;
		
		public static function getCurrRound(currTotal:int):int
		{
			if (currTotal == 0)
				return 0;
			var round:uint = 0;
			var len:int = NEXT_LIGHT_CLICK_NEED.length;
			var needTotal:int = 0;
			for (var i:int=0; i<len; ++i)
			{
				needTotal += NEXT_LIGHT_CLICK_NEED[i]*LIGHT_COUNT;
				if (currTotal < needTotal)
				{
					round = i+1;
					break;
				}
			}
			return round;
		}
		
		public static function getCurrLightInfo(currTotal:int):Object
		{
			var obj:Object = new Object();
			if (currTotal == 0)
			{
				obj.lightIndex = 0;
				obj.lightPercent = 0;
				return obj;
			}
			var len:int = NEXT_LIGHT_CLICK_NEED.length;
			var needTotal:int = 0;
			var lastTotal:int = 0;
			for (var i:int=0; i<len; i++)
			{
				needTotal += NEXT_LIGHT_CLICK_NEED[i]*LIGHT_COUNT;
				if (i > 0)
					lastTotal +=  NEXT_LIGHT_CLICK_NEED[i-1]*LIGHT_COUNT;
				if (currTotal < needTotal && currTotal >= lastTotal)
				{
					obj.lightIndex = int ((currTotal - lastTotal)/NEXT_LIGHT_CLICK_NEED[i]);
					//计算计算计算
					if (NEXT_LIGHT_CLICK_NEED[i] == 1)
						obj.lightPercent = 1;
					else
						//obj.lightPercent = ((currTotal - lastTotal )%NEXT_LIGHT_CLICK_NEED[i] + 1)/NEXT_LIGHT_CLICK_NEED[i];
						obj.lightPercent = ((currTotal - lastTotal )%NEXT_LIGHT_CLICK_NEED[i])/NEXT_LIGHT_CLICK_NEED[i];
					break;
				}
			}
			return obj;
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
			var colorValue:uint = 0xffffff;
			switch(color)
			{
				case 1:
				{
					colorValue = 0xffffff;
					break;
				}
				case 2:
				{
					colorValue = 0x0DECFE;
					break;
				}
				case 3:
				{
					colorValue = 0xC6FF19;
					break;
				}
				case 4:
				{
					colorValue = 0xFDC701;
					break;
				}
				case 5:
				{
					colorValue = 0xFF6A00;
					break;
				}
			}
			colorTrans.color = colorValue;
			disObj.transform.colorTransform = colorTrans;
		}
		
	}
}