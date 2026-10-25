package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.ServerChangeCommand;
   import net.bigpoint.darkorbit.mvc.common.model.ConnectionProxy;
   import net.bigpoint.darkorbit.net.ConnectionManager;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class ServerChangedHandlerCommand extends SimpleCommand
   {
      
      public function ServerChangedHandlerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:ServerChangeCommand = param1.getBody() as ServerChangeCommand;
         var _loc3_:ConnectionManager = (facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy).connectionManager;
         _loc3_.handleServerChanged();
      }
   }
}

