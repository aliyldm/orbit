package net.bigpoint.darkorbit.mvc.contactsWindow.view
{
   import net.bigpoint.darkorbit.com.module.GroupInvitationRequest;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.chatclient.DOChatClientNotifications;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatUserVO;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.KeyboardNotifications;
   import net.bigpoint.darkorbit.mvc.contactsWindow.ContactsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.contactsWindow.controller.CreateContactsWindowCommand;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowContactListVO;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowFilterSettingsVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactsWindowMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "ContactsWindowMediator";
      
      public function ContactsWindowMediator(param1:ContactsWindow)
      {
         super(NAME,param1);
         mapNotificationToMethod(ContactsWindowNotifications.UPDATED_CONTACTLIST,this.handleNewContactListNofication);
         mapNotificationToMethod(ContactsWindowNotifications.SHIP_SELECTED,this.handleUpdateSelectedShipNofication);
         mapNotificationToMethod(ContactsWindowNotifications.NEW_FILTERSETTINGS_FROM_SERVER,this.handleNewFilterSettingsNofication);
         mapNotificationToMethod(ContactsWindowNotifications.UPDATE_BLOCK_NOTIFICATIONS_FROM_SERVER,this.handleUpdateBlockAllNotificationsFromServer);
         mapNotificationToMethod(ContactsWindowNotifications.WAIT_FOR_SERVER_UNBLOCK,this.handleWaitForServerUnblockNotification);
         mapNotificationToMethod(ContactsWindowNotifications.SERVER_UNBLOCK_RECEIVED,this.handleServerUnblockReceivedNotification);
         mapNotificationToMethod(ContactsWindowNotifications.LIST_AMOUNTS_CHANGED,this.handleListAmountsChangedNotification);
      }
      
      override public function setViewComponent(param1:Object) : void
      {
         this.removeAllEventListeners();
         super.setViewComponent(param1);
         this.addAllEventListeners();
      }
      
      private function get contactsWindow() : ContactsWindow
      {
         return viewComponent as ContactsWindow;
      }
      
      private function addAllEventListeners() : void
      {
         this.contactsWindow.addEventListener(ContactsWindowEvent.INVITE_CLICKED,this.notifyProxyAboutInviteClick);
         this.contactsWindow.addEventListener(ContactsWindowEvent.REMOVE_CLICKED,this.notifyProxyAboutRemoveClick);
         this.contactsWindow.addEventListener(ContactsWindowEvent.BLOCK_CLICKED,this.notifyProxyAboutBlockClick);
         this.contactsWindow.addEventListener(ContactsWindowEvent.INVITE_TO_GROUP_CLICKED,this.inviteToGroupClick);
         this.contactsWindow.addEventListener(ContactsWindowEvent.UNBLOCK_USER_CLICKED,this.notifyProxyAboutUnblockClick);
         this.contactsWindow.addEventListener(ContactsWindowEvent.ACCEPT_PENDING_REQUEST_CLICKED,this.notifyProxyAboutAcceptPendingRequestClick);
         this.contactsWindow.addEventListener(ContactsWindowEvent.DECLINE_PENDING_REQUEST_CLICKED,this.notifyProxyAboutDeclinePendingRequestClick);
         this.contactsWindow.addEventListener(ContactsWindowEvent.REMOVE_OUTGOING_REQUEST_CLICKED,this.notifyProxyAboutRemoveOutgoingRequestClick);
         this.contactsWindow.addEventListener(ContactsWindowEvent.FILTER_CHECKBOX_STATE_CHANGED,this.notifyProxyAboutFilterChange);
         this.contactsWindow.addEventListener(ContactsWindowEvent.BLOCK_NOTIFICATIONS_CHECKBOX_STATE_CHANGED,this.notifyProxyAboutBlockNotificationsChange);
         this.contactsWindow.addEventListener(ContactsWindowEvent.USERNAME_INPUTFIELD_GAINED_FOCUS,this.handleUsernameInputGainedFocus);
         this.contactsWindow.addEventListener(ContactsWindowEvent.USERNAME_INPUTFIELD_LOST_FOCUS,this.handleUsernameInputLostFocus);
         this.contactsWindow.addEventListener(ContactsWindowEvent.CONTACT_CLICKED,this.handleContactClicked);
         this.contactsWindow.addEventListener(ContactsWindowEvent.WHISPER_CLICKED,this.handleWhisperClicked);
         this.contactsWindow.addEventListener(ContactsWindowEvent.DISMISS_WHISPER_CLICKED,this.handleDismissWhisperClicked);
      }
      
      private function removeAllEventListeners() : void
      {
         if(this.contactsWindow)
         {
            this.contactsWindow.removeEventListener(ContactsWindowEvent.INVITE_CLICKED,this.notifyProxyAboutInviteClick);
            this.contactsWindow.removeEventListener(ContactsWindowEvent.REMOVE_CLICKED,this.notifyProxyAboutRemoveClick);
            this.contactsWindow.removeEventListener(ContactsWindowEvent.BLOCK_CLICKED,this.notifyProxyAboutBlockClick);
            this.contactsWindow.removeEventListener(ContactsWindowEvent.INVITE_TO_GROUP_CLICKED,this.inviteToGroupClick);
            this.contactsWindow.removeEventListener(ContactsWindowEvent.UNBLOCK_USER_CLICKED,this.notifyProxyAboutUnblockClick);
            this.contactsWindow.removeEventListener(ContactsWindowEvent.ACCEPT_PENDING_REQUEST_CLICKED,this.notifyProxyAboutAcceptPendingRequestClick);
            this.contactsWindow.removeEventListener(ContactsWindowEvent.DECLINE_PENDING_REQUEST_CLICKED,this.notifyProxyAboutDeclinePendingRequestClick);
            this.contactsWindow.removeEventListener(ContactsWindowEvent.REMOVE_OUTGOING_REQUEST_CLICKED,this.notifyProxyAboutRemoveOutgoingRequestClick);
            this.contactsWindow.removeEventListener(ContactsWindowEvent.FILTER_CHECKBOX_STATE_CHANGED,this.notifyProxyAboutFilterChange);
            this.contactsWindow.removeEventListener(ContactsWindowEvent.BLOCK_NOTIFICATIONS_CHECKBOX_STATE_CHANGED,this.notifyProxyAboutBlockNotificationsChange);
            this.contactsWindow.removeEventListener(ContactsWindowEvent.USERNAME_INPUTFIELD_GAINED_FOCUS,this.handleUsernameInputGainedFocus);
            this.contactsWindow.removeEventListener(ContactsWindowEvent.USERNAME_INPUTFIELD_LOST_FOCUS,this.handleUsernameInputLostFocus);
            this.contactsWindow.removeEventListener(ContactsWindowEvent.CONTACT_CLICKED,this.handleContactClicked);
            this.contactsWindow.removeEventListener(ContactsWindowEvent.WHISPER_CLICKED,this.handleWhisperClicked);
            this.contactsWindow.removeEventListener(ContactsWindowEvent.DISMISS_WHISPER_CLICKED,this.handleDismissWhisperClicked);
         }
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.addAllEventListeners();
      }
      
      override public function onRemove() : void
      {
         this.removeAllEventListeners();
         facade.registerCommand(ContactsWindowNotifications.CREATE_WINDOW,CreateContactsWindowCommand);
         super.onRemove();
      }
      
      private function handleContactClicked(param1:ContactsWindowEvent) : void
      {
         sendNotification(ContactsWindowNotifications.SHIP_SELECTED,param1.params);
      }
      
      private function handleWhisperClicked(param1:ContactsWindowEvent) : void
      {
         var _loc2_:String = param1.params[0] as String;
         var _loc3_:String = String(param1.params[1]);
         var _loc4_:String = param1.params.length > 2 ? param1.params[2] as String : null;
         var _loc5_:String = param1.params.length > 3 ? param1.params[3] as String : null;
         if(_loc2_)
         {
            sendNotification(DOChatClientNotifications.OPEN_WHISPER,new DOChatUserVO(_loc2_,DOChatUserVO.TYPE_USER,_loc4_,null,_loc3_,null,_loc5_));
         }
      }
      
      private function handleDismissWhisperClicked(param1:ContactsWindowEvent) : void
      {
         sendNotification(ContactsWindowNotifications.CLEAR_WHISPER_UNREAD,param1.params);
      }
      
      private function handleUsernameInputLostFocus(param1:ContactsWindowEvent) : void
      {
         sendNotification(KeyboardNotifications.UNLOCK_KEYBOARD);
      }
      
      private function handleUsernameInputGainedFocus(param1:ContactsWindowEvent) : void
      {
         UISystem.getInstance().tooltipManager.attemptToRemoveTooltip();
         sendNotification(KeyboardNotifications.LOCK_KEYBOARD);
      }
      
      private function notifyProxyAboutRemoveClick(param1:ContactsWindowEvent) : void
      {
         if(this.contactsWindow)
         {
            sendNotification(ContactsWindowNotifications.SEND_REMOVE,this.contactsWindow.getSelectedUsernameFieldText());
         }
      }
      
      private function notifyProxyAboutBlockClick(param1:ContactsWindowEvent) : void
      {
         if(this.contactsWindow)
         {
            sendNotification(ContactsWindowNotifications.SEND_BLOCK,this.contactsWindow.getSelectedUsernameFieldText());
         }
      }
      
      private function notifyProxyAboutBlockNotificationsChange(param1:ContactsWindowEvent) : void
      {
         sendNotification(ContactsWindowNotifications.UPDATE_BLOCK_NOTIFICATIONS,param1.params[0]);
      }
      
      private function notifyProxyAboutInviteClick(param1:ContactsWindowEvent) : void
      {
         if(this.contactsWindow)
         {
            sendNotification(ContactsWindowNotifications.SEND_INVITE,this.contactsWindow.getSelectedUsernameFieldText());
         }
      }
      
      private function notifyProxyAboutRemoveOutgoingRequestClick(param1:ContactsWindowEvent) : void
      {
         sendNotification(ContactsWindowNotifications.SEND_REMOVE_OUTGOING_REQUEST,param1.params[0]);
      }
      
      private function notifyProxyAboutDeclinePendingRequestClick(param1:ContactsWindowEvent) : void
      {
         sendNotification(ContactsWindowNotifications.SEND_DECLINE_PENDING_REQUEST,param1.params[0]);
      }
      
      private function notifyProxyAboutAcceptPendingRequestClick(param1:ContactsWindowEvent) : void
      {
         sendNotification(ContactsWindowNotifications.SEND_ACCEPT_PENDING_REQUEST,param1.params[0]);
      }
      
      private function notifyProxyAboutUnblockClick(param1:ContactsWindowEvent) : void
      {
         sendNotification(ContactsWindowNotifications.SEND_UNBLOCK,param1.params[0]);
      }
      
      private function notifyProxyAboutFilterChange(param1:ContactsWindowEvent) : void
      {
         sendNotification(ContactsWindowNotifications.FILTER_CHANGED,param1.params);
      }
      
      private function inviteToGroupClick(param1:ContactsWindowEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new GroupInvitationRequest(param1.params[0]));
      }
      
      private function handleNewContactListNofication(param1:INotification) : void
      {
         var _loc2_:ContactsWindowContactListVO = param1.getBody() as ContactsWindowContactListVO;
         this.contactsWindow.createItemlist(_loc2_.listEntries);
      }
      
      private function handleUpdateSelectedShipNofication(param1:INotification) : void
      {
         var _loc2_:String = (param1.getBody() as Array)[1];
         this.contactsWindow.updateSelectedUsernameTo(_loc2_);
      }
      
      private function handleNewFilterSettingsNofication(param1:INotification) : void
      {
         var _loc2_:ContactsWindowFilterSettingsVO = param1.getBody() as ContactsWindowFilterSettingsVO;
         this.contactsWindow.alterFilterCheckBoxStates(_loc2_);
      }
      
      private function handleUpdateBlockAllNotificationsFromServer(param1:INotification) : void
      {
         this.contactsWindow.alterBlockNotificationsCheckBoxState(param1.getBody() as Boolean);
      }
      
      private function handleWaitForServerUnblockNotification(param1:INotification) : void
      {
         this.contactsWindow.showBlockOverlay();
      }
      
      private function handleServerUnblockReceivedNotification(param1:INotification) : void
      {
         this.contactsWindow.hideBlockOverlay();
      }
      
      private function handleListAmountsChangedNotification(param1:INotification) : void
      {
         var _loc2_:Array = param1.getBody() as Array;
         this.contactsWindow.updateDescriptionLabels(_loc2_);
      }
   }
}

