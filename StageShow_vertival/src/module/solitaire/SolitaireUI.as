package module.solitaire
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import core.DisplayUtil;
	import core.GlobalConfig;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * 接龙
	 * @author jiangquannian
	 * 
	 */	
	public class SolitaireUI extends Sprite
	{
		//---------显示-----------
		private var mainMc:MovieClip;
		
		private var startEffect1:MovieClip;
		private var startEffect2:MovieClip;
		
		private var startMc:MovieClip;
		/**用于响应鼠标在一定区域的事件，一个透明的显示对象*/
		private var startResponseMc:MovieClip;
		
		private var lightVect:Vector.<LightProxy>;
		
		private var bubbleProxy:BubbleProxy;
		
		private var giftInfoMc:MovieClip;
		private var giftImg:Bitmap;
		
		private var celebrateEffect:CelebrateEffect;
		
		/**显示总的接龙次数*/
		private var totalSpt:NumberSprite;
		
		/**底部的光晕特效*/
		private var haloEffect:MovieClip;
		
		//---------数据-----------
		private var data:SolitaireInfo;
		
		private var timeLine:TimelineLite;
		
		private var currImgPath:String;
		
		private var isDisappearing:Boolean = false;
		private var isAppearing:Boolean = false;
		
		public function SolitaireUI()
		{
			super();
			timeLine = new TimelineLite();
			currImgPath = "";
		}
		
		public function initView(mc:MovieClip):void
		{
			mainMc = mc;
			DisplayUtil.stopMc(mainMc);
			this.addChild(mainMc);
			
			//初始化
			startEffect1 = mc["startEffect1"];
			startEffect2 = mc["startEffect2"];
			startResponseMc = mc["startResponseMc"];
			startMc = mc["startMc"];
			giftInfoMc = mc["giftInfoMc"];
			DisplayUtil.stopMc(startEffect1);
			DisplayUtil.stopMc(startEffect2);
			startMc.stop();
			//stopMc(startMc);
			DisplayUtil.stopMc(giftInfoMc);
			startMc.visible = false;
			startEffect1.visible = false;
			startEffect1.mouseChildren = startEffect1.mouseEnabled = false;
			startEffect2.visible = false;
			startEffect2.mouseChildren = startEffect2.mouseEnabled = false;
			startMc.mouseChildren = startMc.mouseEnabled = false;
			giftInfoMc.visible = false;
			
			DisplayUtil.setDisObjColor(startEffect1, 0xffc3d7);
			
			giftImg = new Bitmap();
			giftInfoMc["imgMc"].addChild(giftImg);
			
			var bubbleMc:MovieClip = mc["bubbleMc"];
			bubbleMc.mouseChildren = false;
			bubbleProxy = new BubbleProxy(bubbleMc);
			bubbleProxy.visible = false;
			
			haloEffect = mc["haloEffect"];
			DisplayUtil.stopMc(haloEffect);
			
			lightVect = new Vector.<LightProxy>();
			for (var i:int=0; i<SolitaireConst.LIGHT_COUNT; ++i)
			{
				var lightMc:MovieClip = mc["light" + (i+1)];
				var lightProxy:LightProxy = new LightProxy(lightMc);
				lightProxy.setLampColor(0);
				lightVect.push(lightProxy);
				//trace("i:"+ i + ",x:" + lightMc.x + ",y:" + lightMc.y);
			}
			
			//celebrateEffect = mc["celebrateEffect"];
			celebrateEffect = new CelebrateEffect(SolitaireConst.LIGHT_COUNT);
			//DisplayUtil.stopMc(celebrateEffect);
			celebrateEffect.visible = false;
			this.addChild(celebrateEffect);
			celebrateEffect.x = lightVect[0].x;
			celebrateEffect.y = lightVect[0].y;
			celebrateEffect.setSpacing(lightVect[1].x-lightVect[0].x)
			
			//事件监听
			bubbleMc.addEventListener(MouseEvent.ROLL_OVER, onMouseOverBubble, false, 0, true);
			bubbleMc.addEventListener(MouseEvent.ROLL_OUT, onMouseOutBubble, false, 0, true);
			startResponseMc.addEventListener(MouseEvent.ROLL_OVER, onMouseOverStartResponse, false, 0, true);
			startResponseMc.addEventListener(MouseEvent.ROLL_OUT, onMouseOutStartResponse, false, 0, true);
			celebrateEffect.addEventListener(Event.COMPLETE, onCelebrateComplete, false, 0, true);
			startMc.addEventListener(Event.COMPLETE, onStartDisappearComplete, false, 0, true);
			
			startResponseMc.addEventListener(MouseEvent.CLICK, onClickBubble, false, 0 ,true);
			bubbleMc.addEventListener(MouseEvent.CLICK, onClickBubble, false, 0 ,true);
			
			startResponseMc.buttonMode = bubbleMc.buttonMode = true;
			
//			this.graphics.clear();
//			this.graphics.beginFill(0xff0000,0.5);
//			this.graphics.drawRect(mainMc.x,mainMc.y,mainMc.width,mainMc.height);
//			this.graphics.endFill();
		}
		
		public function initTotalSpt(bmd:BitmapData):void
		{
			totalSpt = new NumberSprite();
			totalSpt.setBitmapData(bmd.clone());
			this.addChild(totalSpt);
			totalSpt.visible = false;
			totalSpt.mouseEnabled = totalSpt.mouseChildren = false;
		}
		
		public function refresh(info:SolitaireInfo):void
		{
			data = info;
			if (data == null || data.isReady == false)
			{
				this.visible = false;
				return;
			}
			
			if (info.isAnchor)
				bubbleProxy.content.buttonMode = false;
			else
				bubbleProxy.content.buttonMode = true;
			
			this.visible = true;
			refreshLight();
			
			if (data.isPlaying)
			{
				startResponseMc.visible = startMc.visible = startEffect1.visible = startEffect2.visible = false;
				DisplayUtil.stopMc(startEffect1);
				DisplayUtil.stopMc(startEffect2);
				
				//如果泡泡移动了
				if (data.currBubbleIdx != data.lastBubbleIdx && data.lastBubbleIdx > 0 && data.currBubbleIdx > 0 )
				{
					//判断是否是首次开启 
					if (data.currTotal == 0 || data.currTotal == 1)
					{
						startMc.visible = true;
						startMc.gotoAndPlay("disappear");
					}
					else
					{
						disappearBubble();
					}
				}
				else
				{
					refreshBubble();
//					refreshGiftInfo();
					//光晕位置更新
					haloEffect.x = lightVect[data.currBubbleIdx-1].x;
					haloEffect.y = lightVect[data.currBubbleIdx-1].y;
					DisplayUtil.playMc(haloEffect);
					haloEffect.visible = true;
				}
				
				refreshGiftInfo();
				//总接龙数飘字提示
				if (data.currTotal > 0)
				{
					totalSpt.visible = true;
					TweenLite.killTweensOf(totalSpt);
					totalSpt.alpha = 1.0;
					totalSpt.showNumber(data.currTotal);
					var tempIdx:int = data.currBubbleIdx-1;
					if (data.currBubbleIdx != data.lastBubbleIdx)
						tempIdx = data.lastBubbleIdx-1;
					if (tempIdx < 0)
						tempIdx = 0;
					totalSpt.x = lightVect[tempIdx].x - totalSpt.width/2;
					if (totalSpt.x  < 0)
						totalSpt.x = 0;
					totalSpt.y = lightVect[tempIdx].y -  42;
					TweenLite.to(totalSpt, 0.5, {y:totalSpt.y -30, alpha:0, ease:Cubic.easeIn});
				}
				else
				{
					totalSpt.visible = false;
				}
				
				//如果灯在最后一个则播放庆祝动画
				if (data.currLightIdx == SolitaireConst.LIGHT_COUNT && (data.bubblePercent == 0 || data.bubblePercent == 1))
				{
					SolitaireConst.setDisObjColor(celebrateEffect, data.currRound-1);
					playCelebrate();
				}
			}
			else
			{
				startResponseMc.visible = startEffect1.visible = startEffect2.visible = true;
				//startEffect.visible = false;
				DisplayUtil.playMc(startEffect1);
				DisplayUtil.playMc(startEffect2);
				bubbleProxy.visible = false;
				totalSpt.visible = false;
				giftInfoMc.visible = false;
				haloEffect.visible = false;
			}
		}
		
		/**
		 * 刷新灯的显示 
		 */		
		private function refreshLight():void
		{
			var len:int = lightVect.length;
			var i:int = 0;
			if (data.isPlaying)
			{
				var round:int = data.currRound;
				//灯更新
				for (i=0; i<len; ++i)
				{
					if ( i < data.currLightIdx && 
						!(data.currBubbleIdx == 1 && data.currLightIdx == SolitaireConst.LIGHT_COUNT) )
					{
						lightVect[i].setLampColor(round);
						lightVect[i].setRayColor(round);
					}
					else
					{
						lightVect[i].setLampColor(round-1);
						lightVect[i].setRayColor(0);
					}
					lightVect[i].visible = true;
				}
			}
			else
			{
				for (i=0; i<len; ++i)
				{
					lightVect[i].setLampColor(0);
					lightVect[i].setRayColor(0);
					lightVect[i].visible = false;
				}
			}
		}
		
		/**
		 * 刷新泡泡的显示
		 */		
		private function refreshBubble():void
		{
			if (data.isPlaying)
			{
				//气泡更新
				bubbleProxy.visible = true;
				bubbleProxy.setXY(lightVect[data.currBubbleIdx-1].x, lightVect[data.currBubbleIdx-1].y);
				bubbleProxy.setCountdown(data.countdown);
				bubbleProxy.setBubbleColor(data.bubbleColor);
				bubbleProxy.setPercent(data.bubblePercent);
			}
			else
			{
				bubbleProxy.visible = false;
			}
		}
		
		/**
		 * 刷新礼物信息的显示
		 */		
		private function refreshGiftInfo():void
		{
			if (data.isPlaying)
			{
				(giftInfoMc["numTF"] as TextField).text = data.giftNum + "个";
				loadGiftImg(data.giftImg);
				giftInfoMc.x = lightVect[data.currBubbleIdx-1].x + 2.5;
				giftInfoMc.y = lightVect[data.currBubbleIdx-1].y - 54;
				//调整礼物版的位置
				if (giftInfoMc.x + giftInfoMc.width > GlobalConfig.stageWidth)
				{
					giftInfoMc.x = giftInfoMc.x - giftInfoMc.width - 20;
					(giftInfoMc["bgMc"] as MovieClip).scaleX = -1;
					(giftInfoMc["bgMc"] as MovieClip).x = (giftInfoMc["bgMc"] as MovieClip).width + 10;
				}
				else
				{
					(giftInfoMc["bgMc"] as MovieClip).scaleX = 1;
					(giftInfoMc["bgMc"] as MovieClip).x = 0;
				}
			}
			else
			{
				giftInfoMc.visible = false;
			}
		}
		
		public function hasContent():Boolean
		{
			return mainMc != null;
		}
		
		private function loadGiftImg(imgPath:String):void
		{
			if (currImgPath == imgPath)
				return;
			currImgPath = imgPath;
			
			var sLoader:Loader = new Loader();
			sLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
			var urlReq:URLRequest  = new URLRequest(imgPath);
			sLoader.load(urlReq);
		}
		private function loadCompleteHandler(evt:Event):void
		{
			var sLoader:Loader = (evt.target as LoaderInfo).loader as Loader;
			giftImg.bitmapData = (sLoader.content as Bitmap).bitmapData.clone();
			giftImg.width = giftImg.height = 24;
			
			sLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadCompleteHandler);
			sLoader.unload();
			sLoader = null;
		}
		
		/**
		 * 播放庆祝动画
		 */		
		private function playCelebrate():void
		{
			celebrateEffect.visible = true;
			celebrateEffect.play();
//			celebrateEffect.gotoAndStop(1);
//			DisplayUtil.playMc(celebrateEffect);
//			TweenLite.to(celebrateEffect, 5, {frame:20});
		}
		
		//----------------------------------------------
		// 泡泡的显示和隐藏
		//----------------------------------------------
		
		private function disappearBubble():void
		{
//			if (timeLine.active == false)
			{
				var disObj:DisplayObject = bubbleProxy.content;
				var disObjX:Number = lightVect[data.lastBubbleIdx-1].x - disObj.width/2;
				var disObjY:Number = lightVect[data.lastBubbleIdx-1].y - 60;
				var tempX1:Number = disObjX - 1.1;
				var tempY1:Number = disObjY - 5.5;
				var tempX2:Number = disObjX + 11.2;
				var tempY2:Number = disObjY + 30.5;
				
				timeLine.killTweensOf(disObj);
				timeLine.stop();
				timeLine.clear();
				timeLine.append( TweenLite.to(disObj, 5/24, {x:tempX1, y:tempY1, scaleX:1.05, scaleY:1.05}) );
				timeLine.append( TweenLite.to(disObj, 5/24, {x:tempX2, y:tempY2, scaleX:0.5, scaleY:0.5, alpha:0, onComplete:onDisappearComplete }) );
				timeLine.restart();
				
				isDisappearing = true;
				giftInfoMc.visible = false;
			}
		}
		private function onDisappearComplete():void
		{
			isDisappearing = false;
			appearBubble();
		}
		
		private function appearBubble():void
		{
			isAppearing = true;
			refreshBubble();
			//光晕位置更新
			haloEffect.x = lightVect[data.currBubbleIdx-1].x;
			haloEffect.y = lightVect[data.currBubbleIdx-1].y;
			DisplayUtil.playMc(haloEffect);
			haloEffect.visible = true;
			
			var disObj:DisplayObject = bubbleProxy.content;
			var disObjX:Number = disObj.x;
			var disObjY:Number = disObj.y;
			
			disObj.scaleX = disObj.scaleY = 0.5;
			disObj.alpha = 0;
			disObj.x = disObjX + 11.2;
			disObj.y = disObjY + 30.5;
			
			var tempX1:Number = disObjX - 1.1;
			var tempY1:Number = disObjY - 5.5;
			var tempX2:Number = disObjX + 0.7;
			var tempY2:Number = disObjY + 1.5;
			
			timeLine.killTweensOf(disObj);
			timeLine.stop();
			timeLine.clear();
			timeLine.append( TweenLite.to(disObj, 3/24, {x:tempX1, y:tempY1, scaleX:1.05, scaleY:1.05, alpha:1}) );
			timeLine.append( TweenLite.to(disObj, 4/24, {x:tempX2, y:tempY2, scaleX:0.97, scaleY:0.97}) );
			timeLine.append( TweenLite.to(disObj, 1/24, {x:disObjX, y:disObjY, scaleX:1, scaleY:1, onComplete:onAppearComplete }) );
			timeLine.restart();
		}
		private function onAppearComplete():void
		{
			isAppearing = false;
			refreshBubble();
		}
		
		//----------------------------------------------
		// 事件响应
		//----------------------------------------------
		
		private function onMouseOverBubble(evt:MouseEvent):void
		{
			if(data == null)
				return;
			giftInfoMc.visible = true;
		}
		
		private function onMouseOutBubble(evt:MouseEvent):void
		{
			giftInfoMc.visible = false;
		}
		
		private function onMouseOverStartResponse(evt:MouseEvent):void
		{
			if (data.isPlaying == false)
			{
				//trace("---------------onMouseOverStartResponse:" + data.currRound);
				startMc.visible = true;
				startMc.gotoAndPlay("appear");
				
				startEffect1.visible = false;
				DisplayUtil.stopMc(startEffect1);
//				startEffect2.visible = false;
//				DisplayUtil.stopMc(startEffect2);
			}
		}
		
		private function onMouseOutStartResponse(evt:MouseEvent):void
		{
			startMc.visible = true;
			startMc.gotoAndPlay("disappear");
			
			if (data.isPlaying == false)
			{
				startEffect1.visible = true;
				DisplayUtil.playMc(startEffect1);
//				startEffect2.visible = true;
//				DisplayUtil.playMc(startEffect2);
			}
		}
		
		private function onCelebrateComplete(evt:Event):void
		{
			//trace("--------------------onCelebrateComplete");
			celebrateEffect.visible = false;
//			DisplayUtil.stopMc(celebrateEffect);
			//灯的颜色更新
			refreshLight();
		}
		
		private function onStartDisappearComplete(evt:Event):void
		{
			startMc.visible = false;
			if (data.isPlaying)
			{
				appearBubble();
			}
		}
		
		private function onClickBubble(evt:MouseEvent):void
		{
			SolitaireManager.instance.reqDoNext();
			//notifyFail();
		}	
		
		public function handleMouseOverOut(isOver:Boolean):void
		{
			if (data.isPlaying == false)
			{
				if (isOver)
				{
					startMc.visible = true;
					startMc.gotoAndPlay("appear");
					startEffect1.visible = startEffect2.visible = false;
					DisplayUtil.stopMc(startEffect1);
					DisplayUtil.stopMc(startEffect2);
				}
				else
				{
					startMc.visible = true;
					startMc.gotoAndPlay("disappear");
					startEffect1.visible = startEffect2.visible = true;
					DisplayUtil.playMc(startEffect1);
					DisplayUtil.playMc(startEffect2);
					//startEffect2.visible = false;
				}
			}
			else
			{
				if (isOver)
				{
					if (isDisappearing == false)
						giftInfoMc.visible = true;
					else
						giftInfoMc.visible = false;
//					if (timeLine.active == false)
//						giftInfoMc.visible = true;
//					else
//						giftInfoMc.visible = false;
				}
				else
				{
					giftInfoMc.visible = false;
				}
			}
		}
		
		
		//----------------------------------
		// 通知失败的提醒
		//----------------------------------
		
		private var _notifyTF:TextField;
		
		public function notifyFail():void
		{
			if (_notifyTF == null)
			{
				_notifyTF = new TextField();
				
				var tFormat:TextFormat = new TextFormat();
				tFormat.align = TextFormatAlign.LEFT;
				tFormat.size = 14;
				tFormat.color = 0xFFCC00;
				
				_notifyTF.defaultTextFormat = tFormat;
				_notifyTF.text = "接龙失败";
				_notifyTF.width = _notifyTF.textWidth + 3;
				_notifyTF.height = 30;
				
			}
			
			_notifyTF.x = lightVect[data.currBubbleIdx-1].x - _notifyTF.width/2;
			_notifyTF.y = lightVect[data.currBubbleIdx-1].y - 45;
			this.addChild(_notifyTF);
			TweenLite.killTweensOf(_notifyTF);
			TweenLite.to(_notifyTF, 2, {y:_notifyTF.y-60, onComplete:onNotifyFailComplete});
		}
		
		private function onNotifyFailComplete():void
		{
			if (_notifyTF && _notifyTF.parent)
			{
				_notifyTF.parent.removeChild(_notifyTF);
			}
		}
		
		//----------------------------------
		// 位置调整  根据屏幕宽度的不同调整间距
		//----------------------------------
		
		public function get showHeight():int
		{
			return 76;
		}
		
		public function setSpacing(value:Number):void
		{
			if (celebrateEffect == null)
				return;
			
			var len:int = lightVect.length;
			for (var i:int=0; i<len; ++i)
			{
				lightVect[i].x = 31 + i*value;
			}
			celebrateEffect.x = lightVect[0].x;
			celebrateEffect.y = lightVect[0].y;
			celebrateEffect.setSpacing(lightVect[1].x-lightVect[0].x);
			
			if (data)
			{
				bubbleProxy.setXY(lightVect[data.currBubbleIdx-1].x, lightVect[data.currBubbleIdx-1].y);
				haloEffect.x = lightVect[data.currBubbleIdx-1].x;
				haloEffect.y = lightVect[data.currBubbleIdx-1].y;
				
				giftInfoMc.x = lightVect[data.currBubbleIdx-1].x + 2.5;
				giftInfoMc.y = lightVect[data.currBubbleIdx-1].y - 54;
				//调整礼物版的位置
				if (giftInfoMc.x + giftInfoMc.width > GlobalConfig.stageWidth)
				{
					giftInfoMc.x = giftInfoMc.x - giftInfoMc.width - 20;
					(giftInfoMc["bgMc"] as MovieClip).scaleX = -1;
					(giftInfoMc["bgMc"] as MovieClip).x = (giftInfoMc["bgMc"] as MovieClip).width + 10;
				}
				else
				{
					(giftInfoMc["bgMc"] as MovieClip).scaleX = 1;
					(giftInfoMc["bgMc"] as MovieClip).x = 0;
				}
			}
		}
		
		
		
	}
}