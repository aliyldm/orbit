package net.bigpoint.darkorbit.mvc.traininggrounds.view
{
   import flash.events.Event;
   
   public class TraininggroundsWindowEvent extends Event
   {
      
      public static const MATCH_CLICKED:String = "MATCH_CLICKED";
      
      public static const CANCEL_CLICKED:String = "CANCEL_CLICKED";
      
      public static const FIGHT_CLICKED:String = "FIGHT_CLICKED";
      
      public static const RESULTS_CLOSED:String = "RESULTS_CLOSED";
      
      public function TraininggroundsWindowEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

