package net.bigpoint.darkorbit.mvc.chatclient.controller
{
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class DOChatReconnectCommand extends SimpleCommand
   {
      
      public function DOChatReconnectCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:DOChatProxy = facade.retrieveProxy(DOChatProxy.NAME) as DOChatProxy;
         _loc2_.reconnect();
      }
   }
}

