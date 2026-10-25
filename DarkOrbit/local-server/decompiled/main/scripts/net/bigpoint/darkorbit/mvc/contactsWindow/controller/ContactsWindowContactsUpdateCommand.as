package net.bigpoint.darkorbit.mvc.contactsWindow.controller
{
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowContactListEntryVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactsWindowContactsUpdateCommand extends AbstractContactWindowCommand
   {
      
      public function ContactsWindowContactsUpdateCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Vector.<ContactsWindowContactListEntryVO> = param1.getBody() as Vector.<ContactsWindowContactListEntryVO>;
         contactProxy.handleUpdateContactsFromServer(_loc2_);
      }
   }
}

