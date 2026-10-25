package net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent
{
   import flash.events.Event;
   
   public class GameEvent extends Event
   {
      
      private var _body:*;
      
      public function GameEvent(param1:String, param2:* = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._body = param2;
      }
      
      public function get body() : *
      {
         return this._body;
      }
   }
}

