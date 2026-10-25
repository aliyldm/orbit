package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.TimeFormatter;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class TimerCondition extends Condition
   {
      
      public function TimerCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         _target /= 1000;
         if(_target == 0)
         {
            _description = BPLocale.getItem("q2_condition_" + _definition.TRANS_BASE_KEY + "_challenge");
         }
      }
      
      override public function get currentVerbose() : String
      {
         return TimeFormatter.formatTime(int(_current / 1000));
      }
   }
}

