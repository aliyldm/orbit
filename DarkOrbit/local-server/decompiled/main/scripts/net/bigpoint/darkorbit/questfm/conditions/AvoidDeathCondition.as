package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class AvoidDeathCondition extends Condition
   {
      
      public function AvoidDeathCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         super.parseMatches(param1);
         if(_target > 0)
         {
            _description = BPLocale.getItem("q2_condition_" + _definition.TRANS_BASE_KEY + "_n").replace(/%count%/,_target);
         }
      }
   }
}

