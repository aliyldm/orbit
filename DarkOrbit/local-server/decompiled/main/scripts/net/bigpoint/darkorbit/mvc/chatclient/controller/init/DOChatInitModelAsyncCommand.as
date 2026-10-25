package net.bigpoint.darkorbit.mvc.chatclient.controller.init
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.DOChatClientNotifications;
   import net.bigpoint.darkorbit.mvc.chatclient.controller.DOChatChangeActiveRoomCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.controller.DOChatInternalMessageCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.controller.DOChatInternalProposalCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.controller.DOChatInvitationAcceptedCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.controller.DOChatReconnectCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.controller.DOChatReportUserCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.controller.DOChatSendMessageCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.controller.DOChatWhisperMessageCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class DOChatInitModelAsyncCommand extends DOAbstractAsyncCommand
   {
      
      public function DOChatInitModelAsyncCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:DOChatProxy = null;
         super.execute(param1);
         if(!facade.hasProxy(DOChatProxy.NAME))
         {
            _loc2_ = new DOChatProxy();
            facade.registerProxy(_loc2_);
         }
         facade.registerCommand(DOChatClientNotifications.SEND_MESSAGE,DOChatSendMessageCommand);
         facade.registerCommand(DOChatClientNotifications.WHISPER_MESSAGE,DOChatWhisperMessageCommand);
         facade.registerCommand(DOChatClientNotifications.CHANGE_ACTIVE_ROOM,DOChatChangeActiveRoomCommand);
         facade.registerCommand(DOChatClientNotifications.NEW_MESSAGE,DOChatInternalMessageCommand);
         facade.registerCommand(DOChatClientNotifications.NEW_PROPOSAL,DOChatInternalProposalCommand);
         facade.registerCommand(DOChatClientNotifications.INVITE_ACCEPTED,DOChatInvitationAcceptedCommand);
         facade.registerCommand(DOChatClientNotifications.RECONNECT,DOChatReconnectCommand);
         facade.registerCommand(DOChatClientNotifications.REPORT_USER,DOChatReportUserCommand);
         commandComplete();
      }
   }
}

