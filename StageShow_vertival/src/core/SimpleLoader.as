package core
{
	import flash.display.Loader;

	public class SimpleLoader extends Loader
	{
		/**自定义数据*/
		public var customData:Object;
		
		public function SimpleLoader()
		{
			super();
		}
		
		
		/**
		 * 销毁
		 */
		public function destroy():void
		{
			this.unloadAndStop(true);
		}
		
		
		
	}
}