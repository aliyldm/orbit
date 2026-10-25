package net.bigpoint.darkorbit.mvc.contactsWindow.controller
{
   import net.bigpoint.darkorbit.mvc.contactsWindow.ContactsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowContactListVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactsWindowNewContactListCommand extends AbstractContactWindowCommand
   {
      
      public function ContactsWindowNewContactListCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:ContactsWindowContactListVO = param1.getBody() as ContactsWindowContactListVO;
         contactProxy.handleNewContactListFromServer(_loc2_);
         sendNotification(ContactsWindowNotifications.CREATE_WINDOW);
      }
   }
}

