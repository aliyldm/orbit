package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.pattern.RocketPattern;
   
   public class SpendAmmunitionCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var _ammo_type:int;
      
      private var _ammo_grade:int;
      
      public function SpendAmmunitionCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc4_:String = null;
         var _loc2_:Vector.<String> = param1;
         this._ammo_type = parseInt(_loc2_.shift());
         this._ammo_grade = parseInt(_loc2_.shift());
         var _loc3_:String = _definition.TRANS_BASE_KEY + "_" + InGameCatalog.instance.damage_types[this._ammo_type];
         _loc4_ = "";
         if(this._ammo_grade > 0)
         {
            _loc3_ += "_spec";
            if(this._ammo_type == 1)
            {
               _loc4_ = InGameCatalog.instance.battery_types[this._ammo_grade];
            }
            else if(this._ammo_type == 2)
            {
               _loc4_ = InGameCatalog.instance.rocketNames[this._ammo_grade];
               if(this._ammo_grade == RocketPattern.EMP_01)
               {
                  _loc3_ += "_special";
               }
            }
         }
         if(_target == 0)
         {
            _loc3_ += "_challenge";
         }
         else
         {
            _target_plain = "/" + _target;
         }
         _description = BPLocale.getItem("q2_condition_" + _loc3_);
         _description = description.replace(/%type%/,_loc4_);
         _description = description.replace(/%count%/,_target);
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

