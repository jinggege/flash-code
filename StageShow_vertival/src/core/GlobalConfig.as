package core
{
	import flash.external.ExternalInterface;
	
	import module.gift.GiftManager;

	public class GlobalConfig
	{
		
		/**礼物层*/
		public static const STAGE_LAYER_GIFT:uint = 0;
		/**进场特效--特效层*/
		public static const STAGE_LAYER_ENTER_E:uint = 1;
		/**进场特效--名牌层*/
		public static const STAGE_LAYER_ENTER_U:uint = 2;
		/**接龙层*/
		public static const STAGE_LAYER_SOLITAIRE:uint = 3;
		
		public static const MAX_STAGE_WIDTH:uint = 540;
		public static const MAX_STAGE_HEIGHT:uint = 480;
		public static var stageWidth:uint = 540;
		public static var stageHeight:uint = 480;
		
		/**房间类型  普通秀场*/
		public static const ROOM_TYPE_NORMAL:int = 0;
		
		/**特定数量 礼物造型组合*/
		public static const NUM_FIXED_LIST:Array = [10,66,99,188,520,1314,3344];
		
		/**礼物特效是否播放完毕*/
		public static var giftEffectComplete:Boolean = true
		/**进场特效是否播放完毕*/
		public static var enterEffectComplete:Boolean = true;
		
		
//		private static var isDivOpen:Boolean = false;
		
		/**
		 * 想js发请求折叠div
		 */		
		public static function foldDiv():void
		{
			if (giftEffectComplete == false)
				return;
			if (enterEffectComplete == false)
				return;
			
			ExternalInterface.call(Config.jsFunctionName);
			//关闭特效显示的UI
			GiftManager.instance.hideUI();
		}
		
		
		public static function openDiv():void
		{
			ExternalInterface.call("_flash_gifter_flow");
			giftEffectComplete = false;
			enterEffectComplete  = false;
		}		
		
		public function GlobalConfig()
		{
		}
	}
}