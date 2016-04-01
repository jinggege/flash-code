package core
{
	/**
	 * 加载控制
	 */
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	public class LoaderControl extends EventDispatcher
	{
		/**正在加载中的数量*/
		public var inLoadingNum:int = 0;
		
		private static var _instance:LoaderControl;
		private var _urlList:Vector.<Object>;
		private var _effList:Vector.<DisplayObject>;
		
		private var _updataTime:Timer;
		
		public function LoaderControl()
		{
			if(_instance !=null)
			{
				throw(new Event("LoaderControl 为单例 不可构造"));
			}
		}
		
		
		public function start():void
		{
			_urlList = new Vector.<Object>();
			_effList = new Vector.<DisplayObject>();
			_updataTime = new Timer(100);
			_updataTime.addEventListener(TimerEvent.TIMER,updataHandler);
			_updataTime.start();
		}
		
		public function addToLoadList(info:Object):void
		{
			_urlList.push(info);
		}
		
		
		private function updataHandler(event:TimerEvent):void
		{
			if(_urlList.length ==0) return;
			if(_effList.length < 2)
			{
				startLoade(_urlList.shift());
			}
		}
		
		
		/**
		 * 开始加载
		 */
		private function startLoade(data:Object):void
		{
			inLoadingNum++;
			var sLoader:SimpleLoader = new SimpleLoader();
			sLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
			sLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			sLoader.customData = data;
			var url:String = data["url"]+"?index="+int(Math.random()*100);
			sLoader.load(new URLRequest(url));
		}
		
		
		/**
		 * 加载完成
		 */
		private function loadCompleteHandler(event:Event):void
		{
			inLoadingNum--;
			
			var sLoader:SimpleLoader = event.target.loader;
			var iEffect:DisplayObject = sLoader.content;
			iEffect["param"] = sLoader.customData;
			_effList.push(iEffect);
			
			sLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadCompleteHandler);
			sLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			sLoader.destroy();
		}
		
		
		/**
		 * 获取实例
		 */
		public function getEffect():DisplayObject
		{
			var iEffect:DisplayObject = _effList.length==0? null:_effList.shift();
			return iEffect;
		}
				
		
		/**
		 * 加载器是否空闲
		 */
		public function get poolIsEmpty():Boolean
		{
			if(_effList.length==0 && inLoadingNum<=0 && _urlList.length==0)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * IO 错误
		 */
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			trace("error=",event.text);
			inLoadingNum--;
		}
		
		
		public static function get instance():LoaderControl
		{
			_instance = _instance==null? new LoaderControl():_instance;
			return _instance;
		}
		
		
		
	}
}