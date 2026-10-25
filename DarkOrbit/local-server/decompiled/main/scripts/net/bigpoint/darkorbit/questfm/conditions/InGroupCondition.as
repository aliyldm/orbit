package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class InGroupCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var _groupSize:int;
      
      public function InGroupCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         this._groupSize = int(param1[0]);
         if(this._groupSize > 2)
         {
            _description = BPLocale.getItem("q2_condition_" + _definition.TRANS_BASE_KEY + "_size").replace(/%count%/,this._groupSize);
         }
         else
         {
            _description = BPLocale.getItem("q2_condition_" + _definition.TRANS_BASE_KEY);
         }
      }
   }
}

