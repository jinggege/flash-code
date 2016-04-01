package core
{
	/**
	 * 特效接口
	 */
	public interface IEffect
	{
		function set param(value:Object):void;
		function get param():Object;
		function play():void;
		/**回调*/
		function set callback(value:Function):void;
		/**唯一标识*/
		function get sign():*;
		function destroy():void;
		
	}
}