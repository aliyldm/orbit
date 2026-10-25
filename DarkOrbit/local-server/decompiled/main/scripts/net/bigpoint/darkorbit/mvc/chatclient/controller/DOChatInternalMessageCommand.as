package net.bigpoint.darkorbit.mvc.chatclient.controller
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatMessageVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class DOChatInternalMessageCommand extends DOAbstractSimpleCommand
   {
      
      public function DOChatInternalMessageCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:DOChatProxy = facade.retrieveProxy(DOChatProxy.NAME) as DOChatProxy;
         _loc2_.displayInternalChatMessage(param1.getBody() as DOChatMessageVO);
      }
   }
}

