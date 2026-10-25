package net.bigpoint.darkorbit.mvc.chatclient.controller
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatProposalVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class DOChatInternalProposalCommand extends DOAbstractSimpleCommand
   {
      
      public function DOChatInternalProposalCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:DOChatProxy = facade.retrieveProxy(DOChatProxy.NAME) as DOChatProxy;
         _loc2_.displayInternalChatProposal(param1.getBody() as DOChatProposalVO);
      }
   }
}

