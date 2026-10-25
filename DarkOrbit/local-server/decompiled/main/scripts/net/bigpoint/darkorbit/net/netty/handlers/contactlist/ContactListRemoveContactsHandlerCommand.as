package net.bigpoint.darkorbit.net.netty.handlers.contactlist
{
   import net.bigpoint.darkorbit.com.module.ContactListRemoveContactsCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.contactsWindow.ContactsWindowNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactListRemoveContactsHandlerCommand extends DOAbstractSimpleCommand
   {
      
      public function ContactListRemoveContactsHandlerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:ContactListRemoveContactsCommand = param1.getBody() as ContactListRemoveContactsCommand;
         facade.sendNotification(ContactsWindowNotifications.DELETE_CONTACTS,_loc2_.contactUserIds);
      }
   }
}

