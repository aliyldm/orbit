package net.bigpoint.darkorbit.mvc.chatclient.controller
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatInviteVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class DOChatInvitationAcceptedCommand extends DOAbstractSimpleCommand
   {
      
      public function DOChatInvitationAcceptedCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:DOChatInviteVO = param1.getBody() as DOChatInviteVO;
         var _loc3_:DOChatProxy = facade.retrieveProxy(DOChatProxy.NAME) as DOChatProxy;
         _loc3_.handlePrivateRoomAccepted(_loc2_);
      }
   }
}

