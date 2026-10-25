package net.bigpoint.darkorbit.questfm.conditions
{
   public class CompleteObjectivesCondition extends Condition
   {
      
      public function CompleteObjectivesCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         super.parseMatches(param1);
         _target_plain = "/" + _target;
         _description = _description.replace(/%count%/,_target);
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

