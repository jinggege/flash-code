package module.solitaire
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class NumberSprite extends Sprite
	{
		/**所有数字组成的一个位图数据*/
		private var bmdVect:Vector.<BitmapData>;
		
		//为了解决字间距的问题，把每个数字的宽度记录于此
		private const BMD_W:Array = [21.45,21.45,17.1,21.65,21.6,22.9,22.15,21.25,21.45,21.15,21.25];
		
		public function NumberSprite()
		{
			super();
			bmdVect = new Vector.<BitmapData>();
		}
		
		/**
		 * 设置位图数据，位图数据：+0123456789
		 * @param sourceBitmapData
		 * @param column
		 * 
		 */		
		public function setBitmapData(sourceBitmapData:BitmapData,column:uint = 11):void
		{
			bmdVect.splice(0, bmdVect.length);
			var imgWidth:Number = sourceBitmapData.width/column;  
			var imgHeight:Number = sourceBitmapData.height; 
			for (var i:int=0; i<column; ++i)
			{
				var bmd:BitmapData = new BitmapData(imgWidth, imgHeight);
				bmd.copyPixels(sourceBitmapData, new Rectangle(i*imgWidth, 0, imgWidth, imgHeight),new Point(0,0)); 
				bmdVect.push(bmd); 
			}
		}
		
		
		
		public function showNumber(n:int):void
		{
			clearNumber();
			if ( n <=0 )
				return;
			
			var arr:Array = new Array();//数组里存每个位的值，从低位到高位(个位，十位，百位...)
			var tmp:int = n;
			while(tmp > 0)
			{
				arr.push(tmp%10);
				tmp = tmp/10;
			}
			
			//先把加号加进去
			var bm:Bitmap = new Bitmap();
			bm.bitmapData = bmdVect[0];
			bm.x = bm.y = 0;
			this.addChild(bm);
			var tmpX:Number = BMD_W[0];
			//再加数字
			var len:int = arr.length;
			for (var i:int=len-1; i>=0; --i)
			{
				bm = new Bitmap();
				bm.bitmapData = bmdVect[arr[i]+1];
				bm.x = tmpX;
				tmpX += BMD_W[arr[i]+1];
				bm.y = 0;
				this.addChild(bm);
			}
		}
		
		public function clearNumber():void
		{
			while(this.numChildren > 0)
			{
				var bm:Bitmap = this.getChildAt(0) as Bitmap;
				if (bm) 	bm.bitmapData = null;
				this.removeChildAt(0);
			}
		}
		
	}
}