package child.finalweapon
{
	import core.BaseEffect;
	
	public class EEFinalWeaponV extends BaseEffect
	{
		public function EEFinalWeaponV()
		{
			super();
		}
		
		override protected function addLevelIcon(data:Object):void
		{
//			super.addLevelIcon(data);
//			levelImg.x = 8;
//			levelImg.y = 14;
		}
		
		override public function get instanceClass():Class
		{
			return Final_Weapon;
		}
	}
}