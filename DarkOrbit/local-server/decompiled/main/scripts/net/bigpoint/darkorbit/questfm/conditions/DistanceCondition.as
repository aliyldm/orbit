package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.TextFormatter;
   
   public class DistanceCondition extends Condition
   {
      
      public function DistanceCondition()
      {
         super();
      }
      
      override public function get currentVerbose() : String
      {
         return TextFormatter.roundInteger(_current);
      }
   }
}

