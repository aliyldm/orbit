package net.bigpoint.darkorbit.net.netty.handlers.contactlist
{
   import net.bigpoint.darkorbit.com.module.ContactListEntryModule;
   import net.bigpoint.darkorbit.com.module.ContactListEntryTypeCommand;
   import net.bigpoint.darkorbit.mvc.contactsWindow.ContactsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowContactListEntryVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactListUpdateContactTypeHandlerCommand extends ContactListConvertingAbstractCommand
   {
      
      public function ContactListUpdateContactTypeHandlerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:ContactListEntryTypeCommand = param1.getBody() as ContactListEntryTypeCommand;
         var _loc3_:Vector.<ContactsWindowContactListEntryVO> = convertModuleEntryVectorIntoContactlistEntryVO(new <ContactListEntryModule>[new ContactListEntryModule(null,_loc2_)]);
         sendNotification(ContactsWindowNotifications.CONTACT_TYPES_UPDATE_FROM_SERVER,_loc3_[0]);
      }
      
      override protected function throwAnErrorIfAbstract() : void
      {
      }
   }
}

