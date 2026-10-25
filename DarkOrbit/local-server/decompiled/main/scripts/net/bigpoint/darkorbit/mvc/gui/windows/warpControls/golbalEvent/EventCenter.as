package net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent
{
   import flash.events.EventDispatcher;
   
   public class EventCenter
   {
      
      private static var _instance:EventCenter;
      
      private var _eventDispatch:EventDispatcher;
      
      public function EventCenter()
      {
         super();
         this._eventDispatch = new EventDispatcher();
      }
      
      public static function get instance() : EventCenter
      {
         if(!_instance)
         {
            _instance = new EventCenter();
         }
         return _instance;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._eventDispatch.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._eventDispatch.removeEventListener(param1,param2,param3);
      }
      
      public function dispatchEvent(param1:GameEvent) : Boolean
      {
         return this._eventDispatch.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._eventDispatch.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._eventDispatch.willTrigger(param1);
      }
   }
}

