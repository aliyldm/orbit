package net.bigpoint.darkorbit.mvc.contactsWindow.view.components.list
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.LabelSkin;
   import net.bigpoint.darkorbit.mvc.chatclient.view.ChatUIIconSkinFactory;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowContactListEntryVO;
   
   public class ContactListItemDataAssigner extends DefaultItemDataAssigner
   {
      
      public static const LEVEL_PLACEHOLDER:RegExp = /%LEVEL%/;
      
      public static const CLAN_PLACEHOLDER:RegExp = /%CLANPLACEHOLDER%/;
      
      public static const CLANTAG_PLACEHOLDER:RegExp = /%CLANTAG%/;
      
      protected var _statusIconBuddyOffline:Coreponent;
      
      protected var _statusIconBuddyOnline:Coreponent;
      
      protected var _statusIconBuddyOnMap:Coreponent;
      
      protected var _statusIconBuddyPending:Coreponent;
      
      protected var _statusIconBuddyBlocked:Coreponent;
      
      protected var _statusIconBuddyMyrequestPending:Coreponent;
      
      protected var _statusIconBuddyMyrequestDeclined:Coreponent;
      
      protected var _statusIconClanGreen:Coreponent;
      
      protected var _statusIconClanRed:Coreponent;
      
      protected var _buttonAddContactToGroup:Button;
      
      protected var _buttonRemoveContactRequest:Button;
      
      protected var _buttonAcceptContact:Button;
      
      protected var _buttonDeclineContact:Button;
      
      protected var _buttonUnblockContact:Button;
      
      protected var _buttonWhisperContact:Button;
      
      private var _whisperUnreadDot:Sprite;
      
      protected var __hitLayer__:Coreponent;
      
      public function ContactListItemDataAssigner()
      {
         super();
         _mouseEnabled = true;
         _mouseChildrenEnabled = true;
         initialize();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._statusIconBuddyOffline = getChildByName("statusIcon_buddy_offline") as Coreponent;
         this._statusIconBuddyOnline = getChildByName("statusIcon_buddy_online") as Coreponent;
         this._statusIconBuddyOnMap = getChildByName("statusIcon_buddy_on_map") as Coreponent;
         this._statusIconBuddyPending = getChildByName("statusIcon_buddy_pending") as Coreponent;
         this._statusIconBuddyBlocked = getChildByName("statusIcon_buddy_blocked") as Coreponent;
         this._statusIconBuddyMyrequestPending = getChildByName("statusIcon_buddy_myrequest_pending") as Coreponent;
         this._statusIconBuddyMyrequestDeclined = getChildByName("statusIcon_buddy_myrequest_declined") as Coreponent;
         this._statusIconClanGreen = getChildByName("statusIcon_clan_green") as Coreponent;
         this._statusIconClanRed = getChildByName("statusIcon_clan_red") as Coreponent;
         this.__hitLayer__ = this.hitLayer as Coreponent;
         this.initAddContactToGroupButton();
         this.initRemoveContactRequestButton();
         this.initAcceptContactButton();
         this.initDeclineContactButton();
         this.initBlockContactButton();
         this.initWhisperContactButton();
         this.initWhisperUnreadDot();
         this.hideAllStatusIcons();
         this.addEventListener(MouseEvent.ROLL_OVER,this.handleRollOver);
         this.addEventListener(MouseEvent.ROLL_OUT,this.handleRollOut);
         this.useHandCursor = true;
         this.buttonMode = true;
      }
      
      protected function initAddContactToGroupButton() : void
      {
         this._buttonAddContactToGroup = getChildByName("button_add_contact") as Button;
         this._buttonAddContactToGroup.addEventListener(MouseEvent.CLICK,this.handleAddContactToGroupButtonClickEvent);
      }
      
      protected function initRemoveContactRequestButton() : void
      {
         this._buttonRemoveContactRequest = getChildByName("button_remove_contact") as Button;
         this._buttonRemoveContactRequest.addEventListener(MouseEvent.CLICK,this.handleRemoveContactRequestButtonClickEvent);
      }
      
      protected function initAcceptContactButton() : void
      {
         this._buttonAcceptContact = getChildByName("button_accept_contact") as Button;
         this._buttonAcceptContact.addEventListener(MouseEvent.CLICK,this.handleAcceptContactButtonClickEvent);
      }
      
      protected function initDeclineContactButton() : void
      {
         this._buttonDeclineContact = getChildByName("button_decline_contact") as Button;
         this._buttonDeclineContact.addEventListener(MouseEvent.CLICK,this.handleDeclineContactButtonClickEvent);
      }
      
      protected function initBlockContactButton() : void
      {
         this._buttonUnblockContact = getChildByName("button_unblock_contact") as Button;
         this._buttonUnblockContact.addEventListener(MouseEvent.CLICK,this.handleUnblockContactButtonClickEvent);
      }
      
      protected function initWhisperContactButton() : void
      {
         this._buttonWhisperContact = getChildByName("button_whisper_contact") as Button;
         this.applyWhisperContactButtonSkin();
         this._buttonWhisperContact.addEventListener(MouseEvent.CLICK,this.handleWhisperContactButtonClickEvent);
      }
      
      private function applyWhisperContactButtonSkin() : void
      {
         ChatUIIconSkinFactory.applyTo(this._buttonWhisperContact,ChatUIIconSkinFactory.ICON_MESSAGE);
      }
      
      private function initWhisperUnreadDot() : void
      {
         this._whisperUnreadDot = new Sprite();
         this._whisperUnreadDot.mouseEnabled = false;
         this._whisperUnreadDot.mouseChildren = false;
         this._whisperUnreadDot.graphics.lineStyle(1,16777215);
         this._whisperUnreadDot.graphics.beginFill(16711680);
         this._whisperUnreadDot.graphics.drawCircle(0,0,4);
         this._whisperUnreadDot.graphics.endFill();
         this._whisperUnreadDot.visible = false;
         addChild(this._whisperUnreadDot);
      }
      
      private function handleAddContactToGroupButtonClickEvent(param1:MouseEvent) : void
      {
         var _loc2_:ContactsWindowContactListEntryVO = data as ContactsWindowContactListEntryVO;
         dispatchEvent(new ContactListItemDataAssignerEvent(ContactListItemDataAssignerEvent.INVITE_CONTACT_TO_GROUP,_loc2_));
      }
      
      private function handleRemoveContactRequestButtonClickEvent(param1:MouseEvent) : void
      {
         var _loc2_:ContactsWindowContactListEntryVO = data as ContactsWindowContactListEntryVO;
         if(Boolean(_loc2_) && _loc2_.unreadWhisperCount > 0)
         {
            dispatchEvent(new ContactListItemDataAssignerEvent(ContactListItemDataAssignerEvent.DISMISS_WHISPER,_loc2_));
            return;
         }
         dispatchEvent(new ContactListItemDataAssignerEvent(ContactListItemDataAssignerEvent.REMOVE_CONTACT_REQUEST,_loc2_));
      }
      
      private function handleAcceptContactButtonClickEvent(param1:MouseEvent) : void
      {
         var _loc2_:ContactsWindowContactListEntryVO = data as ContactsWindowContactListEntryVO;
         dispatchEvent(new ContactListItemDataAssignerEvent(ContactListItemDataAssignerEvent.ACCEPT_CONTACT,_loc2_));
      }
      
      private function handleDeclineContactButtonClickEvent(param1:MouseEvent) : void
      {
         var _loc2_:ContactsWindowContactListEntryVO = data as ContactsWindowContactListEntryVO;
         dispatchEvent(new ContactListItemDataAssignerEvent(ContactListItemDataAssignerEvent.DECLINE_CONTACT,_loc2_));
      }
      
      private function handleUnblockContactButtonClickEvent(param1:MouseEvent) : void
      {
         var _loc2_:ContactsWindowContactListEntryVO = data as ContactsWindowContactListEntryVO;
         dispatchEvent(new ContactListItemDataAssignerEvent(ContactListItemDataAssignerEvent.UNBLOCK_CONTACT,_loc2_));
      }
      
      private function handleWhisperContactButtonClickEvent(param1:MouseEvent) : void
      {
         var _loc2_:ContactsWindowContactListEntryVO = data as ContactsWindowContactListEntryVO;
         dispatchEvent(new ContactListItemDataAssignerEvent(ContactListItemDataAssignerEvent.WHISPER_CONTACT,_loc2_));
      }
      
      protected function disposeAddContactToGroupButton() : void
      {
         this._buttonAddContactToGroup.removeEventListener(MouseEvent.CLICK,this.handleAddContactToGroupButtonClickEvent);
         this._buttonAddContactToGroup.dispose();
         this._buttonAddContactToGroup = null;
      }
      
      protected function disposeRemoveContactButton() : void
      {
         this._buttonRemoveContactRequest.removeEventListener(MouseEvent.CLICK,this.handleRemoveContactRequestButtonClickEvent);
         this._buttonRemoveContactRequest.dispose();
         this._buttonRemoveContactRequest = null;
      }
      
      protected function disposeAcceptContactButton() : void
      {
         this._buttonAcceptContact.removeEventListener(MouseEvent.CLICK,this.handleAcceptContactButtonClickEvent);
         this._buttonAcceptContact.dispose();
         this._buttonAcceptContact = null;
      }
      
      protected function disposeDeclineContactButton() : void
      {
         this._buttonDeclineContact.removeEventListener(MouseEvent.CLICK,this.handleDeclineContactButtonClickEvent);
         this._buttonDeclineContact.dispose();
         this._buttonDeclineContact = null;
      }
      
      protected function disposeUnblockContactButton() : void
      {
         this._buttonUnblockContact.removeEventListener(MouseEvent.CLICK,this.handleUnblockContactButtonClickEvent);
         this._buttonUnblockContact.dispose();
         this._buttonUnblockContact = null;
      }
      
      protected function disposeWhisperContactButton() : void
      {
         this._buttonWhisperContact.removeEventListener(MouseEvent.CLICK,this.handleWhisperContactButtonClickEvent);
         this._buttonWhisperContact.dispose();
         this._buttonWhisperContact = null;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:ContactsWindowContactListEntryVO = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         super.data = param1;
         this.hideAllStatusIcons();
         this.hideAllContactAdministrationButtons();
         _loc2_ = param1 as ContactsWindowContactListEntryVO;
         if(_loc2_ == null)
         {
            this.visible = false;
            return;
         }
         this.visible = true;
         this.__hitLayer__.tooltipData = BPLocale.getItem("ttip_contactname_without_chat");
         switch(_loc2_.shownState)
         {
            case ContactsWindowContactListEntryVO.STATE_OFFLINE:
               this._statusIconBuddyPending.visible = true;
               this._statusIconBuddyPending.tooltipData = this.replaceClanAndLevelPlaceholder("ttip_offline_icon",_loc2_);
               this._buttonAddContactToGroup.visible = false;
               this._buttonWhisperContact.visible = false;
               break;
            case ContactsWindowContactListEntryVO.STATE_ONLINE:
               this._statusIconBuddyOnline.visible = true;
               this._statusIconBuddyOnline.tooltipData = this.replaceClanAndLevelPlaceholder("ttip_online_icon",_loc2_);
               this._buttonAddContactToGroup.visible = true;
               this._buttonWhisperContact.visible = true;
               break;
            case ContactsWindowContactListEntryVO.STATE_ON_MAP:
               this._statusIconBuddyOnline.visible = true;
               this._statusIconBuddyOnline.tooltipData = this.replaceClanAndLevelPlaceholder("ttip_same_map_icon",_loc2_);
               this._buttonAddContactToGroup.visible = true;
               this._buttonWhisperContact.visible = true;
               break;
            case ContactsWindowContactListEntryVO.STATE_FRIEND:
               if(_loc2_.online)
               {
                  this._statusIconBuddyOnline.visible = true;
               }
               else
               {
                  this._statusIconBuddyPending.visible = true;
               }
               this._buttonWhisperContact.visible = _loc2_.online;
               break;
            case ContactsWindowContactListEntryVO.STATE_WHISPER:
               this._statusIconBuddyOnMap.visible = true;
               this._buttonWhisperContact.visible = true;
               break;
            case ContactsWindowContactListEntryVO.STATE_PENDING:
               this._statusIconBuddyMyrequestPending.visible = true;
               this._buttonAcceptContact.visible = true;
               this._buttonDeclineContact.visible = true;
               this._buttonWhisperContact.visible = true;
               _loc4_ = this.replaceClanAndLevelPlaceholder("ttip_pending_request_icon",_loc2_);
               this.__hitLayer__.tooltipData = _loc4_;
               this._statusIconBuddyMyrequestPending.tooltipData = _loc4_;
               break;
            case ContactsWindowContactListEntryVO.STATE_BLOCK:
               this._statusIconBuddyOffline.visible = true;
               this._statusIconBuddyOffline.tooltipData = this.replaceClanAndLevelPlaceholder("ttip_blocked_icon",_loc2_);
               this._buttonUnblockContact.visible = true;
               this.__hitLayer__.tooltipData = BPLocale.getItem("userInfo_action_blacklistUserListed");
               break;
            case ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_PENDING:
               this._statusIconBuddyMyrequestPending.visible = true;
               this._statusIconBuddyMyrequestPending.tooltipData = this.replaceClanAndLevelPlaceholder("ttip_sent_request_pending_icon",_loc2_);
               this._buttonRemoveContactRequest.visible = true;
               this._buttonWhisperContact.visible = true;
               break;
            case ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_DECLINED:
               this._statusIconBuddyMyrequestDeclined.visible = true;
               this._statusIconBuddyMyrequestDeclined.tooltipData = this.replaceClanAndLevelPlaceholder("ttip_sent_request_declined_icon",_loc2_);
               this._buttonRemoveContactRequest.visible = true;
               this.__hitLayer__.tooltipData = this.replaceClanAndLevelPlaceholder("ttip_sent_request_icon",_loc2_);
         }
         if(_loc2_.hasState(ContactsWindowContactListEntryVO.STATE_FRIEND) && _loc2_.online && !_loc2_.hasState(ContactsWindowContactListEntryVO.STATE_BLOCK))
         {
            this._buttonWhisperContact.visible = true;
         }
         if(_loc2_.unreadWhisperCount > 0 && this._buttonWhisperContact.visible)
         {
            this._buttonAddContactToGroup.visible = false;
            this._buttonRemoveContactRequest.visible = true;
            this._buttonRemoveContactRequest.tooltipData = BPLocale.getItemInCategory("chat","chat_dismiss_message");
         }
         else if(_loc2_.shownState == ContactsWindowContactListEntryVO.STATE_WHISPER || _loc2_.hasState(ContactsWindowContactListEntryVO.STATE_FRIEND))
         {
            this._buttonAddContactToGroup.visible = true;
         }
         switch(_loc2_.clanRelation)
         {
            case ContactsWindowContactListEntryVO.CLAN_ENEMY:
               this._statusIconClanRed.visible = true;
               this._statusIconClanRed.tooltipData = _loc3_ = this.replaceClanAndLevelPlaceholder("ttip_clan_enemy_icon",_loc2_);
               break;
            case ContactsWindowContactListEntryVO.CLAN_FRIENDLY:
               this._statusIconClanGreen.visible = true;
               this._statusIconClanGreen.tooltipData = this.replaceClanAndLevelPlaceholder("ttip_clan_friendly_icon",_loc2_);
               break;
            case ContactsWindowContactListEntryVO.CLAN_MINE:
               _loc3_ = this.replaceClanAndLevelPlaceholder("ttip_clan_neutral_icon",_loc2_);
         }
         if(_loc2_.isClanMemberShit())
         {
            this._statusIconClanGreen.visible = true;
            this._statusIconClanGreen.tooltipData = this.replaceClanAndLevelPlaceholder("ttip_clan_neutral_icon",_loc2_);
         }
         this.drawSelection();
         label.text = _loc2_.username;
         label.forceRedraw(InvalidationType.TEXT);
         this._whisperUnreadDot.visible = _loc2_.unreadWhisperCount > 0 && this._buttonWhisperContact.visible;
         this.positionWhisperButton();
         this.positionMessageActionButton();
      }
      
      override protected function draw() : void
      {
         super.draw();
         this.positionWhisperButton();
         this.positionMessageActionButton();
      }
      
      private function positionMessageActionButton() : void
      {
         var _loc1_:ContactsWindowContactListEntryVO = data as ContactsWindowContactListEntryVO;
         if(!_loc1_ || !this._buttonAddContactToGroup || !this._buttonRemoveContactRequest)
         {
            return;
         }
         if(this._buttonAddContactToGroup.visible && _loc1_.unreadWhisperCount == 0 && (_loc1_.shownState == ContactsWindowContactListEntryVO.STATE_WHISPER || _loc1_.hasState(ContactsWindowContactListEntryVO.STATE_FRIEND)))
         {
            this._buttonAddContactToGroup.x = this._buttonRemoveContactRequest.x;
         }
      }
      
      private function positionWhisperButton() : void
      {
         if(!this._buttonWhisperContact || !label || !label.skin)
         {
            return;
         }
         var _loc1_:LabelSkin = label.skin as LabelSkin;
         if(!_loc1_ || !_loc1_.textField)
         {
            return;
         }
         var _loc2_:Number = label.x;
         var _loc3_:Number = _loc2_ + _loc1_.textField.textWidth + 7;
         var _loc4_:Number = Math.max(_loc2_,width - this._buttonWhisperContact.width - 44);
         this._buttonWhisperContact.x = Math.min(_loc3_,_loc4_);
         this.positionWhisperUnreadDot();
      }
      
      private function positionWhisperUnreadDot() : void
      {
         if(!this._whisperUnreadDot || !this._buttonWhisperContact)
         {
            return;
         }
         this._whisperUnreadDot.x = Math.min(width - 5,this._buttonWhisperContact.x + this._buttonWhisperContact.width - 3);
         this._whisperUnreadDot.y = 4;
         setChildIndex(this._whisperUnreadDot,numChildren - 1);
      }
      
      protected function replaceClanAndLevelPlaceholder(param1:String, param2:ContactsWindowContactListEntryVO) : String
      {
         var _loc4_:String = null;
         var _loc3_:String = BPLocale.getItem(param1);
         _loc3_ = _loc3_.replace(LEVEL_PLACEHOLDER,param2.level);
         if(param2.clanTag != null)
         {
            _loc4_ = BPLocale.getItem("ttip_clanplaceholder");
            _loc4_ = "- " + _loc4_ + ": ";
            _loc3_ = _loc3_.replace(CLAN_PLACEHOLDER,_loc4_);
            _loc3_ = _loc3_.replace(CLANTAG_PLACEHOLDER,param2.clanTag);
         }
         else
         {
            _loc3_ = _loc3_.replace(CLAN_PLACEHOLDER,"");
            _loc3_ = _loc3_.replace(CLANTAG_PLACEHOLDER,"");
         }
         return _loc3_;
      }
      
      protected function hideAllStatusIcons() : void
      {
         this._statusIconBuddyOffline.transform.colorTransform = new ColorTransform();
         this._statusIconBuddyOnline.transform.colorTransform = new ColorTransform();
         this._statusIconBuddyOnMap.transform.colorTransform = new ColorTransform();
         this._statusIconBuddyPending.transform.colorTransform = new ColorTransform();
         this._statusIconBuddyOffline.visible = false;
         this._statusIconBuddyOnline.visible = false;
         this._statusIconBuddyOnMap.visible = false;
         this._statusIconBuddyPending.visible = false;
         this._statusIconBuddyBlocked.visible = false;
         this._statusIconBuddyMyrequestPending.visible = false;
         this._statusIconBuddyMyrequestDeclined.visible = false;
         this._statusIconClanGreen.visible = false;
         this._statusIconClanRed.visible = false;
      }
      
      protected function hideAllContactAdministrationButtons() : void
      {
         this._buttonRemoveContactRequest.tooltipData = BPLocale.getItem("ttip_remove_contact_button");
         this._buttonAddContactToGroup.visible = false;
         this._buttonRemoveContactRequest.visible = false;
         this._buttonAcceptContact.visible = false;
         this._buttonDeclineContact.visible = false;
         this._buttonUnblockContact.visible = false;
         this._buttonWhisperContact.visible = false;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._statusIconBuddyOffline = null;
         this._statusIconBuddyOnline = null;
         this._statusIconBuddyOnMap = null;
         this._statusIconBuddyPending = null;
         this.disposeAddContactToGroupButton();
         this.disposeRemoveContactButton();
         this.disposeAcceptContactButton();
         this.disposeDeclineContactButton();
         this.disposeUnblockContactButton();
         this.disposeWhisperContactButton();
         if(Boolean(this._whisperUnreadDot) && Boolean(this._whisperUnreadDot.parent))
         {
            this._whisperUnreadDot.parent.removeChild(this._whisperUnreadDot);
         }
         this._whisperUnreadDot = null;
      }
      
      private function handleRollOut(param1:MouseEvent) : void
      {
         hitLayer.alpha = 0;
      }
      
      private function handleRollOver(param1:MouseEvent) : void
      {
         hitLayer.alpha = 0.5;
      }
      
      protected function handleMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:ContactsWindowContactListEntryVO = data as ContactsWindowContactListEntryVO;
         dispatchEvent(new ContactListItemDataAssignerEvent(ContactListItemDataAssignerEvent.ICON_CLICKED,_loc2_));
      }
      
      override protected function drawSelection() : void
      {
         if(_selected)
         {
            label.alpha = 0.5;
         }
         else
         {
            label.alpha = 1;
         }
      }
   }
}

