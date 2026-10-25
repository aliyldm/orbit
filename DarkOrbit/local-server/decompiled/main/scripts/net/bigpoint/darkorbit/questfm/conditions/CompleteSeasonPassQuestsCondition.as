package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class CompleteSeasonPassQuestsCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      public function CompleteSeasonPassQuestsCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc2_:String = "q2_condition_COMPLETE_";
         switch(int(param1[0]))
         {
            case 5:
               _loc2_ += "DAILIES";
               break;
            case 6:
               _loc2_ += "WEEKLIES";
               break;
            case 2:
               _loc2_ += "SEASON";
         }
         _description = BPLocale.getItem(_loc2_);
         if(_target > 0)
         {
            _target_plain = "/" + _target;
         }
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

