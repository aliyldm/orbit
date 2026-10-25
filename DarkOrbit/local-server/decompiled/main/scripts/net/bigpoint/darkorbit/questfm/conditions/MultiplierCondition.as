package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class MultiplierCondition extends Condition
   {
      
      public function MultiplierCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         _description = BPLocale.getItem("q2_condition_" + _definition.TRANS_BASE_KEY + "_shiptype");
      }
   }
}

