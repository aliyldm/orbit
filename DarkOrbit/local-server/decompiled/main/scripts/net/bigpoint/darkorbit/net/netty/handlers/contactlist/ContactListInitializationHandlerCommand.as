package net.bigpoint.darkorbit.net.netty.handlers.contactlist
{
   import net.bigpoint.darkorbit.com.module.ContactListInitializationCommand;
   import net.bigpoint.darkorbit.mvc.contactsWindow.ContactsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowContactListEntryVO;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowContactListVO;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowFilterSettingsVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactListInitializationHandlerCommand extends ContactListConvertingAbstractCommand
   {
      
      public function ContactListInitializationHandlerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:ContactListInitializationCommand = param1.getBody() as ContactListInitializationCommand;
         var _loc3_:Vector.<ContactsWindowContactListEntryVO> = convertModuleEntryVectorIntoContactlistEntryVO(_loc2_.contactsCommand.contacts);
         sendNotification(ContactsWindowNotifications.NEW_CONTACTLIST_FROM_SERVER,new ContactsWindowContactListVO(_loc3_));
         sendNotification(ContactsWindowNotifications.NEW_FILTERSETTINGS_FROM_SERVER,new ContactsWindowFilterSettingsVO(_loc2_.filterSettings.showFriends,_loc2_.filterSettings.showClanMembers,_loc2_.filterSettings.showRequests,_loc2_.filterSettings.showBlacklistPlayers));
         sendNotification(ContactsWindowNotifications.UPDATE_BLOCK_NOTIFICATIONS_FROM_SERVER,_loc2_.blockInvitations.blockAllInvitations);
      }
      
      override protected function throwAnErrorIfAbstract() : void
      {
      }
   }
}

