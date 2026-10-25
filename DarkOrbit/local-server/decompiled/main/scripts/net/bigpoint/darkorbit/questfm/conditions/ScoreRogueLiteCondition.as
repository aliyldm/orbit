package net.bigpoint.darkorbit.questfm.conditions
{
   public class ScoreRogueLiteCondition extends Condition
   {
      
      public function ScoreRogueLiteCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         _target_plain = "/" + _target;
      }
      
      override public function get currentVerbose() : String
      {
         return _current.toString();
      }
   }
}

