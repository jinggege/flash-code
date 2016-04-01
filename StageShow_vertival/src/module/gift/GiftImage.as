package module.gift
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class GiftImage extends Sprite
	{
		private var bm1Spt:Sprite;
		/**用于在原始位置的放大并消失*/
		private var bm1:Bitmap;
		
		private var bm2Spt:Sprite;
		/**用于一直往上飘并最终消失*/
		private var bm2:Bitmap;
		
		public var gId:int;
		
		public function GiftImage(bm:Bitmap, id:int)
		{
			super();
			
			bm1 =  new Bitmap();
			bm2 = new Bitmap();
			
			setBm(bm, id);
			
			bm2.width = bm2.height = 60;
			bm2.x = -bm2.width/2;
			bm2.y = -bm2.height/2;
			bm1.width = bm1.height = 60;
			bm1.x = -bm1.width/2;
			bm1.y = -bm1.height/2;
			
			bm1Spt = new Sprite();
			bm2Spt = new Sprite();
			
			bm2Spt.addChild(bm2);
			bm1Spt.addChild(bm1);
			this.addChild(bm1Spt);
			this.addChild(bm2Spt);
			
			bm2Spt.visible = bm1Spt.visible = false;
			
			//bm1Spt.graphics.beginFill(0xff0f0f,0.5);
			//bm1Spt.graphics.drawRect(bm1.x, bm1.y, bm1Spt.width, bm1Spt.height);
			//bm1Spt.graphics.endFill();
		}
		
		/**
		 * 左右来回的飘
		 */		
		public function play():void
		{
//			playPart1();
//			TweenLite.delayedCall(0.1, playPart2);
			playPart2();
//			flyWithBezier();
		}
		
		/**
		 * 在原始位置的放大并消失
		 */		
		private function playPart1():void
		{
			bm1Spt.visible = true;
			bm1Spt.x = 0;
			bm1Spt.y = 0;
			bm1Spt.width = bm1Spt.height = 60;
			bm1Spt.alpha = 0.5;
			TweenLite.to(bm1Spt, 0.5, {y:-25, width:100, height:100, alpha:0});
		}
		
		private var timeLine:TimelineLite = new TimelineLite();
		/**
		 * 一直往上飘并最终消失
		 */		
		private function playPart2():void
		{
			bm2Spt.visible = true;
			bm2Spt.x = 0;
			bm2Spt.y = 0;
//			bm2Spt.y = -30;
			bm2Spt.scaleX = bm2Spt.scaleY = 0.2;
//			bm2Spt.scaleX = bm2Spt.scaleY = 0.5;
			bm2Spt.alpha = 1; 
			
			//bm2Spt.graphics.clear()
			//bm2Spt.graphics.beginFill(Math.random()*0xfffff,0.5);
			//bm2Spt.graphics.drawRect(bm2.x, bm2.y, bm2.width, bm2.height);
			//bm2Spt.graphics.endFill();
			
			var timeRandom:Number = (0.7 + 0.3*Math.random())*0.8; 
			
			timeLine.killTweensOf(bm2Spt);
			timeLine.stop();
			timeLine.clear();
			
			var tx:int = -100;
			var xRandom:Number = tx*Math.random();
			
			var ty:int = -300;
			//var yRandom:Number = ty*(0.8 + 0.2*Math.random());
			
			timeLine.append( TweenLite.to(bm2Spt, 1*timeRandom, {y:ty*(0.2+0.1*Math.random()), x:xRandom*(0.2+0.3*Math.random()), scaleX:0.8, scaleY:0.8, ease:Linear.easeNone}) );
//			timeLine.append( TweenLite.to(bm2Spt, 2.4*timeRandom, {y:-240, x:xRandom*0.9,  scaleX:1, scaleY:1, ease:Linear.easeNone}) );
			timeLine.append( TweenLite.to(bm2Spt, 3*timeRandom, {y:ty*(0.7+0.1*Math.random()), x:xRandom*(0.8+0.2*Math.random()), alpha:0.4+0.6*Math.random(), scaleX:1, scaleY:1, ease:Linear.easeNone}) );
			timeLine.append( TweenLite.to(bm2Spt, 1.5*timeRandom, {y:ty, x:xRandom*0.8, scaleX:1.2, scaleY:1.2, alpha:0, ease:Linear.easeNone, onComplete:onPart2Complete }) );
			
//			timeLine.append( TweenLite.to(bm2Spt, 0.6*timeRandom, {y:-50, scaleX:0.8, scaleY:0.8, ease:Linear.easeNone}) );
//			timeLine.append( TweenLite.to(bm2Spt, 4.2*timeRandom, {y:-300, scaleX:1, scaleY:1, ease:Linear.easeNone}) );
//			timeLine.append( TweenLite.to(bm2Spt, 2.1*timeRandom, {y:-400, scaleX:1.2, scaleY:1.2, alpha:0, ease:Linear.easeNone, onComplete:onPart2Complete }) );
			timeLine.restart();
			
//			swingBm2();
		}
		
		private const SWING_DIS:int = 16;
		private const SWING_ROTA:int = 12;
		
		private function swingBm2():void
		{
			var dir:int = 1;//1向右
			if (Math.random() > 0.5)
				dir = -1;//-1向左
			
			dir = -1;
			
//			bm2Spt.x = -dir*(SWING_DIS - 10 + 10*Math.random());
			bm2Spt.x = 0;
//			bm2Spt.rotation = dir*SWING_ROTA;
			
			if (dir==1)
				leftToRight();
			else
				rightToLeft();
		}
		
		private function rightToLeft():void
		{
			var disRandom:Number = SWING_DIS - 10 + 10*Math.random();
			var time:Number = 1+0.5*Math.random();
			TweenLite.to(bm2Spt, time, {x:-disRandom, ease:Linear.easeNone, onComplete:leftToRight});
//			TweenLite.to(bm2Spt, time, {x:-disRandom, rotation:SWING_ROTA, ease:Linear.easeNone, onComplete:leftToRight});
		}
		
		private function leftToRight():void
		{
			var disRandom:Number = SWING_DIS - 10 + 10*Math.random();
			var time:Number = 1+0.5*Math.random();
			TweenLite.to(bm2Spt, time, {x:disRandom, ease:Linear.easeNone,onComplete:rightToLeft});
//			TweenLite.to(bm2Spt, time, {x:disRandom, rotation:-SWING_ROTA, ease:Linear.easeNone,onComplete:rightToLeft});
		}
		
		private function onPart2Complete():void
		{
			stop();
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function flyWithBezier():void
		{
			bm2Spt.visible = true;
			bm2Spt.x = 0;
			bm2Spt.y = 0;
			bm2Spt.scaleX = bm2Spt.scaleY = 0.2;
			bm2Spt.alpha = 1; 
			
			TweenMax.to(bm2Spt, 3, {bezierThrough:[{x:-30, y:-300}, {x:-20, y:-382}], orientToBezier:true});
			TweenMax.to(bm2Spt, 3, {scaleX:1, scaleY:1});
		}
		
		public function stop():void
		{
			if (bm2Spt.visible || bm1Spt.visible) 
			{
				TweenLite.killDelayedCallsTo(playPart2);
				
				TweenLite.killTweensOf(bm2Spt);
				TweenLite.killTweensOf(bm2Spt);
				
				bm1.bitmapData = bm2.bitmapData = null;
				bm2Spt.visible = bm1Spt.visible = false;
			}
		}
		
		public function setBm(bm:Bitmap, id:int):void
		{
			bm1.bitmapData = bm2.bitmapData = bm.bitmapData;
			bm1.smoothing = bm2.smoothing = true;
			
			gId = id;
		}
		
		
	}
}