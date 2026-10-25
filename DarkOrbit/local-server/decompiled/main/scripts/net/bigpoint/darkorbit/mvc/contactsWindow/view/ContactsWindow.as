package net.bigpoint.darkorbit.mvc.contactsWindow.view
{
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBox;
   import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBoxEvent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.core.skins.SkinLayerNames;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollEvent;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.input.Input;
   import net.bigpoint.darkorbit.fui.components.text.input.InputEvent;
   import net.bigpoint.darkorbit.fui.components.text.input.validators.TextLengthInputValidator;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowContactListEntryVO;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowFilterSettingsVO;
   import net.bigpoint.darkorbit.mvc.contactsWindow.view.components.list.ContactListItemDataAssigner;
   import net.bigpoint.darkorbit.mvc.contactsWindow.view.components.list.ContactListItemDataAssignerEvent;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   
   public class ContactsWindow extends Sprite
   {
      
      private var _simpleWindow:IWindow;
      
      private var _windowContentContainer:DisplayObjectContainer;
      
      private var _contactsControlsContainer:DisplayObjectContainer;
      
      private var _showContacts:CheckBox;
      
      private var _showContactsDesc:Label;
      
      private var _showClanmembers:CheckBox;
      
      private var _showClanmembersDesc:Label;
      
      private var _showRequests:CheckBox;
      
      private var _showRequestsDesc:Label;
      
      private var _showBlacklisted:CheckBox;
      
      private var _showBlacklistedDesc:Label;
      
      private var _selectedUsername:Input;
      
      private var _inviteButton:Button;
      
      private var _removeButton:Button;
      
      private var _blockButton:Button;
      
      private var _itemlist:ItemList;
      
      private var _scrollbar:Scrollbar;
      
      private var _slider:Button;
      
      private var _cachedItemlistContent:Vector.<ContactsWindowContactListEntryVO> = new Vector.<ContactsWindowContactListEntryVO>();
      
      private var _blockAllNotifications:CheckBox;
      
      private var _blockAllNotificationsDesc:Label;
      
      public function ContactsWindow(param1:IWindow)
      {
         super();
         this._simpleWindow = param1;
      }
      
      public function handleWindowContentCreated() : void
      {
         if(this.numChildren > 0)
         {
            this._windowContentContainer = this.getChildByName("windowContentContainer") as DisplayObjectContainer;
            if(this._windowContentContainer)
            {
               this._contactsControlsContainer = this._windowContentContainer.getChildByName("contactContentContainer") as DisplayObjectContainer;
               this._showContacts = this._contactsControlsContainer.getChildByName("showContacts") as CheckBox;
               this._showContactsDesc = this._contactsControlsContainer.getChildByName("showContactsDesc") as Label;
               this._showContactsDesc.text = BPLocale.getItem("display_contacts");
               this._showContacts.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleContactsCheckBoxStateChanged);
               this._showRequests = this._contactsControlsContainer.getChildByName("showRequests") as CheckBox;
               this._showRequestsDesc = this._contactsControlsContainer.getChildByName("showRequestsDesc") as Label;
               this._showRequestsDesc.text = BPLocale.getItem("display_requests");
               this._showRequests.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleRequestsCheckBoxStateChanged);
               this._showBlacklisted = this._contactsControlsContainer.getChildByName("showBlacklisted") as CheckBox;
               this._showBlacklistedDesc = this._contactsControlsContainer.getChildByName("showBlacklistedDesc") as Label;
               this._showBlacklistedDesc.text = BPLocale.getItem("display_blacklist");
               this._showBlacklisted.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleBlacklistedCheckBoxStateChanged);
               this._showClanmembers = this._contactsControlsContainer.getChildByName("showClanmembers") as CheckBox;
               this._showClanmembersDesc = this._contactsControlsContainer.getChildByName("showClanmembersDesc") as Label;
               this._showClanmembersDesc.text = BPLocale.getItemInCategory("","company_hierarchy_desc_clan");
               this._showClanmembers.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleClanmembersCheckBoxStateChanged);
               this._selectedUsername = this._contactsControlsContainer.getChildByName("selectedUsername") as Input;
               this._selectedUsername.addEventListener(Event.CHANGE,this.handleUsernameInputChanged);
               this._selectedUsername.addEventListener(FocusEvent.FOCUS_IN,this.selectedUsernameFocusedHandler);
               this._selectedUsername.addEventListener(FocusEvent.FOCUS_OUT,this.selectedUsernameUnfocusedHandler);
               this._selectedUsername.addEventListener(InputEvent.INPUT_IS_VALID,this.handleUsernameInputIsValid);
               this._selectedUsername.addEventListener(InputEvent.INPUT_IS_INVALID,this.handleUsernameInputIsInvalid);
               this._selectedUsername.validator = new TextLengthInputValidator();
               this._inviteButton = this._contactsControlsContainer.getChildByName("inviteButton") as Button;
               this._inviteButton.addEventListener(MouseEvent.CLICK,this.addCurrentlySelectedContact);
               this._removeButton = this._contactsControlsContainer.getChildByName("removeButton") as Button;
               this._removeButton.addEventListener(MouseEvent.CLICK,this.removeCurrentlySelectedContact);
               this._blockButton = this._contactsControlsContainer.getChildByName("blockButton") as Button;
               this._blockButton.addEventListener(MouseEvent.CLICK,this.blockCurrentlySelectedContact);
               this._itemlist = this._contactsControlsContainer.getChildByName("contactItemlist") as ItemList;
               this._itemlist.itemDataAssigner = ContactListItemDataAssigner;
               this._itemlist.scrollMouseSpeed = 160;
               this._itemlist.addEventListener(ItemListEvent.CLICKED,this.handleItemSelected);
               this._itemlist.addEventListener(ContactListItemDataAssignerEvent.ICON_CLICKED,this.handleStateIconClicked);
               this._itemlist.addEventListener(ContactListItemDataAssignerEvent.ACCEPT_CONTACT,this.handleAcceptContactEvent);
               this._itemlist.addEventListener(ContactListItemDataAssignerEvent.DECLINE_CONTACT,this.handleDeclineContactEvent);
               this._itemlist.addEventListener(ContactListItemDataAssignerEvent.UNBLOCK_CONTACT,this.handleUnblockEvent);
               this._itemlist.addEventListener(ContactListItemDataAssignerEvent.INVITE_CONTACT_TO_GROUP,this.handleInviteContactToGroupEvent);
               this._itemlist.addEventListener(ContactListItemDataAssignerEvent.REMOVE_CONTACT_REQUEST,this.handleRemoveContactRequestEvent);
               this._itemlist.addEventListener(ContactListItemDataAssignerEvent.WHISPER_CONTACT,this.handleWhisperContactEvent);
               this._itemlist.addEventListener(ContactListItemDataAssignerEvent.DISMISS_WHISPER,this.handleDismissWhisperEvent);
               this._itemlist.addEventListener(ScrollEvent.SCROLLCONTAINER_VERTICAL_SIZE_CHANGED,this.handleItemlistSizeChangeEvent);
               this._itemlist.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleItemlistMouseWheelEvent);
               this._itemlist.list = new VectorCollection(this._cachedItemlistContent);
               this._itemlist.forceRedraw(InvalidationType.SIZE);
               this._itemlist.forceRedraw(InvalidationType.POSITION);
               this._scrollbar = this._contactsControlsContainer.getChildByName("scrollbar") as Scrollbar;
               this._slider = this._scrollbar.getChildByName("buttonSlider") as Button;
               this._scrollbar.addEventListener(ScrollEvent.SCROLL_POSITION_CHANGED,this.handleScrollbarPositionChangeEvent);
               this._blockAllNotifications = this._contactsControlsContainer.getChildByName("hideNotifications") as CheckBox;
               this._blockAllNotificationsDesc = this._contactsControlsContainer.getChildByName("hideNotificationsDesc") as Label;
               this._blockAllNotificationsDesc.text = BPLocale.getItem("block_all_notifications");
               this._blockAllNotifications.addEventListener(MouseEvent.CLICK,this.handleBlockNotificationsCheckBoxStateChanged);
            }
            this.checkUserInputControlsActivation();
         }
         this._simpleWindow.addEventListener(SimpleWindowEvent.ON_RESIZE,this.handleWindowResized);
         this.handleWindowResized();
      }
      
      private function checkUserInputControlsActivation() : void
      {
         if(this._selectedUsername.validator.isValid())
         {
            this._inviteButton.enabled = true;
            this._removeButton.enabled = true;
            this._blockButton.enabled = true;
            TweenMax.to(this._inviteButton,0.5,{"colorMatrixFilter":{"saturation":1}});
            TweenMax.to(this._removeButton,0.5,{"colorMatrixFilter":{"saturation":1}});
            TweenMax.to(this._blockButton,0.5,{"colorMatrixFilter":{"saturation":1}});
         }
         else
         {
            this._inviteButton.enabled = false;
            this._removeButton.enabled = false;
            this._blockButton.enabled = false;
            TweenMax.to(this._inviteButton,0.5,{"colorMatrixFilter":{"saturation":0.2}});
            TweenMax.to(this._removeButton,0.5,{"colorMatrixFilter":{"saturation":0.2}});
            TweenMax.to(this._blockButton,0.5,{"colorMatrixFilter":{"saturation":0.2}});
         }
      }
      
      private function selectedUsernameFocusedHandler(param1:FocusEvent) : void
      {
         dispatchEvent(new ContactsWindowEvent(ContactsWindowEvent.USERNAME_INPUTFIELD_GAINED_FOCUS));
      }
      
      private function selectedUsernameUnfocusedHandler(param1:FocusEvent) : void
      {
         dispatchEvent(new ContactsWindowEvent(ContactsWindowEvent.USERNAME_INPUTFIELD_LOST_FOCUS));
      }
      
      private function handleUsernameInputIsValid(param1:InputEvent) : void
      {
         this.handleUsernameInputChanged();
      }
      
      private function handleUsernameInputIsInvalid(param1:InputEvent) : void
      {
         this.handleUsernameInputChanged();
      }
      
      private function handleUsernameInputChanged(param1:Event = null) : void
      {
         var _loc2_:DisplayObject = this._selectedUsername.skin.getSkinLayer(SkinLayerNames.NORMAL);
         if(!this._selectedUsername.text || this._selectedUsername.text.length == 0 || this._selectedUsername.validator.isValid())
         {
            TweenMax.to(_loc2_,0.5,{"colorMatrixFilter":{
               "colorize":16711680,
               "amount":0,
               "contrast":1,
               "brightness":1
            }});
         }
         else
         {
            TweenMax.to(_loc2_,0.5,{"colorMatrixFilter":{
               "colorize":16711680,
               "amount":1,
               "contrast":1.1,
               "brightness":1.1
            }});
         }
         this.checkUserInputControlsActivation();
      }
      
      private function handleBlockNotificationsCheckBoxStateChanged(param1:MouseEvent) : void
      {
         dispatchEvent(new ContactsWindowEvent(ContactsWindowEvent.BLOCK_NOTIFICATIONS_CHECKBOX_STATE_CHANGED,[this._blockAllNotifications.selection]));
      }
      
      private function handleContactsCheckBoxStateChanged(param1:CheckBoxEvent) : void
      {
         dispatchEvent(new ContactsWindowEvent(ContactsWindowEvent.FILTER_CHECKBOX_STATE_CHANGED,[ContactsWindowEvent.CONTACTS_CHECKBOX,param1.selected]));
      }
      
      private function handleRequestsCheckBoxStateChanged(param1:CheckBoxEvent) : void
      {
         dispatchEvent(new ContactsWindowEvent(ContactsWindowEvent.FILTER_CHECKBOX_STATE_CHANGED,[ContactsWindowEvent.REQUESTS_CHECKBOX,param1.selected]));
      }
      
      private function handleClanmembersCheckBoxStateChanged(param1:CheckBoxEvent) : void
      {
         dispatchEvent(new ContactsWindowEvent(ContactsWindowEvent.FILTER_CHECKBOX_STATE_CHANGED,[ContactsWindowEvent.CLANMEMBERS_CHECKBOX,param1.selected]));
      }
      
      private function handleBlacklistedCheckBoxStateChanged(param1:CheckBoxEvent) : void
      {
         dispatchEvent(new ContactsWindowEvent(ContactsWindowEvent.FILTER_CHECKBOX_STATE_CHANGED,[ContactsWindowEvent.BLACKLISTED_CHECKBOX,param1.selected]));
      }
      
      private function handleItemlistMouseWheelEvent(param1:MouseEvent) : void
      {
         if(this._scrollbar)
         {
            this._scrollbar.updateScrollPositionByScrollDelta(param1.delta);
         }
      }
      
      private function handleItemlistSizeChangeEvent(param1:ScrollEvent) : void
      {
         var _loc2_:Number = param1.viewSize;
         var _loc3_:Number = param1.contentSize;
         if(this._scrollbar)
         {
            this._scrollbar.updateBySizes(_loc2_,_loc3_);
         }
      }
      
      private function handleScrollbarPositionChangeEvent(param1:ScrollEvent) : void
      {
         var _loc2_:Number = NaN;
         if(this._scrollbar)
         {
            _loc2_ = this._scrollbar.getScrollPositionInPercent();
            this._itemlist.setScrollPositionInPercent(_loc2_);
         }
      }
      
      private function handleWindowResized(param1:SimpleWindowEvent = null) : void
      {
         this._windowContentContainer.height = this._simpleWindow.height - 10;
         this._windowContentContainer.width = this._simpleWindow.width - 4;
      }
      
      private function handleStateIconClicked(param1:ContactListItemDataAssignerEvent) : void
      {
      }
      
      private function addCurrentlySelectedContact(param1:Event) : void
      {
         dispatchEvent(new ContactsWindowEvent(ContactsWindowEvent.INVITE_CLICKED));
      }
      
      private function removeCurrentlySelectedContact(param1:Event) : void
      {
         dispatchEvent(new ContactsWindowEvent(ContactsWindowEvent.REMOVE_CLICKED));
      }
      
      private function blockCurrentlySelectedContact(param1:Event) : void
      {
         dispatchEvent(new ContactsWindowEvent(ContactsWindowEvent.BLOCK_CLICKED));
      }
      
      private function handleInviteContactToGroupEvent(param1:ContactListItemDataAssignerEvent) : void
      {
         dispatchEvent(new ContactsWindowEvent(ContactsWindowEvent.INVITE_TO_GROUP_CLICKED,[param1.data.userID]));
      }
      
      private function handleRemoveContactRequestEvent(param1:ContactListItemDataAssignerEvent) : void
      {
         dispatchEvent(new ContactsWindowEvent(ContactsWindowEvent.REMOVE_OUTGOING_REQUEST_CLICKED,[param1.data.userID]));
      }
      
      private function handleAcceptContactEvent(param1:ContactListItemDataAssignerEvent) : void
      {
         dispatchEvent(new ContactsWindowEvent(ContactsWindowEvent.ACCEPT_PENDING_REQUEST_CLICKED,[param1.data.userID]));
      }
      
      private function handleDeclineContactEvent(param1:ContactListItemDataAssignerEvent) : void
      {
         dispatchEvent(new ContactsWindowEvent(ContactsWindowEvent.DECLINE_PENDING_REQUEST_CLICKED,[param1.data.userID]));
      }
      
      private function handleUnblockEvent(param1:ContactListItemDataAssignerEvent) : void
      {
         dispatchEvent(new ContactsWindowEvent(ContactsWindowEvent.UNBLOCK_USER_CLICKED,[param1.data.userID]));
      }
      
      private function handleWhisperContactEvent(param1:ContactListItemDataAssignerEvent) : void
      {
         dispatchEvent(new ContactsWindowEvent(ContactsWindowEvent.WHISPER_CLICKED,[param1.data.username,param1.data.userID,param1.data.clanTag,param1.data.factionId]));
      }
      
      private function handleDismissWhisperEvent(param1:ContactListItemDataAssignerEvent) : void
      {
         dispatchEvent(new ContactsWindowEvent(ContactsWindowEvent.DISMISS_WHISPER_CLICKED,[param1.data.username,param1.data.userID]));
      }
      
      public function createItemlist(param1:Vector.<ContactsWindowContactListEntryVO>) : void
      {
         if(this._itemlist)
         {
            this._itemlist.list = new VectorCollection(param1);
         }
         else
         {
            this._cachedItemlistContent = param1;
         }
      }
      
      protected function handleItemSelected(param1:ItemListEvent) : void
      {
         var _loc2_:ContactsWindowContactListEntryVO = param1.itemVO as ContactsWindowContactListEntryVO;
         dispatchEvent(new ContactsWindowEvent(ContactsWindowEvent.CONTACT_CLICKED,[_loc2_.userID,_loc2_.username]));
      }
      
      public function getSelectedUsernameFieldText() : String
      {
         return this._selectedUsername.getDisplayedText();
      }
      
      public function alterFilterCheckBoxStates(param1:ContactsWindowFilterSettingsVO) : void
      {
         this._showContacts.selection = param1.showContacts;
         this._showClanmembers.selection = param1.showClanMembers;
         this._showRequests.selection = param1.showRequests;
         this._showBlacklisted.selection = param1.showBlocked;
      }
      
      public function alterBlockNotificationsCheckBoxState(param1:Boolean) : void
      {
         this._blockAllNotifications.selection = param1;
      }
      
      public function updateDescriptionLabels(param1:Array) : void
      {
         this._showContactsDesc.text = BPLocale.getItem("display_contacts") + " " + param1[0] + "/" + param1[1];
         this._showClanmembersDesc.text = BPLocale.getItemInCategory("","company_hierarchy_desc_clan") + " " + param1[2] + "/" + param1[3];
         this._showRequestsDesc.text = BPLocale.getItem("display_requests") + " " + param1[4];
         this._showBlacklistedDesc.text = BPLocale.getItem("display_blacklist") + " " + param1[5];
      }
      
      public function updateSelectedUsernameTo(param1:String) : void
      {
         this._selectedUsername.text = param1;
         this._selectedUsername.forceRedraw();
         this.checkUserInputControlsActivation();
      }
      
      public function showBlockOverlay() : void
      {
         this._simpleWindow.showInProgressOverlay();
      }
      
      public function hideBlockOverlay() : void
      {
         this._simpleWindow.hideInProgressOverlay();
      }
   }
}

