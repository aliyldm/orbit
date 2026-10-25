package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class MiscellaneousCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      public function MiscellaneousCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc2_:int = int(param1[0]);
         var _loc3_:String = _definition.TRANS_BASE_KEY + "_" + MiscellaneousConditionTypes.instance.getTranslationSuffix(_loc2_);
         _description = BPLocale.getItem("q2_condition_" + _loc3_);
      }
   }
}

