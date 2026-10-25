package net.bigpoint.darkorbit.net.netty.handlers.contactlist
{
   import net.bigpoint.darkorbit.com.module.ContactListEntryAttributeCommand;
   import net.bigpoint.darkorbit.com.module.ContactListEntryModule;
   import net.bigpoint.darkorbit.mvc.contactsWindow.ContactsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowContactListEntryVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactListUpdateContactAttributesHandlerCommand extends ContactListConvertingAbstractCommand
   {
      
      public function ContactListUpdateContactAttributesHandlerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:ContactListEntryAttributeCommand = param1.getBody() as ContactListEntryAttributeCommand;
         var _loc3_:Vector.<ContactsWindowContactListEntryVO> = convertModuleEntryVectorIntoContactlistEntryVO(new <ContactListEntryModule>[new ContactListEntryModule(_loc2_)]);
         sendNotification(ContactsWindowNotifications.CONTACT_ATTRIBUTES_UPDATE_FROM_SERVER,_loc3_[0]);
      }
      
      override protected function throwAnErrorIfAbstract() : void
      {
      }
   }
}

