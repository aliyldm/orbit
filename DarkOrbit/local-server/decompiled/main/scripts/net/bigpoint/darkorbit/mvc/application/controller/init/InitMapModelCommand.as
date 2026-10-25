package net.bigpoint.darkorbit.mvc.application.controller.init
{
   import net.bigpoint.darkorbit.mvc.common.model.MapManagerProxy;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class InitMapModelCommand extends AsyncCommand
   {
      
      public static const FILENAME_MAP:String = "maps.php";
      
      public function InitMapModelCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:String = Settings.dynamicHost + Settings.basePath + "xml/" + FILENAME_MAP;
         var _loc3_:MapManagerProxy = facade.retrieveProxy(MapManagerProxy.NAME) as MapManagerProxy;
         _loc3_.loadConfig(_loc2_,commandComplete);
      }
   }
}

