package net.bigpoint.darkorbit.net.netty.handlers.contactlist
{
   import net.bigpoint.darkorbit.com.module.ContactListBlockInvitationsModule;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.contactsWindow.ContactsWindowNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactListBlockInvitationsHandlerCommand extends DOAbstractSimpleCommand
   {
      
      public function ContactListBlockInvitationsHandlerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:ContactListBlockInvitationsModule = param1.getBody() as ContactListBlockInvitationsModule;
         sendNotification(ContactsWindowNotifications.UPDATE_BLOCK_NOTIFICATIONS_FROM_SERVER,_loc2_.blockAllInvitations);
      }
   }
}

