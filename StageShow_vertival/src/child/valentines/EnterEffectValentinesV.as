package child.valentines
{
	import core.Config;
	import core.IEffect;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import jgg.YaHeiFormat;
	
	/**
	 * 进场动画   情人节
	 * 显示用户等级    名称(需限制长度)
	 * mc 播放完毕后 派发事件   this.dispatchEvent(new Event("E_CHILD_PLAY_COMPLETE"));
	 */
	[SWF(width="850", height="330", frameRate="24", backgroundColor="#000000")]
	public class EnterEffectValentinesV extends Sprite implements IEffect
	{
		private var _param:Object;
		/**回调*/
		private var _callback:Function;
		
		private var _instance:Skin_Valentines;
		/**唯一标识*/
		private var _sign:*;
		
		private var _nameContainer:DisplayObject;
		
		public function EnterEffectValentinesV()
		{
			super();
			_instance = new Skin_Valentines();
			addChild(_instance);
			_instance.x = 420;
			_instance.y = 170;
			
			_instance.addEventListener(Config.E_CHILD_PLAY_COMPLETE,playCompleteHandler);
		}
		
		/**
		 * 参数
		 */
		public function set param(value:Object):void
		{
			_param = value;
			
			
			_instance.NameContainer.visible = false;
			
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