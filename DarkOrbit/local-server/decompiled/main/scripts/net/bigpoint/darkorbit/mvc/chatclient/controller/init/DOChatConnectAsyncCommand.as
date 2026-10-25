package net.bigpoint.darkorbit.mvc.chatclient.controller.init
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class DOChatConnectAsyncCommand extends DOAbstractAsyncCommand
   {
      
      public function DOChatConnectAsyncCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         (facade.retrieveProxy(DOChatProxy.NAME) as DOChatProxy).initChat();
         commandComplete();
      }
   }
}

