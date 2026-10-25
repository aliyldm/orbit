package net.bigpoint.darkorbit.net.netty
{
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   
   public class BaseHandler
   {
      
      protected static var _main:Main;
      
      protected static var _facade:GameFacade;
      
      public function BaseHandler()
      {
         super();
      }
      
      public static function setMain(param1:Main) : void
      {
         _main = param1;
      }
      
      public static function setFacade(param1:GameFacade) : void
      {
         _facade = param1;
      }
      
      protected static function get map() : Map
      {
         return ScreenManager.getInstance().map;
      }
      
      public static function get main() : Main
      {
         return _main;
      }
      
      public function handleFeedbackCommand(param1:Vector.<String>) : void
      {
      }
   }
}

