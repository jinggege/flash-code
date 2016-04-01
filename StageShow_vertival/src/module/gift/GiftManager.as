package module.gift
{
	import core.GlobalConfig;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class GiftManager
	{
		private static var _instance:GiftManager;
		
		private var ui:GiftUI;
		
		private var isLoadingRes:Boolean = false;
		private var resUrl:String;
		
		public function GiftManager()
		{
		}
		
		public static function get instance():GiftManager
		{
			if (_instance == null)
				_instance = new GiftManager();
			return _instance;
		}
		
		/**
		 * 启动管理器
		 */
		public function start(mainStage:Stage, giftLayer:Sprite):void
		{
			//把ui加到舞台的层里
			ui = new GiftUI();
			giftLayer.addChild(ui);
			resizeUI();
			//ui.x = 750;
			//ui.y = 700;
			
//			var url:String = mainStage.loaderInfo.loaderURL;
//			resUrl = url.substring(0, url.lastIndexOf("/")) + "/FloatGift.swf";
//			loadRes();//开始的时候便加载swf
		}
		
		
		/**
		 * 加载资源
		 */		
		public function loadRes():void
		{
			if (isLoadingRes)
				return;
			var sLoader:Loader = new Loader();
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			sLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
			sLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			sLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityError);
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
			
			var mc:MovieClip = sLoader.content as MovieClip;
			ui.initView(mc["mainMc"]);
			resizeUI();
			//ui.refresh(data);
			
			sLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadCompleteHandler);
			sLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			sLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityError);
			sLoader.unload();
			sLoader = null;
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
		
		
		private var gDataId:int = 0;
		/**
		 * 更新数据和显示
		 * @param param
		 * 
		 */		
		public function update(param:Object):void
		{
			if (param == null)
				return;
			
			var data:GiftInfo = new GiftInfo();
			data.id = ++gDataId;
			data.imgUrl = param.imgUrl80;
			data.num = int(param.count);
			
			ui.visible = true;
			if (ui.hasContent() == false)
			{
				loadRes();
			}
			else
			{
				ui.refresh(data);
			}
		}
		
		public function resizeUI():void
		{
			if (GlobalConfig.stageWidth/GlobalConfig.MAX_STAGE_WIDTH <= 1)
				ui.scaleX = ui.scaleY = GlobalConfig.stageWidth/GlobalConfig.MAX_STAGE_WIDTH;
			
			ui.x = GlobalConfig.stageWidth -  (ui.showWidth)*ui.scaleX;
			ui.y = GlobalConfig.stageHeight  - (ui.showHeight)*ui.scaleY - 80;
		}
		
		
		public function hideUI():void
		{
			ui.visible = false;
		}
		
	}
}