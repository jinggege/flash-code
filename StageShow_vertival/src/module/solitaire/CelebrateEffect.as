package module.solitaire
{
	import core.DisplayUtil;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 庆祝动画
	 * @author jiangquannian
	 * 
	 */	
	public class CelebrateEffect extends Sprite
	{
		
		private var mcArr:Array;
		
		public function CelebrateEffect(num:int)
		{
			super();
			
			var McClass:Class = getDefinitionByName("CelebratePillarMC") as Class;
			
			mcArr = new Array();
			for (var i:int=0; i<num; ++i)
			{
				var mc:MovieClip = new McClass() as MovieClip;
				DisplayUtil.stopMc(mc);
				mcArr.push(mc);
				this.addChild(mc);
				mc.visible = false;
			}
			
			this.mouseChildren = this.mouseEnabled = false;
		}
		
		public function setSpacing(value:Number):void
		{
			var len:int = mcArr.length;
			for (var i:int=0; i<len; ++i)
			{
				mcArr[i].x = i*value;
			}
		}
		
		private var sIndex:int = 0;
		public function play():void
		{
			sIndex = 0;
			overNum = 0;
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
		}
		
		private var overNum:int = 0;
		private function onEnterFrame(evt:Event):void
		{
			var len:int = mcArr.length;
			if (sIndex < len)
			{
				mcArr[sIndex].visible = true;
				mcArr[sIndex].gotoAndStop(1);
				DisplayUtil.playMc(mcArr[sIndex]);
			}
			
			for (var i:int=0; i<len; ++i)
			{
				var mc:MovieClip = mcArr[i];
				if (mc.visible==false)
					continue;
				if (mc.currentFrame >= mc.totalFrames)
				{
					++overNum;
					mc.visible = false;
					DisplayUtil.stopMc(mc);
				}
			}
			
			if (overNum >= len)
				playOver();
			
			++sIndex;
		}
		
		
		private function playOver():void
		{
			var len:int = mcArr.length;
			for (var i:int=0; i<len; ++i)
			{
				var mc:MovieClip = mcArr[i];
				DisplayUtil.stopMc(mc);
				mc.visible = false;
			}
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.dispatchEvent(new Event(Event.COMPLETE));
			
		}
		
	}
}