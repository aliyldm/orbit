package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class RechargeAmountCondition extends Condition
   {
      
      public function RechargeAmountCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         super.parseMatches(param1);
         if(_target == 0)
         {
            _description = BPLocale.getItem("q2_condition_" + _definition.TRANS_BASE_KEY + "_challenge");
         }
         else
         {
            _target_plain = "/" + _target;
            _description = _description.replace(/%count%/,_target);
         }
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

