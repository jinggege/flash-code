package module.gift
{
	import com.greensock.TweenLite;
	
	import core.GlobalConfig;
	import core.GrayUtil;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	public class GiftUI extends Sprite
	{
		
		//---------显示-----------
//		private var mainMc:MovieClip;
		//private var container:Sprite;	
		
		private var circleBg:Shape;
		private var grayBm:Bitmap;
		
		//---------数据-----------
		private var dataArr:Array;
		
		private var flyingDataArr:Array;
		
		private var isStarted:Boolean;
		private var isPlaying:Boolean;
		
		/**加载的图片字典，用于缓存不再下载*/
		private var imgDict:Dictionary;
		
		/**GiftImg的缓存池，用于节省内存*/
		private var imgPool:Array;
		
		public function GiftUI()
		{
			super();
			
			dataArr = new Array();
			isPlaying = false;
			
			imgDict = new Dictionary();
//			playImgs = new Array();
			
			imgPool = new Array();
			
			flyingDataArr = new Array();
			
			initView();
		}
		
		public function initView(mc:MovieClip=null):void
		{
//			mainMc = mc;
//			DisplayUtil.stopMc(mainMc);
//			this.addChild(mainMc);
			
			//画背景小圆圈
			circleBg = new Shape();
			circleBg.graphics.beginFill(0xA5A5A5,0.3);
			circleBg.graphics.drawCircle(0,0,20);
			circleBg.graphics.endFill();
			this.addChild(circleBg);
			circleBg.x = 0;
			circleBg.y = -0;
			
			grayBm = new Bitmap();
			this.addChild(grayBm);
			GrayUtil.setGray(grayBm);

			circleBg.visible = grayBm.visible = false;
			
			GlobalConfig.giftEffectComplete = true;
//			container = new Sprite();
//			this.addChild(container);
//			container.x = 0;
//			container.y = 0;
		}
		
		
		public function refresh(info:GiftInfo):void
		{
			if (info == null )
			{
				this.visible = false;
				return;
			}
			dataArr.push(info);
			
			start();
		}
		
		private function start():void
		{
			if (dataArr.length <=0)
			{
				return;
			}
			
			GlobalConfig.giftEffectComplete = false;
			
			if (isStarted)
				return;
			
			var data:GiftInfo = dataArr.shift();
			flyingDataArr.push(data);
			isStarted = true;
			
			this.alpha = 1;
			this.visible = true;
			//TweenLite.killTweensOf(this);
			
			if (imgDict[data.imgUrl])
			{
				play(data);
			}
			else
			{
				loadImg(data);
			}
		}
		
		private function loadImg(data:GiftInfo):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImgLoaded);
			loader.load(new URLRequest(data.imgUrl));
			
			function onImgLoaded(evt:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImgLoaded);
				var bm:Bitmap = new Bitmap( (loader.content as Bitmap).bitmapData.clone() );
				imgDict[data.imgUrl] = bm;
				
				loader.unload();
				loader = null;
				
				play(data);
			}
		}
		
		
		private var testNewImgNum:int=0;
		private function play(data:GiftInfo):void
		{
			if (isPlaying)
				return;
			
			isPlaying = true;
			data.flyCount = getFlyCount(data.num);
			
//			var bm:Bitmap = imgDict[data.imgUrl];
//			circleBg.visible = grayBm.visible = true;
//			grayBm.bitmapData = bm.bitmapData.clone();
//			grayBm.width = grayBm.height = 40;
//			grayBm.smoothing = true;
//			grayBm.x = circleBg.x - grayBm.width/2;
//			grayBm.y = circleBg.y - grayBm.height/2;
			
			flyOne(data);
		}
		
		private function getFlyCount(realNum:int):int
		{
			if (realNum > 15)
				return 15;
			return realNum;
		}
		
		/**
		 * 飘一个图
		 */		
		private function flyOne(data:GiftInfo):void
		{
			if (data.flyStartNum < data.flyCount)
			{
				data.flyStartNum++;
				
				var bm:Bitmap = imgDict[data.imgUrl];
				var img:GiftImage;
				if (imgPool.length > 0)
				{
					img = imgPool.pop();
					img.setBm(bm, data.id);
				}
				else
				{
					img = new GiftImage(bm, data.id);
					//trace("-------------------------------new GiftImage" +  ++testNewImgNum );
				}
				
				this.addChild(img);
				img.x = circleBg.x;
				img.y = circleBg.y;
				img.play();
				img.addEventListener(Event.COMPLETE, onOneFlyComplete);
				
				
//				if (data.flyCount < 10)
//				{
//					TweenLite.delayedCall((6+Math.random()*4)/24, flyOne, [data]);
//				}
//				else if (data.flyCount < 30)
//				{
//					TweenLite.delayedCall((5+Math.random()*3)/24, flyOne, [data] );
//				}
//				else if (data.flyCount < 50)
//				{
//					TweenLite.delayedCall((4+Math.random()*2)/24, flyOne, [data]);
//				}
//				else
//				{
//					TweenLite.delayedCall((3+Math.random()*1)/24, flyOne, [data]);
//				}
				TweenLite.delayedCall((3+Math.random()*1)/24, flyOne, [data]);
			}
			else
			{
				playNext()
				//TweenLite.delayedCall(0.5, playNext);
			}
		}
		
		private function playNext():void
		{
			isStarted = false;
			isPlaying = false;
			if (grayBm.bitmapData)
			{
				grayBm.bitmapData.dispose();
				grayBm.bitmapData = null;
			}
			circleBg.visible = grayBm.visible = false;
			start();
		}
		
		private function onOneFlyComplete(evt:Event):void
		{
			var img:GiftImage = evt.target as GiftImage;
			removeOneImg(img);
			
			var data:GiftInfo = getDataById(img.gId);
			if (data)
			{
				++(data.flyEndNum);
				if (data.flyEndNum >= data.flyCount)
				{
					var idx:int = flyingDataArr.indexOf(data);
					if (idx != -1)
						flyingDataArr.splice(idx,1);
					
					//如果全部播放完了则 关闭DIV
					if (dataArr.length <=0 && flyingDataArr.length <=0)
					{
						GlobalConfig.giftEffectComplete = true;
						GlobalConfig.foldDiv();
					}
				}
			}
		}
		
		private function getDataById(id:int):GiftInfo
		{
			for each (var data:GiftInfo in flyingDataArr)
			{
				if (data.id == id)
				{
					return data;
				}
			}
			return null;
		}
		
		private function removeOneImg(img:GiftImage):void
		{
			if (img == null)
				return;
			img.stop();
			if (img.parent)
			{
				img.parent.removeChild(img);
			}
			imgPool.push(img);
		}
		
		public function hasContent():Boolean
		{
			return true;
			//return mainMc != null;
		}
		
		public function get showWidth():int
		{
			return circleBg.width;
		}
		
		public function get showHeight():int
		{
			return circleBg.height;
		}
		
		
	}
}