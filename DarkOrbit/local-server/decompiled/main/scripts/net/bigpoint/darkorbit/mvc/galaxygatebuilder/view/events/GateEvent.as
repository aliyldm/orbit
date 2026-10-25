package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events
{
   import flash.events.Event;
   
   public class GateEvent extends Event
   {
      
      public static const GATE_PROGRESS:String = "GateEvent.onGateProgress";
      
      public static const GATE_COMPLETE:String = "GateEvent.onGateComplete";
      
      public static const GATE_DETAILS:String = "GateEvent.onGateDetails";
      
      public static const GATE_SETUP:String = "GateEvent.onGateSetup";
      
      public static const GATE_LIFE_PURCHASE_INIT:String = "GateEvent.gateLifePurchaseInit";
      
      public static const GATE_LIFE_PURCHASE_COMPLETE:String = "GateEvent.gateLifePurchaseComplete";
      
      public static const GATE_SHOW_PROBABILITY:String = "GateEvent.showProbability";
      
      public var gateID:int;
      
      public function GateEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

