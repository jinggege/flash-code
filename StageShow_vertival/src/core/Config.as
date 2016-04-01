package core
{
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;

	public class Config
	{
		/**子特效播放完毕*/
		public static const E_CHILD_PLAY_COMPLETE:String = "E_CHILD_PLAY_COMPLETE";
		/**关闭div 的回调函数名称*/
		public static var jsFunctionName:String = "";
		
		/**打印到浏览器的控制台*/
		public static function log(data:*):void
		{
			ExternalInterface.call("console.log",data);
		}
		
		/**param 版本控制信息*/
		private static const versionDic:Dictionary = new Dictionary();
		versionDic["StageAirship.swf"] = "StageAirshipV.swf";
		versionDic["BoyInStage.swf"] = "BoyInStageV.swf";
		versionDic["EnterEffectChristmas1.swf"] = "EnterEffectChristmas1V.swf";
		versionDic["EnterEffectChristmas2.swf"] = "EnterEffectChristmas2V.swf";
		versionDic["EECrazySkiing.swf"] = "EECrazySkiingV.swf";
		versionDic["EEDragonBoat.swf"] = "EEDragonBoatV.swf";
		versionDic["EEFinalWeapon.swf"] = "EEFinalWeaponV.swf";
		versionDic["StageFlyrug.swf"] = "StageFlyrugV.swf";
		versionDic["GirlInStage.swf"] = "GirlInStageV.swf";
		versionDic["StageHorse.swf"] = "StageHorseV.swf";
		versionDic["EnterEffectCar1.swf"] = "EnterEffectCar1V.swf";
		versionDic["EnterEffectCar2.swf"] = "EnterEffectCar2V.swf";
		versionDic["EnterEffectCar3.swf"] = "EnterEffectCar3V.swf";
		versionDic["EnterEffectCar4.swf"] = "EnterEffectCar4V.swf";
		versionDic["EnterEffectCar5.swf"] = "EnterEffectCar5V.swf";
		versionDic["EnterEffectCar6.swf"] = "EnterEffectCar6V.swf";
		versionDic["StageShHeight.swf"] = "StageShHeightV.swf";
		versionDic["StageShLow.swf"] = "StageShLowV.swf";
		versionDic["StageSkateboard.swf"] = "StageSkateboardV.swf";
		versionDic["StageSuperman.swf"] = "StageSupermanV_1.swf";
		versionDic["EnterEffectValentines.swf"] = "EnterEffectValentinesV.swf";
		versionDic["EEBird.swf"] = "EEBirdV.swf";
		versionDic["EEDeer1.swf"] = "EEDeer1V.swf";
		versionDic["EEDeer2.swf"] = "EEDeer2V.swf";
		versionDic["EEShip20154.swf"] = "EEShip20154V.swf";
		versionDic["EEShip20159.swf"] = "EEShip20159V.swf";
		
		
		
		/**
		 * 获取带版本号的文件
		 * @param  fileName文件名称
		 * return 带版本号的文件名
		 */ 
		public static function getVersion(fileName:String):String
		{
			var name:String = versionDic[fileName]==null? fileName:versionDic[fileName];
			return name;
		}
		
		
	}
}