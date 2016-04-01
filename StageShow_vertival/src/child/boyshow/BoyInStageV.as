package child.boyshow
{
	import core.Config;
	import core.IEffect;
	import core.Util;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import jgg.SimpleImgLoader;
	
	/**
	 * 进场动画   男
	 * 显示用户等级    名称(需限制长度)
	 */
	public class BoyInStageV extends Sprite implements IEffect
	{
		private var _param:Object;
		/**回调*/
		private var _callback:Function;
		
		private var _instance:HostBoy;
		/**唯一标识*/
		private var _sign:*;
		
		public function BoyInStageV()
		{
			super();
			_instance = new HostBoy();
			addChild(_instance);
			_instance.y +=30;
			_instance.scaleX= _instance.scaleY = 0.8;
				
			_instance.addEventListener(Config.E_CHILD_PLAY_COMPLETE,playCompleteHandler);
		}
		
		/**
		 * 参数
		 */
		public function set param(value:Object):void
		{
			_param = value;
			
			//showLevel(uLevel);
			
			_sign = _param["url"]+getTimer()+Math.random();
		}
		
		public function get param():Object
		{
			return _param;
		}
		
		/**
		 * 唯一标识
		 */
		public function get sign():*
		{
			return _sign;
		}
		
		
		public function play():void
		{
			_instance.gotoAndPlay(2);
		}
		
		/**
		 * 设置回调函数
		 */
		public function set callback(value:Function):void
		{
			_callback = value;
		}
		
		/**
		 * 子特效播放完毕
		 */
		private function playCompleteHandler(event:Event):void
		{
			_callback.call(null,sign);
		}
		
		
		
		
		
		private function showLevel(level:int):void
		{
			if(level==0) return;
			var baseUrl:String = "http://static.youku.com/ddshow/img/laifeng/icon/level/uLevel_"
			var imgLoader:SimpleImgLoader = new SimpleImgLoader();
			imgLoader.getImg(baseUrl+level+".png",addLevelIcon);
		}
		
		private function addLevelIcon(data:Object):void
		{
			var img:DisplayObject = data["content"];
			this.addChild(img);
			
			img.x = _instance.uName.x - img.width - 70;
			img.y = _instance.uName.y - 28;
		}	
		
		
		
		
		
		
		
		
		
		
		
		public function destroy():void
		{
			_instance.removeEventListener(Config.E_CHILD_PLAY_COMPLETE,playCompleteHandler);
			_instance.stop();
			this.removeChild(_instance);
			_instance = null;
			_callback = null;
		}
		
		
		
		
	}
}