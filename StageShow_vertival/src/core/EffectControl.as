package core
{
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import jgg.SimpleImgLoader;

	public class EffectControl extends EventDispatcher
	{
		private static var _instance:EffectControl;
		/**特效层*/
		private var _effLayer:Sprite;
		
		private var _uInfoLayer:Sprite;
		
		/**渲染列表*/
		private var _rendDic:Dictionary;
			
		private var _renderTime:Timer;
		
		private var _stage:Stage = null;
		
		public function EffectControl()
		{
			if(_instance != null)
			{
				throw(new Event("EffectControl 为单例  不可构造"));
				return;
			}
		}
		
		
		public function start(mainStage:Stage):void
		{
			
			_stage = mainStage;
			_effLayer     = new Sprite();
			_uInfoLayer = new Sprite();
			_stage.addChildAt(_effLayer, GlobalConfig.STAGE_LAYER_ENTER_E);
			_stage.addChildAt(_uInfoLayer, GlobalConfig.STAGE_LAYER_ENTER_U);
			
			GlobalConfig.enterEffectComplete = true;
			_rendDic = new Dictionary();
			_renderTime = new Timer(50);
			_renderTime.addEventListener(TimerEvent.TIMER,renderHandelr);
			_renderTime.start();
			scaleEffect(_stage.stageWidth);
			
		}
		
		/**
		 * 添加特效
		 */
		public function  addEffect(effInfo:Object):void
		{
			GlobalConfig.enterEffectComplete = false;
			
			var url:String = effInfo["url"];
			var index:int = url.lastIndexOf("/");
			var startUrl:String = url.substring(0,index+1);
			var swfName:String = url.substr(index+1,url.length);
			//加版本控制
			effInfo["url"] = startUrl+Config.getVersion(swfName);
			LoaderControl.instance.addToLoadList(effInfo);
		}
		
		
		/**
		 * 渲染检查
		 */
		private function renderHandelr(event:TimerEvent):void
		{
			
		    scaleEffect(_stage.stageWidth);
			
			//保证舞台上 同时只有一个特效在展示
			if(_effLayer.numChildren==0)
			{
				var iEffect:DisplayObject = LoaderControl.instance.getEffect();
				if(iEffect == null) return;
				iEffect["callback"] = childPlayComplete;
				var effDisObj:DisplayObject = iEffect as DisplayObject;
				_effLayer.addChild(effDisObj);
				//设置层的位置（最下面，同时要减去接龙的高度）
				var num:Number = _stage.stageWidth/BASE_WIDTH;
				_effLayer.y = _stage.stageHeight - num*BASE_HEIGHT  - 70;
				
				iEffect["play"]();
				_rendDic[iEffect["sign"]] = iEffect;
				
				if(iEffect["param"] != null) {
					_uInfoLayer.addChild(_uBar);
					_uBar.setUserInfo(iEffect["param"]);
					_uBar.x = _stage.stageWidth - _uBar.width;
					
					//_uBar.y = _effLayer.y+_effLayer.height -_uBar.height ;
					//_uBar.y = _uBar.y>180? _effLayer.y+180:_uBar.y;
					_uBar.y = _stage.stageHeight - (_uBar.height)*_stage.stageWidth/GlobalConfig.MAX_STAGE_WIDTH - 70;
				}
			}
		}
		
		
		private function scaleEffect(rWidth:int):void {
			if(_lastWidth != rWidth){
				var num:Number = rWidth/BASE_WIDTH;
				_effLayer.scaleX = _effLayer.scaleY = num;
				_uBar.x = rWidth - _uBar.width;
				
				//设置层的位置（最下面，同时要减去接龙的高度）
				_effLayer.y = _stage.stageHeight - num*BASE_HEIGHT - 90*_stage.stageWidth/GlobalConfig.MAX_STAGE_WIDTH;
				_uBar.y = _stage.stageHeight - (90+_uBar.height)*_stage.stageWidth/GlobalConfig.MAX_STAGE_WIDTH;
				
				_lastWidth = rWidth;
			}
		}
		
		/**
		 *子特效播放完毕  由child 回调此方法
		 */
		private function childPlayComplete(sign:Object):void
		{
			
			if(_uInfoLayer.contains(_uBar)){
				_uInfoLayer.removeChild(_uBar);
				_uBar.destroy();
			}
			
			var iEffect:DisplayObject = _rendDic[sign];
			delete _rendDic[sign];
			if(iEffect== null) return;
			var mc:DisplayObject = iEffect;
			if(_effLayer.contains(mc))
			{
				
				_effLayer.removeChild(mc);
				iEffect["destroy"]();
				mc.loaderInfo.loader.unloadAndStop(true);
				mc = null;
				
				//舞台无展示  则关闭DIV
				if(_effLayer.numChildren==0 && LoaderControl.instance.poolIsEmpty)
				{
					GlobalConfig.enterEffectComplete = true;
					GlobalConfig.foldDiv();
				}
				
			}
			
		}
		
		
		/**
		 * 获取实例
		 */
		public static function get instance():EffectControl
		{
			_instance = _instance==null? new EffectControl():_instance;
			return _instance;
		}
		
		
		
		private const BASE_WIDTH:int = 850;
		private const BASE_HEIGHT:int = 330;
		private var _lastWidth:int = 0;
		
		private var _uBar:UserInfoBar = new UserInfoBar();
		
		
		
		
	}
}