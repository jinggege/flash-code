package child.version_2015_9
{
	import core.Config;
	import core.IEffect;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import jgg.SimpleImgLoader;
	import jgg.YaHeiFormat;
	
	/**
	 * 进场动画   飞船   中秋活动
	 * 显示用户等级    名称(需限制长度)
	 * mc 播放完毕后 派发事件   this.dispatchEvent(new Event("E_CHILD_PLAY_COMPLETE"));
	 */
	[SWF(width="800", height="330", frameRate="24", backgroundColor="#000000")]
	public class EEShip20159V extends Sprite implements IEffect
	{
		private var _param:Object;
		/**回调*/
		private var _callback:Function;
		
		private var _instance:Skin_ship20154;
		/**唯一标识*/
		private var _sign:*;
		
		public function EEShip20159V()
		{
			super();
			_instance = new Skin_ship20154();
			addChild(_instance);
			_instance.x = 430;
			_instance.y = 170;
			_instance.info.visible = false;
			
			_instance.addEventListener(Config.E_CHILD_PLAY_COMPLETE,playCompleteHandler);
		}
		
		/**
		 * 参数
		 */
		public function set param(value:Object):void
		{
			_param = value;
			var uName:String = value["uName"];
			var uLevel:int = int(value["level"]);
			//showLevel(uLevel);
			
			var tfName:TextField = _instance.info.label;
			_instance.info.x -= 80;
			_instance.info.y += 70;
			tfName.text = uName;
			
			var tff:TextFormat = YaHeiFormat.getYaHeiFormat(14,0xFFFFFF,"center");
			tfName.setTextFormat(tff);
			tfName.defaultTextFormat = tff;
			
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
			_instance.info.addChild(img);
			var tfName:TextField = _instance.info.label;
			img.x = 10;
			img.y = tfName.y+(33 - img.height)/2 - 3;
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