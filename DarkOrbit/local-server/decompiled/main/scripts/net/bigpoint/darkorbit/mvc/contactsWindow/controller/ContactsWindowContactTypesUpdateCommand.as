package net.bigpoint.darkorbit.mvc.contactsWindow.controller
{
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowContactListEntryVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactsWindowContactTypesUpdateCommand extends AbstractContactWindowCommand
   {
      
      public function ContactsWindowContactTypesUpdateCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:ContactsWindowContactListEntryVO = param1.getBody() as ContactsWindowContactListEntryVO;
         contactProxy.handleUpdateContactTypesFromServer(_loc2_);
      }
   }
}

