package core
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import jgg.SimpleImgLoader;
	
	public class UserInfoBar extends Sprite
	{
		
		
		private const MAX_HEIGHT:int = 30;
		
		
		public function UserInfoBar( )
		{
			super();
			
			_tf.selectable = false;
			
			_tf.width = 300;
			_tf.height = 24;
			//_tf.border = true;
			//_tf.backgroundColor =0xffffff;
			_tf.y = 5;
			
			addChild(_tf);
		}
		
		
		
		public function setUserInfo(info:Object):void{
			var level:int = info["level"];
			var uName:String =  info["uName"];
			
			showLevel(level);
			
			_tf.htmlText = getHtmlStr(12,"#FFFFFF",uName);
			var w:int = Util.getTfWidth(_tf);
			
			_tf.width = w+20;
			
			this.graphics.clear();
			this.graphics.beginFill(0x574897, 0.8);
			this.graphics.drawRoundRect(0,0,_tf.width+70,MAX_HEIGHT,30,30);
			this.graphics.endFill();
		}
		
		
		
		
		
		
		private function getHtmlStr(fontSize:int,fontColor:String,label:String):String{
			var html:String = "<font size='"+fontSize +"'  color='"+fontColor+"'"+"face='微软雅黑,Microsoft YaHei,Arial'>";
			html +=label;
			html += "</font>";
			
			return html;
		}
		
		
		
		private function showLevel(level:int):void{
			var baseUrl:String = "http://static.youku.com/ddshow/img/laifeng/icon/level/uLevel_"
			var imgLoader:SimpleImgLoader = new SimpleImgLoader();
			imgLoader.getImg(baseUrl+level+".png",addLevelIcon);
			
		}
		
		private function addLevelIcon(data:Object):void
		{
			if(data == null) return;
			_img = data["content"];
			this.addChild(_img);
			
			_img.x = 10;
			_img.y = (MAX_HEIGHT - _img.height)/2;
			
			_tf.x = _img.x +_img.width+5;
		}
		
		
		
		public function destroy():void{
			if(_img != null){
				if(this.contains(_img)){
					removeChild(_img);
					_img = null;
				}
			}
			
			_tf.text = "";
		
		}
		
		
		
		private var _tf:TextField = new TextField();
		
		private var _img:DisplayObject = null;
		
		
		
	}
}