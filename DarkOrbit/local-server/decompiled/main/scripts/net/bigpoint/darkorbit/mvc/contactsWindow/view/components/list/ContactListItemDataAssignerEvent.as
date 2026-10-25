package net.bigpoint.darkorbit.mvc.contactsWindow.view.components.list
{
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowContactListEntryVO;
   
   public class ContactListItemDataAssignerEvent extends MouseEvent
   {
      
      protected static const NAME:String = "ContactListItemDataAssignerEvent";
      
      public static var ICON_CLICKED:String = NAME + ".IconClicked";
      
      public static var INVITE_CONTACT_TO_GROUP:String = NAME + ".inviteContactToGroup";
      
      public static var REMOVE_CONTACT_REQUEST:String = NAME + ".removeContactRequest";
      
      public static var ACCEPT_CONTACT:String = NAME + ".acceptContact";
      
      public static var DECLINE_CONTACT:String = NAME + ".declineContact";
      
      public static var UNBLOCK_CONTACT:String = NAME + ".unblockContact";
      
      public static var WHISPER_CONTACT:String = NAME + ".whisperContact";
      
      public static var DISMISS_WHISPER:String = NAME + ".dismissWhisper";
      
      private var _vo:ContactsWindowContactListEntryVO;
      
      public function ContactListItemDataAssignerEvent(param1:String, param2:ContactsWindowContactListEntryVO)
      {
         super(param1,true);
         this._vo = param2;
      }
      
      public function get data() : ContactsWindowContactListEntryVO
      {
         return this._vo;
      }
   }
}

