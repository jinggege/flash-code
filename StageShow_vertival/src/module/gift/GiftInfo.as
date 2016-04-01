package module.gift
{
	public class GiftInfo
	{
		/**唯一标识符*/
		public var id:int;
		
		/**礼物图片路径*/
		public var imgUrl:String = "";
		
		/**礼物的数目*/
		public var num:uint = 0;
		
		public var flyCount:int = 0;
		public var flyStartNum:int = 0;
		public var flyEndNum:int = 0;
		
		public function GiftInfo()
		{
		}
		
	}
}