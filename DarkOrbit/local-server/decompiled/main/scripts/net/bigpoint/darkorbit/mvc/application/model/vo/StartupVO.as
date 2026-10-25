package net.bigpoint.darkorbit.mvc.application.model.vo
{
   import flash.display.Stage;
   import net.bigpoint.darkorbit.Main;
   
   public class StartupVO
   {
      
      private var _stage:Stage;
      
      private var _main:Main;
      
      private var _flashVars:Object;
      
      public function StartupVO(param1:Main, param2:Stage)
      {
         super();
         this._main = param1;
         this._stage = param2;
         this._flashVars = param1.loaderInfo.parameters.host ? param1.loaderInfo.parameters : param2.loaderInfo.parameters;
      }
      
      public function get main() : Main
      {
         return this._main;
      }
      
      public function get stage() : Stage
      {
         return this._stage;
      }
      
      public function get flashVars() : Object
      {
         return this._flashVars;
      }
   }
}

