package core
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import jgg.SimpleImgLoader;
	import jgg.YaHeiFormat;

	public class BaseEffect extends Sprite implements IEffect
	{
		
		protected var _callback:Function;
		
		protected var _instance:MovieClip;
		
		protected var _param:Object;
		
		/**唯一标识*/
		protected var _sign:*;
		
		/**等级的图片*/		
		protected var levelImg:DisplayObject;
		
		public function BaseEffect()
		{
			init();
		}
		
		protected function init():void
		{
			_instance = new instanceClass();
			this.addChild(_instance);
			_instance.x = instanceX;
			_instance.y = instanceY;
			_instance.info.visible = false;
			_instance.addEventListener(Config.E_CHILD_PLAY_COMPLETE, playCompleteHandler);
		}
		
		public function play():void
		{
			_instance.gotoAndPlay(2);
		}
		
		protected function showLevel(level:int):void
		{
			if(level==0) return;
			var baseUrl:String = "http://static.youku.com/ddshow/img/laifeng/icon/level/uLevel_"
			var imgLoader:SimpleImgLoader = new SimpleImgLoader();
			imgLoader.getImg(baseUrl+level+".png",addLevelIcon);
		}
		
		protected function showName(name:String):void
		{
			var tfName:TextField = _instance.info.label;
			tfName.text = name;
			tfName.maxChars = 7;
			
			setNameStyle();
		}
		protected function setNameStyle():void
		{
			var tfName:TextField = _instance.info.label;
			var tff:TextFormat = YaHeiFormat.getYaHeiFormat(14,0xFFFFFF,"left");
			tfName.setTextFormat(tff);
			tfName.defaultTextFormat = tff;
		}
		
		protected function addLevelIcon(data:Object):void
		{
			levelImg = data["content"];
			_instance.info.addChild(levelImg);
			var tfName:TextField = _instance.info.label;
			levelImg.x = tfName.x - levelImg.width-5;
			levelImg.y = tfName.y+tfName.height/2 -levelImg.height/2+3;
		}
		
		/**
		 * 子特效播放完毕
		 */
		protected function playCompleteHandler(event:Event):void
		{
			_callback.call(null,sign);
		}
		
		public function destroy():void
		{
			_instance.removeEventListener(Config.E_CHILD_PLAY_COMPLETE,playCompleteHandler);
			_instance.stop();
			this.removeChild(_instance);
			_instance = null;
			_callback = null;
			_param = null;
		}
		
		//-----------------------------------------------------------
		// 以下是 读写器
		//-----------------------------------------------------------
		
		public function get param():Object
		{
			return _param;
		}
		
		public function set param(value:Object):void
		{
			_param = value;
			var uName:String = value["uName"];
			showName(uName);
			var uLevel:int = int(value["level"]);
			//showLevel(uLevel);
			
			_sign = _param["url"]+getTimer()+Math.random();
		}
		
		public function set callback(value:Function):void
		{
			_callback = value;
		}
		
		public function get sign():*
		{
			return _sign;
		}
		
		
		/**
		 * 主要显示对象在fla中的类
		 * 需要在子类中覆盖
		 */		
		public function get instanceClass():Class
		{
			return null;
		}
		
		public function get instanceX():Number
		{
			return 0;
		}
		
		public function get instanceY():Number
		{
			return 0;
		}
	}
}