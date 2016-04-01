package child.dragonboat
{
	import core.BaseEffect;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import jgg.YaHeiFormat;
	
	public class EEDragonBoatV extends BaseEffect
	{
		public function EEDragonBoatV()
		{
			super();
		}
		
		override protected function addLevelIcon(data:Object):void
		{
			//super.addLevelIcon(data);
			//levelImg.x = 8;
			//levelImg.y = 14;
		}
		
		override protected function setNameStyle():void
		{
			var tfName:TextField = _instance.info.label;
			var tff:TextFormat = YaHeiFormat.getYaHeiFormat(14,0x333333,"center");
			tfName.setTextFormat(tff);
			tfName.defaultTextFormat = tff;
		}
		
		/**
		 * 主要显示对象在fla中的类
		 * 需要在子类中覆盖
		 */		
		override public function get instanceClass():Class
		{
			return Dragon_Boat;
		}
		
		
		
	}
}