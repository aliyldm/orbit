package net.bigpoint.darkorbit.mvc.ccCommands.control
{
   import net.bigpoint.darkorbit.com.module.CCommandRequest;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.ccCommands.model.CCCommandsProxy;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CCSendRequestCommand extends DOAbstractSimpleCommand
   {
      
      public function CCSendRequestCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:CCommandRequest = param1.getBody() as CCommandRequest;
         var _loc3_:CCCommandsProxy = retrieveProxy(CCCommandsProxy.NAME) as CCCommandsProxy;
         _loc3_.writeToHistory(_loc2_);
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc2_);
      }
   }
}

