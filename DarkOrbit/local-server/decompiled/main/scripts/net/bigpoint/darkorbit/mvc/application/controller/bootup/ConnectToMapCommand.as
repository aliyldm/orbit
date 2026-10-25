package net.bigpoint.darkorbit.mvc.application.controller.bootup
{
   import net.bigpoint.darkorbit.mvc.common.model.ConnectionProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class ConnectToMapCommand extends AsyncCommand
   {
      
      public function ConnectToMapCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         sendNotification(GuiNotifications.SHOW_CONNECTION_WINDOW);
         var _loc2_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy;
         _loc2_.connectToMap(Settings.mapID);
         commandComplete();
      }
   }
}

