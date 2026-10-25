package net.bigpoint.darkorbit.equipment.view.components.menus
{
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.VO.Drone;
   
   public class DronesTextInfoManager
   {
      
      public function DronesTextInfoManager()
      {
         super();
      }
      
      public function getDroneWeaponEffectValue(param1:Drone) : Number
      {
         var _loc2_:int = 0;
         return this.getCombinedDroneEffect(param1,_loc2_);
      }
      
      public function getDroneShieldEffectValue(param1:Drone) : Number
      {
         var _loc2_:int = 1;
         return this.getCombinedDroneEffect(param1,_loc2_);
      }
      
      private function getCombinedDroneEffect(param1:Drone, param2:int) : Number
      {
         var _loc5_:Number = NaN;
         var _loc3_:Number = this.getDroneEffectValue(param1.effect,param2);
         var _loc4_:Number = this.getDroneEffectValue(param1.bonusEffects[Settings.activeConfig],param2);
         if(_loc4_ > 0)
         {
            _loc5_ = (1 + _loc3_ / 100) * (1 + _loc4_ / 100) - 1;
            return Math.round(_loc5_ * 1000) / 10;
         }
         return _loc3_;
      }
      
      public function isWeaponBoosted(param1:Drone) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Number = this.getDroneEffectValue(param1.bonusEffects[Settings.activeConfig],_loc2_);
         return _loc3_ > 0;
      }
      
      public function isShieldBoosted(param1:Drone) : Boolean
      {
         var _loc2_:int = 1;
         var _loc3_:Number = this.getDroneEffectValue(param1.bonusEffects[Settings.activeConfig],_loc2_);
         return _loc3_ > 0;
      }
      
      private function getDroneEffectValue(param1:String, param2:int) : Number
      {
         if(!param1)
         {
            return 0;
         }
         var _loc3_:Array = param1.split("/");
         var _loc4_:String = _loc3_[param2];
         return parseFloat(_loc4_.split("%")[0]);
      }
   }
}

