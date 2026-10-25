package net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.vo
{
   import net.bigpoint.darkorbit.com.module.RzoneStatusModule;
   
   public class BaseCrossServerState
   {
      
      protected var _state:RzoneStatusModule;
      
      public function BaseCrossServerState()
      {
         super();
      }
      
      public function get state() : RzoneStatusModule
      {
         return this._state;
      }
      
      public function dispose() : void
      {
      }
      
      public function set state(param1:RzoneStatusModule) : void
      {
         this._state = param1;
      }
   }
}

