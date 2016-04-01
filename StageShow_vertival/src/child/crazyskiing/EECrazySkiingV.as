package child.crazyskiing
{
	import core.BaseEffect;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import jgg.YaHeiFormat;
	
	public class EECrazySkiingV extends BaseEffect
	{
		public function EECrazySkiingV()
		{
			super();
		}
		
		override protected function addLevelIcon(data:Object):void
		{
			//super.addLevelIcon(data);
			//levelImg.x = 77;
			//levelImg.y = 23;
		}
		
		override protected function setNameStyle():void
		{
			var tfName:TextField = _instance.info.label;
			var tff:TextFormat = YaHeiFormat.getYaHeiFormat(14, 0x0C436C,"left");
			tfName.setTextFormat(tff);
			tfName.defaultTextFormat = tff;
		}
		
		override public function get instanceClass():Class
		{
			return Crazy_Skiing;
		}
		
		override public function get instanceX():Number
		{
			return 425;
		}
		
		override public function get instanceY():Number
		{
			return 165;
		}
	}
}