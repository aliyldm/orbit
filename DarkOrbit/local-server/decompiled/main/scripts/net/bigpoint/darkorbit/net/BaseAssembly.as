package net.bigpoint.darkorbit.net
{
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   
   public class BaseAssembly
   {
      
      protected static var _main:Main;
      
      public function BaseAssembly()
      {
         super();
      }
      
      public static function setMain(param1:Main) : void
      {
         _main = param1;
      }
      
      protected static function get map() : Map
      {
         return ScreenManager.getInstance().map;
      }
      
      protected function log(param1:String, param2:String = "LO") : void
      {
         GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(param1));
      }
   }
}

