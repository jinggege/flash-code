package core
{
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Util
	{
		
		
		
		/**
		 * 为文本付样式
		 */
		public static function setFormat(tf:TextField,format:TextFormat):void
		{
			tf.setTextFormat(format);
			tf.defaultTextFormat = format;
		}
		
		
		/**
		 * 获取真正YAHEI字体名称
		 */
		public static function get yaHeiName():String
		{
			var fontName:String ="";
			var _tff:TextFormat = new TextFormat("Microsoft YaHei",12);
			var testTf:TextField = new TextField();
			testTf.text = "H";
			testTf.defaultTextFormat = _tff;
			testTf.setTextFormat(_tff);
			
			if(testTf.textWidth==9 && testTf.textHeight==17)
			{
				fontName= "Microsoft YaHei";
			}else
			{
				fontName = "微软雅黑";
			}
			return fontName;
		}
		
		
		
		
		
		/**
		 * 获取TextField 真实的宽度
		 * @param tf :TextField
		 */
		public static function getTfWidth(tf:TextField):int{
			var str:String = tf.text;
			var rec:Rectangle;
			var w:int = 0;
			
			for(var i:int=0; i<str.length; i++){
				rec = tf.getCharBoundaries(i);
				w += rec.width;
				rec = null;
			}
			return w;
		}
		
		
		
		
	}
}