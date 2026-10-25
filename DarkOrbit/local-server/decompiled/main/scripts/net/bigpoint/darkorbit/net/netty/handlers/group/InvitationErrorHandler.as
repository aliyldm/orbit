package net.bigpoint.darkorbit.net.netty.handlers.group
{
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.InvitationErrorCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.net.netty.handlers.group.base.GroupSystemHandler;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InvitationErrorHandler extends GroupSystemHandler
   {
      
      public function InvitationErrorHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:InvitationErrorCommand = param1.getBody() as InvitationErrorCommand;
         var _loc3_:Dictionary = InGameCatalog.instance.invitationErrorHashmap;
         var _loc4_:String = _loc3_[_loc2_.error];
         if(_loc4_)
         {
            sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams(BPLocale.getItem(_loc4_)));
         }
         switch(_loc2_.error)
         {
            case InvitationErrorCommand.ERRORTYPE_NO_INVITATION:
            case InvitationErrorCommand.ERRORTYPE_CANDIDATE_NONEXISTENT:
            case InvitationErrorCommand.ERRORTYPE_INVITER_NONEXISTENT:
               groupProxy.deleteInvitation(_loc2_.inviterId,_loc2_.candidateId);
         }
      }
   }
}

