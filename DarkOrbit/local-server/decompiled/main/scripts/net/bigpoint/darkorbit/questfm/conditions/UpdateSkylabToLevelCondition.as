package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class UpdateSkylabToLevelCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      public function UpdateSkylabToLevelCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc2_:String = null;
         if(Boolean(param1) && Boolean(param1.length))
         {
            _loc2_ = "q2_condition_" + definition.TRANS_BASE_KEY.replace("_TO_LEVEL","") + "_" + param1[0];
            _description = _description.replace(/%TYPE%/,BPLocale.getItem(_loc2_)).replace(/%COUNT%/,this._target);
         }
      }
   }
}

