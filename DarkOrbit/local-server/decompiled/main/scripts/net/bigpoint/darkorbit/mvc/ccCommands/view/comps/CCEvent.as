package net.bigpoint.darkorbit.mvc.ccCommands.view.comps
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.com.module.CCommandRequest;
   
   public class CCEvent extends Event
   {
      
      public static const CLEAR_HISTORY:String = "CLEAR";
      
      public static const HOTKEY:String = "HOTKEY";
      
      public static const ACTIVATE:String = "ACTIVATE";
      
      private var _request:CCommandRequest;
      
      private var _data:Object;
      
      public function CCEvent(param1:String, param2:CCommandRequest = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._request = param2;
      }
      
      public function set request(param1:CCommandRequest) : void
      {
         this._request = param1;
      }
      
      public function get request() : CCommandRequest
      {
         return this._request;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
      }
   }
}

