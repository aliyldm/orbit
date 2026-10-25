package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class DieCondition extends Condition
   {
      
      public function DieCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc2_:String = "q2_condition_" + _definition.TRANS_BASE_KEY;
         _description = BPLocale.getItem(_loc2_);
      }
   }
}

