package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class BeaconTakeoverCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      public function BeaconTakeoverCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc3_:String = null;
         var _loc2_:String = param1.length > 0 ? param1[0] : "noMatches";
         _loc3_ = BPLocale.getItem("q2_condition_" + _definition.TRANS_BASE_KEY + "_" + _loc2_);
         _target_plain = "/" + _target;
         _description = _loc3_.replace(/%amount%/,_target);
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

