package module.solitaire
{
	import flash.display.MovieClip;

	/**
	 * 灯显示的 代理类（并不是一个显示对象DisplayObject）
	 * @author jiangquannian
	 * 
	 */	
	public class LightProxy
	{
		
		private var light:MovieClip;
		
		/**灯，灯灯灯灯*/
		private var lightLamp:MovieClip;
		/**灯光*/
		private var lightRay:MovieClip;
		
		/**当前的灯颜色*/
		private var lampColor:int = -1;
		/**当前的光颜色*/
		private var rayColor:int = -1;
		
		public function LightProxy(mc:MovieClip)
		{
			light = mc;
			lightLamp = light.lamp;
			lightRay = light.ray;
			
			lightLamp.gotoAndStop(1);
			lightRay.gotoAndStop(1);
		}
		
		/**
		 * 设置灯的颜色，值为0时不显示
		 * @param color
		 * 
		 */		
		public function setLampColor(color:uint):void
		{
			if (color == lampColor)
				return;
			lampColor = color;
				
			if (color > 0)
			{
				lightLamp.gotoAndStop(color+1);
			}
			else
			{
				lightLamp.gotoAndStop(1);
			}
		}
		
		/**
		 * 设置光的颜色，值为0时不显示
		 * @param color
		 * 
		 */		
		public function setRayColor(color:uint):void
		{
			if (color == rayColor)
				return;
			rayColor = color;
			
			if (rayColor <= 0)
			{
				lightRay.visible = false;
				lightRay.gotoAndStop(1);
				lightRay.stop();
				return;
			}
			
			SolitaireConst.setDisObjColor(lightRay, rayColor);
			lightRay.visible = true;
			lightRay.gotoAndPlay(1);
		}
		
		public function set visible(value:Boolean):void
		{
			lightRay.visible = value;
			lightLamp.visible = value;
		}
		
		public function get x():Number
		{
			return light.x;
		}
		
		public function set x(value:Number):void
		{
			light.x = value;
		}
		
		public function get y():Number
		{
			return light.y;
		}
		
	}
}