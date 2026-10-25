package net.bigpoint.darkorbit.mvc.contactsWindow
{
   public class ContactsWindowNotifications
   {
      
      public static const NAME:String = "ContactsWindowNotifications_";
      
      public static const CREATE_WINDOW:String = NAME + "CreateWindow";
      
      public static const NEW_CONTACTLIST_FROM_SERVER:String = NAME + "NewContactlistFromServer";
      
      public static const CONTACTS_UPDATE_FROM_SERVER:String = NAME + "ContactsUpdateFromServer";
      
      public static const CONTACT_ATTRIBUTES_UPDATE_FROM_SERVER:String = NAME + "ContactAttributeUpdateFromServer";
      
      public static const CONTACT_TYPES_UPDATE_FROM_SERVER:String = NAME + "ContactTypesUpdateFromServer";
      
      public static const DELETE_CONTACTS:String = NAME + "DeleteContacts";
      
      public static const ADD_WHISPER_CONTACT:String = NAME + "AddWhisperContact";
      
      public static const CLEAR_WHISPER_UNREAD:String = NAME + "ClearWhisperUnread";
      
      public static const WHISPER_UNREAD_CHANGED:String = NAME + "WhisperUnreadChanged";
      
      public static const UPDATED_CONTACTLIST:String = NAME + "updatedContactList";
      
      public static const UPDATE_BLOCK_NOTIFICATIONS:String = NAME + "updateBlockNotifications";
      
      public static const UPDATE_BLOCK_NOTIFICATIONS_FROM_SERVER:String = NAME + "updateBlockNotificationsFromServer";
      
      public static const SHIP_SELECTED:String = NAME + "shipSelected";
      
      public static const FILTER_CHANGED:String = NAME + "filterChanged";
      
      public static const SEND_INVITE:String = NAME + "sendInvite";
      
      public static const SEND_REMOVE:String = NAME + "sendRemove";
      
      public static const SEND_BLOCK:String = NAME + "sendBlock";
      
      public static const SEND_UNBLOCK:String = NAME + "sendUnblock";
      
      public static const SEND_REMOVE_OUTGOING_REQUEST:String = NAME + "sendRemoveOutgoingRequest";
      
      public static const SEND_ACCEPT_PENDING_REQUEST:String = NAME + "sendAcceptPendingRequest";
      
      public static const SEND_DECLINE_PENDING_REQUEST:String = NAME + "sendDeclinePendingRequest";
      
      public static const NEW_FILTERSETTINGS_FROM_SERVER:String = NAME + "newFilterSettingsFromServer";
      
      public static const WAIT_FOR_SERVER_UNBLOCK:String = NAME + "waitForServerUnblock";
      
      public static const SERVER_UNBLOCK_RECEIVED:String = NAME + "serverUnblockReceived";
      
      public static const MAP_CHANGED:String = NAME + "MapChanged";
      
      public static const LIST_AMOUNTS_CHANGED:String = NAME + "ListAmountsChanged";
      
      public function ContactsWindowNotifications()
      {
         super();
      }
   }
}

