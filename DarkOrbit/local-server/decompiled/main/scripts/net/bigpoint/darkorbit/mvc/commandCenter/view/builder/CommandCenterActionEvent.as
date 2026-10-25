package net.bigpoint.darkorbit.mvc.commandCenter.view.builder
{
   import flash.events.Event;
   
   public class CommandCenterActionEvent extends Event
   {
      
      public static const TRIGGERED:String = "CommandCenterActionEvent.TRIGGERED";
      
      private var _action:XML;
      
      private var _layerName:String;
      
      public function CommandCenterActionEvent(param1:String, param2:XML, param3:String, param4:Boolean = true, param5:Boolean = false)
      {
         super(param1,param4,param5);
         this._action = param2;
         this._layerName = param3;
      }
      
      public function get action() : XML
      {
         return this._action;
      }
      
      public function get layerName() : String
      {
         return this._layerName;
      }
   }
}

