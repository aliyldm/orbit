package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class AvoidDamageCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var damageTypeID:int;
      
      public function AvoidDamageCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         this.damageTypeID = int(param1[0]);
         _target_plain = "/" + _target;
         _description = BPLocale.getItem("q2_condition_" + _definition.TRANS_BASE_KEY + "_" + InGameCatalog.instance.damage_types[this.damageTypeID]);
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

