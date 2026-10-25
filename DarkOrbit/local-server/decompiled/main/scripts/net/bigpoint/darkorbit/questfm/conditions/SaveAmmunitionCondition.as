package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class SaveAmmunitionCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var _ammo_type:int;
      
      private var _ammo_grade:int;
      
      public function SaveAmmunitionCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc4_:String = null;
         var _loc2_:Vector.<String> = param1;
         this._ammo_type = parseInt(_loc2_.shift());
         this._ammo_grade = parseInt(_loc2_.shift());
         if(this._ammo_type == 4)
         {
            this._ammo_type = 3;
         }
         var _loc3_:String = _definition.TRANS_BASE_KEY + "_" + InGameCatalog.instance.damage_types[this._ammo_type];
         _loc4_ = "";
         if(_target == 0 && this._ammo_type > 0)
         {
            _loc3_ += "_none";
         }
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
            }
         }
         if(mandatory && _target > 0)
         {
            _target_plain = "/" + _target;
         }
         _description = BPLocale.getItem("q2_condition_" + _loc3_);
         _description = description.replace(/%type%/,_loc4_);
         _description = description.replace(/%count%/,_target);
      }
      
      override public function get currentVerbose() : String
      {
         if(_target == 0)
         {
            return "";
         }
         return String(_current);
      }
   }
}

