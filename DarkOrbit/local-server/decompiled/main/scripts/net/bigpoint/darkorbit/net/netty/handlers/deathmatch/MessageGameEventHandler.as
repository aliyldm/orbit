package net.bigpoint.darkorbit.net.netty.handlers.deathmatch
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.MessageGameEventCommand;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.ContactsWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class MessageGameEventHandler extends BaseHandler
   {
      
      private static const CONTACT_INVITATIONS_BLOCKED_KEY:String = "log_msg_err_blocking_invitations";
      
      public function MessageGameEventHandler()
      {
         super();
      }
      
      public static function run(param1:MessageGameEventCommand) : void
      {
         var _loc5_:ContactsWindowProxy = null;
         var _loc2_:String = param1.messageKey;
         var _loc3_:String = param1.wildCard;
         var _loc4_:String = param1.replacementValue;
         if(_loc2_ == CONTACT_INVITATIONS_BLOCKED_KEY)
         {
            _loc5_ = _facade.retrieveProxy(ContactsWindowProxy.NAME) as ContactsWindowProxy;
            if(_loc5_)
            {
               _loc5_.markOutgoingRequestDeclined(_loc4_);
            }
         }
         _facade.sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(BPLocale.getItem(_loc2_).replace(_loc3_,_loc4_)));
      }
   }
}

