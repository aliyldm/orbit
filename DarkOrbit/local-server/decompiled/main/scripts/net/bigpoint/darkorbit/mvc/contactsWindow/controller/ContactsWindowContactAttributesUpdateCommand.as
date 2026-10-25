package net.bigpoint.darkorbit.mvc.contactsWindow.controller
{
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowContactListEntryVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactsWindowContactAttributesUpdateCommand extends AbstractContactWindowCommand
   {
      
      public function ContactsWindowContactAttributesUpdateCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:ContactsWindowContactListEntryVO = param1.getBody() as ContactsWindowContactListEntryVO;
         contactProxy.handleUpdateContactAttributesFromServer(_loc2_);
      }
   }
}

