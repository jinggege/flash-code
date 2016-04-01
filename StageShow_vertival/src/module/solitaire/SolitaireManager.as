package module.solitaire
{
	import core.GlobalConfig;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	
	/**
	 * 接龙管理器
	 * @author jiangquannian
	 * 
	 */	
	public class SolitaireManager
	{
		
		private static var _instance:SolitaireManager;
		
		private var ui:SolitaireUI;
		private var data:SolitaireInfo;
		
		private var isLoadingRes:Boolean = false;
		private var resUrl:String;
		
		public function SolitaireManager()
		{
			if (_instance != null)
			{
				throw(new Event("SolitaireManager 为单例，不可构造"));
			}
		}
		
		public static function get instance():SolitaireManager
		{
			if (_instance == null)
				_instance = new SolitaireManager();
			return _instance;
		}
		
		/**
		 * 启动管理器
		 */
		public function start(mainStage:Stage, solitaireLayer:Sprite):void
		{
			data = new SolitaireInfo();
			//把ui加到舞台的层里
			//solitaireLayer.mouseEnabled = solitaireLayer.mouseChildren = false;
			ui = new SolitaireUI();
			solitaireLayer.addChild(ui);
			
//			ui.x = 0;
//			ui.y = 600;
			
			var url:String = mainStage.loaderInfo.loaderURL;
			resUrl = url.substring(0, url.lastIndexOf("/")) + "/SolitaireV.swf";
			loadSolitaireRes();//开始的时候便加载swf
		}
		
		
		/**
		 * 加载接龙的资源
		 */		
		public function loadSolitaireRes():void
		{
			if (isLoadingRes)
				return;
			var sLoader:Loader = new Loader();
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			sLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
			sLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			sLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityError);
//			var urlReq:URLRequest  = new URLRequest("component/solitaire/res/Solitaire.swf");
			var urlReq:URLRequest  = new URLRequest(resUrl);
			sLoader.load(urlReq, context);
			isLoadingRes = true;
			
		}
		/**
		 * 加载完成
		 */
		private function loadCompleteHandler(event:Event):void
		{
			var sLoader:Loader = (event.target as LoaderInfo).loader as Loader;
			if (sLoader.contentLoaderInfo.url != resUrl)
				return;
			
			data.isReady = true;
			
			var mc:MovieClip = sLoader.content as MovieClip;
			ui.initView(mc["mainMc"]);
			
			resizeUI();
			
			//ui.graphics.beginFill(0xff0000,0.5);
			//ui.graphics.drawRect(0,0,ui.width,ui.height);
			//ui.graphics.endFill();
			
			var bmdClass:Class = getDefinitionByName("NumberBitMapData") as Class;
			ui.initTotalSpt(new bmdClass() as BitmapData);
			ui.refresh(data);
			
			sLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadCompleteHandler);
			sLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			sLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityError);
			sLoader.unload();
			sLoader = null;
			
			//data.isReady = true;
			//reqDoNext();
		}
		/**
		 * 流错误
		 */
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			//LogManage.instance.log("LoadManage",event.text,LogManage.LOG_TYPE_TO_SERVER);
			trace("[ioError]"+event.text);
		}
		/**
		 * 安全沙箱错误
		 */		
		private function securityError(event:SecurityErrorEvent):void
		{
			//LogManage.instance.log("LoadManage","安全沙箱错误"+event.text,LogManage.LOG_TYPE_TO_SERVER);
			trace("[安全沙箱错误]");
		}
		
		/**
		 * 更新接龙的数据和显示
		 * @param param
		 * 
		 */		
		public function update(param:Object):void
		{
			if (param == null)
				return;
			data.currRound = param.round;
			data.currLightIdx = param.lightIdx;
			data.lastBubbleIdx = data.currBubbleIdx;
			data.currBubbleIdx = param.bubbleIdx;
			data.bubblePercent = param.bubblePercent;
			data.currTotal = param.curTotal;
			data.bubbleColor = param.bubbleColor;
			data.countdown = param.countdown;
			data.giftImg = param.giftImg;
			data.giftNum = param.giftNum;
			data.isAnchor = param.isAnchor;
			
			data.isReady = true;
			
//			trace("..................currRound:" + data.currRound);
//			trace("..................currLightIdx:" + data.currLightIdx);
//			trace("..................bubblePercent:" + data.bubblePercent);
//			trace("..................currTotal:" + data.currTotal);
//			trace("..................giftNum:" + data.giftNum);
//			trace("..................lastBubbleIdx:" + data.lastBubbleIdx);
//			trace("..................currBubbleIdx:" + data.currBubbleIdx);
			
			if (ui.hasContent() == false)
			{
				loadSolitaireRes();
			}
			else
			{
				
				ui.refresh(data);
			}
		}
		
		public function notifyFail():void
		{
			ui.notifyFail();
		}
		
		public function handleUIMouseOverOut(isShow:Boolean):void
		{
			if (ui.hasContent() == false)
				return;
			ui.handleMouseOverOut(isShow);
		}
		
		private var lastReqTime:int=0;
		/**
		 * 请求接龙（通过JS想服务端请求）
		 */		
		public function reqDoNext():void
		{
			var now:int = getTimer();
			if (now -lastReqTime > 100)
			{
				ExternalInterface.call("_flash_link_click");
				lastReqTime = now;
			}
			
//			//测试
//			var tParam:Object = new Object();
//			
//			tParam.countdown = 15;
//			tParam.curTotal = data.currTotal+1;
//			tParam.round = SolitaireConst.getCurrRound(tParam.curTotal);
//			var lightObj:Object = SolitaireConst.getCurrLightInfo(tParam.curTotal);
//			tParam.lightIdx = lightObj.lightIndex;
//			tParam.bubbleIdx = (tParam.lightIdx + 1 > SolitaireConst.LIGHT_COUNT) ? 1 : tParam.lightIdx + 1;
//			tParam.bubblePercent = lightObj.lightPercent;
//			//trace("-------------------curTotal:", tParam.curTotal, ",lightIdx:",tParam.lightIdx,
//			//	",bubbleIdx:",tParam.bubbleIdx, ",bubblePercent:", tParam.bubblePercent );
//			tParam.bubbleColor = 1;
//			tParam.giftImg = "colorrose_24_24.png"; 
//			tParam.giftNum = 5;
//			
//			update(tParam);
		}
		
		public function resizeUI():void
		{
			if (ui.hasContent() == false)
				return;
			
//			if (GlobalConfig.stageWidth/GlobalConfig.MAX_STAGE_WIDTH <= 1)
//				ui.scaleX = ui.scaleY = GlobalConfig.stageWidth/GlobalConfig.MAX_STAGE_WIDTH;
			
			//ui.setSpacing(GlobalConfig.stageWidth/GlobalConfig.MAX_STAGE_WIDTH*472/(SolitaireConst.LIGHT_COUNT-1));
			
//			var //503  31
			
			ui.setSpacing((GlobalConfig.stageWidth/GlobalConfig.MAX_STAGE_WIDTH*540 - 62)/(SolitaireConst.LIGHT_COUNT-1));
			
			ui.x = 0;
			ui.y = GlobalConfig.stageHeight - ui.showHeight*ui.scaleY;
		}
		
	}
}