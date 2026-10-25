package net.bigpoint.darkorbit.questfm.conditions
{
   public class GainInfluenceCondition extends Condition
   {
      
      public function GainInfluenceCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         super.parseMatches(param1);
         if(_target > 0)
         {
            _target_plain = "/" + _target;
            _validatable = true;
         }
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

