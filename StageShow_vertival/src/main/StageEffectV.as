package main
{
	
	/**
	 * 入场动画展示
	 * 舞台上所展示的动画唯一
	 * 
	 * 竖屏 版本
	 * 
	 * 
	 */
	import core.Config;
	import core.EffectControl;
	import core.GlobalConfig;
	import core.LoaderControl;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	
	import module.gift.GiftManager;
	import module.solitaire.SolitaireManager;
	
	//[SWF(width="850", height="330", frameRate="24", backgroundColor="#000000")]
	public class StageEffectV extends Sprite
	{
		
		/**
		 * 入场动画展示控制
		 */
		public function StageEffectV()
		{
			super();
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			stage.scaleMode =  StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			var param:Object      = this.loaderInfo.parameters;
			Config.jsFunctionName = param["callback"];
			
			var roomType:int =  param["roomType"] ==null? 0:int(param["roomType"] );
			
			//飘礼物
			var giftLayer:Sprite = new Sprite();
			this.stage.addChildAt(giftLayer, GlobalConfig.STAGE_LAYER_GIFT);
			GiftManager.instance.start(this.stage, giftLayer);
			
			//进场特效
			LoaderControl.instance.start();
			EffectControl.instance.start(stage);
			
			//接龙
			var solitaireLayer:Sprite = new Sprite();
			this.stage.addChildAt(solitaireLayer, GlobalConfig.STAGE_LAYER_SOLITAIRE);
			SolitaireManager.instance.start(this.stage, solitaireLayer);
			
			//进场特效
			ExternalInterface.addCallback("_flashInStageEffect",_flashInStageEffect);
			//送礼物
			ExternalInterface.addCallback("sendGift",sendGift);
			//接龙
			ExternalInterface.addCallback("jsCallSolitaire",jsCallSolitaire);
			ExternalInterface.addCallback("jsCallSolitaireFail",jsCallSolitaireFail);
			
			//ExternalInterface.call("console.log","v_0.001");
			//	testData();
			//testLine();
			
			this.stage.addEventListener(Event.RESIZE, onStageResize);
			this.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		
		private function onStageResize(evt:Event):void
		{
			if (GlobalConfig.stageWidth != stage.stageWidth || GlobalConfig.stageHeight != stage.stageHeight)
			{
				//trace("----------------------------onStageResize");
				//trace("stageWidth::"+stage.stageWidth);
				//trace("stageHeight::"+stage.stageHeight);
				
				GlobalConfig.stageWidth = stage.stageWidth;
				GlobalConfig.stageHeight = stage.stageHeight;
				resizeUI();
			}
		}
		
		private function onEnterFrame(evt:Event):void
		{
			onStageResize(null);
		}
		
		/**
		 * 此方法由JS 调用  传值给AS  
		 * @param {type:入场动画类型  uName:用户名称  level:等级  author:(0/1  0普通用户 1：主播),describe:描述}
		 */
		public function _flashInStageEffect(param:Object):void
		{
			EffectControl.instance.addEffect(param);
		}
		
		/**
		 * 测试入口
		 */
		private function testData():void
		{
			
			var basePath:String = "child/swf"
			
			this.graphics.beginFill(0x000000);
			//this.graphics.drawRect(0,0,850,330);
			this.graphics.endFill();
			
			var config:Array = [];
			config.push({id:0,url:basePath+"/GirlInStage.swf",level:60,uName:"胖子胖子胖子胖"});
			config.push({id:1,url:basePath+"/BoyInStage.swf",level:2,uName:"胖子胖子胖"});
			config.push({id:2,url:basePath+"/StageHorse.swf",level:1,uName:"木马木马木马"});
			config.push({id:3,url:basePath+"/StageSkateboard.swf",level:29,uName:"滑板滑板滑板胖"});
			config.push({id:4,url:basePath+"/StageSuperman.swf",level:20,uName:"超人超人超人胖"});
			config.push({id:5,url:basePath+"/StageAirship.swf",level:20,uName:"飞船飞船飞船胖"});
			config.push({id:6,url:basePath+"/StageFlyrug.swf",level:20,uName:"飞毯飞毯飞毯胖"});
			
			config.push({id:7,url:basePath+"/EnterEffectCar1.swf",level:20,uName:"汽车1"});
			config.push({id:8,url:basePath+"/EnterEffectCar2.swf",level:20,uName:"汽车1"});
			config.push({id:9,url:basePath+"/EnterEffectCar3.swf",level:20,uName:"汽车1"});
			config.push({id:10,url:basePath+"/EnterEffectCar4.swf",level:20,uName:"汽车1"});
			config.push({id:11,url:basePath+"/EnterEffectCar5.swf",level:20,uName:"汽车1"});
			config.push({id:12,url:basePath+"/EnterEffectCar6.swf",level:20,uName:"汽车1"});
			
			config.push({id:13,url:basePath+"/EnterEffectChristmas1.swf",level:20,uName:"圣诞节1"});
			config.push({id:14,url:basePath+"/EnterEffectChristmas2.swf",level:20,uName:"圣诞节2"});
			
			config.push({id:15,url:basePath+"/EnterEffectValentines.swf",level:20,uName:"情人节",aName:"主播主播主播主"});
			
			config.push({id:16,url:basePath+"/EEDeer1.swf",level:20,uName:"2015清明节1"});
			config.push({id:17,url:basePath+"/EEDeer2.swf",level:19,uName:"2015清明节2"});
			
			config.push({id:18,url:basePath+"/EEBird.swf",level:19,uName:"飞鸟飞鸟飞鸟飞鸟飞鸟"});
			config.push({id:19,url:basePath+"/EEShip20154.swf",level:19,uName:"飞船20154"});
			config.push({id:20,url:basePath+"/EEDragonBoat.swf",level:19,uName:"端午龙舟龙舟龙"});
			
			config.push({id:21,url:basePath+"/StageShHeight.swf",level:19,uName:"守护--高级"});
			config.push({id:22,url:basePath+"/StageShLow.swf",level:19,uName:"守护--低级级"});
			
			config.push({id:23,url:basePath+"/EEFinalWeapon.swf",level:19,uName:"极限武器"});
			
			config.push({id:24,url:basePath+"/EECrazySkiing.swf",level:19,uName:"疯狂滑雪"});
			
			for(var i:int=0; i<2; i++)
			{
				
				
//			 EffectControl.instance.addEffect(config[0]);
//				EffectControl.instance.addEffect(config[1]);
//				EffectControl.instance.addEffect(config[2]);
//				EffectControl.instance.addEffect(config[3]);
				EffectControl.instance.addEffect(config[4]); 
//			   EffectControl.instance.addEffect(config[5]);
//				EffectControl.instance.addEffect(config[6]);
//				
//				EffectControl.instance.addEffect(config[7]);
//				EffectControl.instance.addEffect(config[8]);
//				EffectControl.instance.addEffect(config[9]);
//				EffectControl.instance.addEffect(config[10]);
//				EffectControl.instance.addEffect(config[11]);
//				EffectControl.instance.addEffect(config[12]);
				
//				EffectControl.instance.addEffect(config[13]);
//				EffectControl.instance.addEffect(config[14]);
//				EffectControl.instance.addEffect(config[15]);
				
//			   EffectControl.instance.addEffect(config[16]);
//				EffectControl.instance.addEffect(config[18]);
//				EffectControl.instance.addEffect(config[19]);
//				EffectControl.instance.addEffect(config[20]);
//				
//				EffectControl.instance.addEffect(config[21]);
//				EffectControl.instance.addEffect(config[22]);
//				
//				EffectControl.instance.addEffect(config[23]);
//				EffectControl.instance.addEffect(config[24]);
			}
			
		}
		
		
		private function testLine():void
		{
			
			this.graphics.beginFill(0x000000);
			//this.graphics.drawRect(0,0,850,330);
			this.graphics.endFill();
			
			var config:Array = [];
			
			config.push({id:0,url:"http://static.youku.com/ddshow/img/flash/StageAirship.swf",level:20,uName:"飞船飞船飞船胖"});
			config.push({id:1,url:"http://static.youku.com/ddshow/img/flash/BoyInStageV.swf",level:2,uName:"胖子胖子胖子胖"});
			
			config.push({id:2,url:"http://static.youku.com/ddshow/img/flash/EnterEffectChristmas1.swf",level:20,uName:"圣诞节1"});
			config.push({id:3,url:"http://static.youku.com/ddshow/img/flash/EnterEffectChristmas2.swf",level:20,uName:"圣诞节2"});
			config.push({id:4,url:"http://static.youku.com/ddshow/img/flash/EECrazySkiing.swf",level:19,uName:"疯狂滑雪"});
			config.push({id:5,url:"http://static.youku.com/ddshow/img/flash/EEDragonBoat.swf",level:19,uName:"端午龙舟龙舟龙"});
			config.push({id:6,url:"http://static.youku.com/ddshow/img/flash/EEFinalWeapon.swf",level:19,uName:"极限武器"});
			config.push({id:7,url:"http://static.youku.com/ddshow/img/flash/StageFlyrug.swf",level:20,uName:"飞毯飞毯飞毯胖"});
			config.push({id:8,url:"http://static.youku.com/ddshow/img/flash/GirlInStage_01.swf",level:1,uName:"胖子胖子胖子胖"});
			config.push({id:9,url:"http://static.youku.com/ddshow/img/flash/StageHorse.swf",level:1,uName:"木马木马木马"});
			
			config.push({id:10,url:"http://static.youku.com/ddshow/img/flash/EnterEffectCar1.swf",level:20,uName:"汽车1"});
			config.push({id:11,url:"http://static.youku.com/ddshow/img/flash/EnterEffectCar2.swf",level:20,uName:"汽车1"});
			config.push({id:12,url:"http://static.youku.com/ddshow/img/flash/EnterEffectCar3.swf",level:20,uName:"汽车1"});
			config.push({id:13,url:"http://static.youku.com/ddshow/img/flash/EnterEffectCar4.swf",level:20,uName:"汽车1"});
			config.push({id:14,url:"http://static.youku.com/ddshow/img/flash/EnterEffectCar5.swf",level:20,uName:"汽车1"});
			config.push({id:15,url:"http://static.youku.com/ddshow/img/flash/EnterEffectCar6.swf",level:20,uName:"汽车1"});
			
			config.push({id:16,url:"http://static.youku.com/ddshow/img/flash/StageShHeight.swf",level:19,uName:"守护--高级"});
			config.push({id:17,url:"http://static.youku.com/ddshow/img/flash/StageShLow.swf",level:19,uName:"守护--低级级"});
			config.push({id:18,url:"http://static.youku.com/ddshow/img/flash/StageSkateboard.swf",level:29,uName:"滑板滑板滑板胖"});
			config.push({id:19,url:"http://static.youku.com/ddshow/img/flash/StageSuperman.swf",level:20,uName:"超人超人超人胖"});
			config.push({id:20,url:"http://static.youku.com/ddshow/img/flash/EnterEffectValentines.swf",level:20,uName:"情人节",aName:"主播主播主播主"});
			config.push({id:21,url:"http://static.youku.com/ddshow/img/flash/EEBird.swf",level:19,uName:"飞鸟飞鸟飞鸟飞鸟飞鸟"});
			config.push({id:22,url:"http://static.youku.com/ddshow/img/flash/EEDeer1.swf",level:20,uName:"2015清明节1"});
			config.push({id:23,url:"http://static.youku.com/ddshow/img/flash/EEDeer2.swf",level:19,uName:"2015清明节2"});
			config.push({id:24,url:"http://static.youku.com/ddshow/img/flash/EEShip20154.swf",level:19,uName:"飞船20154"});
			config.push({id:25,url:"http://static.youku.com/ddshow/img/flash/EEShip20159.swf",level:19,uName:"飞船20154"});
			
			
			for(var i:int=0; i<26; i++)
			{
				
				EffectControl.instance.addEffect(config[i]);
			}
			
		}
		
		private function jsCallSolitaire(param:Object):void
		{
			SolitaireManager.instance.update(param);
		}
		
		private function jsCallSolitaireFail():void
		{
			SolitaireManager.instance.notifyFail();
		}
		
		
		private function sendGift(param:Object):void 
		{
			//静态礼物的话
			if (int(param["swfInfo"]["type"]) == 1 )
			{
				if (GlobalConfig.NUM_FIXED_LIST.indexOf(int(param.count)) != -1 )
					return;
				
				if(param["giftType"] && param["giftType"]=="0_1" )
					return;
				
				GlobalConfig.openDiv();
				GiftManager.instance.update(param);
			}
		}
		
		private function resizeUI():void
		{
			SolitaireManager.instance.resizeUI()
			GiftManager.instance.resizeUI();
		}
		
	}
}