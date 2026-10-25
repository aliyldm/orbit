package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events
{
   import flash.events.Event;
   
   public class DataTransferEvent extends Event
   {
      
      public static const MAIN_LIB_LOADED:String = "DataTransferEvent.onMainLibLoaded";
      
      public static const MAIN_LIB_PROGRESS:String = "DataTransferEvent.onMainLibProgress";
      
      public static const GATES_LIB_LOADED:String = "DataTransferEvent.onGatesLibLoaded";
      
      public static const GATES_LIB_PROGRESS:String = "DataTransferEvent.onGatesLibProgress";
      
      public static const PRELOAD_BACKGROUND_PROGRESS:String = "DataTransferEvent.preloadBackgroundProgress";
      
      public static const PRELOAD_BACKGROUND_COMPLETE:String = "DataTransferEvent.preloadBackgroundComplete";
      
      public function DataTransferEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

