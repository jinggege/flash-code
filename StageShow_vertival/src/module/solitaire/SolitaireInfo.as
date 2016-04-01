package module.solitaire
{
	/**
	 * 接龙的数据（当前的）
	 * @author jiangquannian
	 * 
	 */	
	public class SolitaireInfo
	{
		/**当前第几轮*/
		public var currRound:int = 0;
		
		/**当前亮着的第几盏灯，从1开始*/
		public var currLightIdx:int = 0;
		
		/**当前的气泡索引，从1开始*/
		public var currBubbleIdx:int = 1;
		
		/**上一个的气泡索引，从1开始*/
		public var lastBubbleIdx:int = 0;
		
		/**当前的接龙总次数*/
		public var currTotal:int = 0;
		
		/**当前泡泡的百分比*/
		public var bubblePercent:Number = 0;
		
		/**倒计时时间*/
		public var countdown:int = 0;
		
		/**泡泡的颜色*/
		public var bubbleColor:int = 0;
		
		/**礼物的图标*/
		public var giftImg:String = "";
		
		/**礼物的个数*/		
		public var giftNum:int;
		
		/**数据是否准备完毕（指有没有从服务端返回）*/
		public var isReady:Boolean = false;
		
		/**是否是房间主播*/
		public var isAnchor:Boolean = false;
		
		public function SolitaireInfo()
		{
		}
		
		public function get isPlaying():Boolean
		{
			return currRound>0;
		}
		
	}
}