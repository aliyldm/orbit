package net.bigpoint.darkorbit.mvc.contactsWindow.controller
{
   import net.bigpoint.darkorbit.mvc.contactsWindow.ContactsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.ContactsWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class InitContactlistSystemCommand extends SimpleCommand
   {
      
      public function InitContactlistSystemCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         if(!facade.hasProxy(ContactsWindowProxy.NAME))
         {
            facade.registerProxy(new ContactsWindowProxy());
         }
         facade.registerCommand(ContactsWindowNotifications.NEW_CONTACTLIST_FROM_SERVER,ContactsWindowNewContactListCommand);
         facade.registerCommand(ContactsWindowNotifications.CONTACTS_UPDATE_FROM_SERVER,ContactsWindowContactsUpdateCommand);
         facade.registerCommand(ContactsWindowNotifications.CONTACT_ATTRIBUTES_UPDATE_FROM_SERVER,ContactsWindowContactAttributesUpdateCommand);
         facade.registerCommand(ContactsWindowNotifications.CONTACT_TYPES_UPDATE_FROM_SERVER,ContactsWindowContactTypesUpdateCommand);
         facade.registerCommand(ContactsWindowNotifications.CREATE_WINDOW,CreateContactsWindowCommand);
         facade.registerCommand(ContactsWindowNotifications.SHIP_SELECTED,ContactsWindowShipSelectedCommand);
         facade.registerCommand(ContactsWindowNotifications.FILTER_CHANGED,ContactsWindowFilterChangedCommand);
         facade.registerCommand(ContactsWindowNotifications.SEND_INVITE,ContactsWindowInviteCommand);
         facade.registerCommand(ContactsWindowNotifications.SEND_REMOVE,ContactsWindowRemoveCommand);
         facade.registerCommand(ContactsWindowNotifications.SEND_BLOCK,ContactsWindowBlockCommand);
         facade.registerCommand(ContactsWindowNotifications.SEND_UNBLOCK,ContactsWindowUnblockCommand);
         facade.registerCommand(ContactsWindowNotifications.SEND_REMOVE_OUTGOING_REQUEST,ContactsWindowRemoveOutgoingRequestCommand);
         facade.registerCommand(ContactsWindowNotifications.SEND_ACCEPT_PENDING_REQUEST,ContactsWindowAcceptPendingRequestCommand);
         facade.registerCommand(ContactsWindowNotifications.SEND_DECLINE_PENDING_REQUEST,ContactsWindowDeclinePendingRequestCommand);
         facade.registerCommand(ContactsWindowNotifications.UPDATE_BLOCK_NOTIFICATIONS,ContactsWindowUpdateBlockNotificationsCommand);
         facade.registerCommand(ContactsWindowNotifications.NEW_FILTERSETTINGS_FROM_SERVER,ContactsWindowNewFilterSettingsFromServerCommand);
         facade.registerCommand(ContactsWindowNotifications.UPDATE_BLOCK_NOTIFICATIONS_FROM_SERVER,ContactsWindowUpdateBlockNotificationsFromServerCommand);
         facade.registerCommand(ContactsWindowNotifications.DELETE_CONTACTS,ContactsWindowDeleteContactsCommand);
         facade.registerCommand(ContactsWindowNotifications.ADD_WHISPER_CONTACT,ContactsWindowAddWhisperContactCommand);
         facade.registerCommand(ContactsWindowNotifications.CLEAR_WHISPER_UNREAD,ContactsWindowClearWhisperUnreadCommand);
      }
   }
}

