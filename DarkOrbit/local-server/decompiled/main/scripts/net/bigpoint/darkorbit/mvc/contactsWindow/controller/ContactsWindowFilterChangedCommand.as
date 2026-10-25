package net.bigpoint.darkorbit.mvc.contactsWindow.controller
{
   import net.bigpoint.darkorbit.com.module.ContactListSettingsModule;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.contactsWindow.view.ContactsWindowEvent;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactsWindowFilterChangedCommand extends AbstractContactWindowCommand
   {
      
      public function ContactsWindowFilterChangedCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:String = (param1.getBody() as Array)[0];
         var _loc3_:Boolean = (param1.getBody() as Array)[1] as Boolean;
         switch(_loc2_)
         {
            case ContactsWindowEvent.CONTACTS_CHECKBOX:
               contactProxy.showContacts = _loc3_;
               break;
            case ContactsWindowEvent.CLANMEMBERS_CHECKBOX:
               contactProxy.showClanmembers = _loc3_;
               break;
            case ContactsWindowEvent.REQUESTS_CHECKBOX:
               contactProxy.showRequests = _loc3_;
               break;
            case ContactsWindowEvent.BLACKLISTED_CHECKBOX:
               contactProxy.showBlocked = _loc3_;
         }
         contactProxy.resendDataToView();
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ContactListSettingsModule(contactProxy.showContacts,contactProxy.showClanmembers,contactProxy.showRequests,contactProxy.showBlocked));
      }
   }
}

