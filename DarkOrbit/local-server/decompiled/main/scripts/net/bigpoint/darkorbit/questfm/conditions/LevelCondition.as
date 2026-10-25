package net.bigpoint.darkorbit.questfm.conditions
{
   public class LevelCondition extends Condition
   {
      
      public function LevelCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         super.parseMatches(param1);
         _description = description.replace(/%count%/,_target);
      }
   }
}

