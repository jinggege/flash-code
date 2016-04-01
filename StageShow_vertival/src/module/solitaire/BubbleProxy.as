package module.solitaire
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	 * 气泡的显示代理类（并不是一个显示对象）
	 * @author jiangquannian
	 * 
	 */	
	public class BubbleProxy
	{
		
		private var bubble:MovieClip;
		
		/**倒计时的显示*/
		private var countdownTF:TextField;
		
		private var percentMc:MovieClip;
		
		private var bgMc:MovieClip;
		
		private var countdownTimer:Timer;
		/**倒计时的总时长*/
		private var countdownTotal:int;
		private const PERCENT_H:int = 49;
		/**倒计时的最大时长：15秒*/
		private const TIME_MAX:int = 15;
		
		private var bubbleColor:int = -1;
		private var lightColor:int = -1;
		
		public function BubbleProxy(mc:MovieClip)
		{
			super();
			bubble = mc;
			countdownTF = bubble["countdownTF"];
			percentMc = bubble["percentMc"];
			bgMc = bubble["bgMc"];
			
			percentMc.gotoAndStop(1);
			bgMc.gotoAndStop(1);
			
			countdownTimer = new Timer(1000);
			countdownTimer.addEventListener(TimerEvent.TIMER, onTimerRun);
			countdownTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}
		
		/**
		 * 设置气泡的颜色（1：绿，2：黄，3：橙）
		 * @param color
		 * 
		 */		
		public function setBubbleColor(bColor:int):void
		{
			if (bubbleColor != bColor)
			{
				bubbleColor = bColor;
				bgMc.gotoAndStop(bubbleColor);
				percentMc.gotoAndStop(bubbleColor);
			}
		}
		
		/**
		 * 设置百分比
		 * @param value
		 * 
		 */		
		public function setPercent(value:Number):void
		{
			if (value > 1) value = 1;
			if (value < 0) value = 0;
			percentMc.y = PERCENT_H - PERCENT_H*value - 6;
		}
		public function setPercent2(curr:int, total:int):void
		{
			setPercent(curr/total);
		}
		
		/**
		 * 设置倒计时
		 * @param value
		 * 
		 */		
		public function setCountdown(value:int):void
		{
			countdownTotal = value - 1; //由于发的是16秒（加了动画的1秒），这里多减去一个1
			countdownTimer.stop();
			countdownTimer.reset();
			countdownTimer.repeatCount = countdownTotal;
			countdownTimer.start();
			countdownTF.text = countdownTotal.toString();
		}
		
		private function onTimerRun(evt:TimerEvent):void
		{
			var frame:int = countdownTotal - countdownTimer.currentCount;
			if (frame < 0) frame = 0;
//			if (frame > TIME_MAX) frame = TIME_MAX;
			countdownTF.text = frame.toString();
		}
		
		private function onTimerComplete(evt:TimerEvent):void
		{
			
		}
		
		public function set visible(value:Boolean):void
		{
			bubble.visible = value;
		}
		
		/**
		 * 设置气泡的位置
		 * @param x
		 * @param y
		 * 
		 */		
		public function setXY(x:int, y:int):void
		{
			bubble.x = x - 22.5;
			bubble.y = y - 54;
		}
		
		public function get x():Number
		{
			return bubble.x;
		}
		
		public function get y():Number
		{
			return bubble.y;
		}
		
		public function get content():MovieClip
		{
			return bubble;
		}
		
	}
}