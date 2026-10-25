package net.bigpoint.darkorbit.net.netty.handlers.contactlist
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.contactsWindow.ContactsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.ContactsWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactUiUnblockHandlerCommand extends DOAbstractSimpleCommand
   {
      
      public function ContactUiUnblockHandlerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         (facade.retrieveProxy(ContactsWindowProxy.NAME) as ContactsWindowProxy).unblockRequestSending();
         sendNotification(ContactsWindowNotifications.SERVER_UNBLOCK_RECEIVED);
      }
   }
}

