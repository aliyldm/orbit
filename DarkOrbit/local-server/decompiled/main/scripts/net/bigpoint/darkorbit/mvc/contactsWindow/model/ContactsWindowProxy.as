package net.bigpoint.darkorbit.mvc.contactsWindow.model
{
   import com.greensock.TweenLite;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.com.module.ContactListBlockInvitationsModule;
   import net.bigpoint.darkorbit.com.module.ContactRequest;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatUserVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatWhisperHistoryStorage;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.contactsWindow.ContactsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowContactListEntryVO;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowContactListVO;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowFilterSettingsVO;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class ContactsWindowProxy extends Proxy
   {
      
      public static const NAME:String = "ContactsWindowContactListProxy";
      
      private static const orderedStateVector:Vector.<uint> = new <uint>[ContactsWindowContactListEntryVO.STATE_ON_MAP,ContactsWindowContactListEntryVO.STATE_ONLINE,ContactsWindowContactListEntryVO.STATE_WHISPER,ContactsWindowContactListEntryVO.STATE_BLOCK,ContactsWindowContactListEntryVO.STATE_PENDING,ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_PENDING,ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_DECLINED,ContactsWindowContactListEntryVO.STATE_OFFLINE];
      
      private static const orderedClanVector:Vector.<uint> = new <uint>[ContactsWindowContactListEntryVO.CLAN_MINE,ContactsWindowContactListEntryVO.CLAN_FRIENDLY,ContactsWindowContactListEntryVO.CLAN_NEUTRAL,ContactsWindowContactListEntryVO.CLAN_NONE,ContactsWindowContactListEntryVO.CLAN_ENEMY];
      
      private var _showContacts:Boolean = true;
      
      private var _showClanmembers:Boolean = true;
      
      private var _showRequests:Boolean = true;
      
      private var _showBlocked:Boolean = false;
      
      private var userIDtoEntryVO:Dictionary = new Dictionary();
      
      private var _blockAllNotifications:Boolean = false;
      
      private var _selectedUser:ContactsWindowContactListEntryVO = null;
      
      private var _nextLocalContactID:int = -1;
      
      private var _serverReadyForRequest:Boolean = true;
      
      public function ContactsWindowProxy(param1:ContactsWindowContactListVO = null)
      {
         super(NAME,param1);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      public function updateSelectedUserTo(param1:ContactsWindowContactListEntryVO) : void
      {
         this._selectedUser = param1;
      }
      
      public function unblockRequestSending() : void
      {
         this._serverReadyForRequest = true;
      }
      
      public function inviteSelectedUser(param1:String) : void
      {
         var _loc2_:ContactsWindowContactListEntryVO = null;
         var _loc3_:ContactsWindowContactListEntryVO = null;
         if(!this._serverReadyForRequest)
         {
            return;
         }
         var _loc4_:int = -1;
         if(Boolean(this._selectedUser && param1) && Boolean(this._selectedUser.username) && param1.toLowerCase() == this._selectedUser.username.toLowerCase())
         {
            _loc4_ = this._selectedUser.userID;
         }
         if(this.model)
         {
            _loc2_ = this.findMatchingEntry(this.model.listEntries,param1,_loc4_,false);
            if(!_loc2_)
            {
               _loc2_ = this.findMatchingEntry(this.model.listEntries,param1,_loc4_);
            }
         }
         _loc3_ = _loc2_ ? _loc2_ : (_loc4_ > 0 ? this._selectedUser : null);
         if(Boolean(_loc2_) && _loc2_.hasState(ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_PENDING))
         {
            return;
         }
         this._serverReadyForRequest = false;
         sendNotification(ContactsWindowNotifications.WAIT_FOR_SERVER_UNBLOCK);
         if(Boolean(_loc2_) && _loc2_.hasState(ContactsWindowContactListEntryVO.STATE_PENDING))
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ContactRequest(_loc2_.username,_loc2_.userID,ContactRequest.CONTACTREQUESTTYPE_PENDING_REQUEST_ACCEPT));
         }
         else if(Boolean(_loc3_) && _loc3_.userID > 0)
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ContactRequest(_loc3_.username,_loc3_.userID,ContactRequest.CONTACTREQUESTTYPE_FRIEND_REQUEST_CREATE));
         }
         else
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ContactRequest(param1,0,ContactRequest.CONTACTREQUESTTYPE_FRIEND_REQUEST_CREATE));
         }
      }
      
      public function removeSelectedUser(param1:String) : void
      {
         if(!this._serverReadyForRequest)
         {
            return;
         }
         this._serverReadyForRequest = false;
         sendNotification(ContactsWindowNotifications.WAIT_FOR_SERVER_UNBLOCK);
         if(Boolean(this._selectedUser) && param1 == this._selectedUser.username)
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ContactRequest(this._selectedUser.username,this._selectedUser.userID,ContactRequest.CONTACTREQUESTTYPE_FRIEND_REMOVE));
         }
         else
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ContactRequest(param1,0,ContactRequest.CONTACTREQUESTTYPE_FRIEND_REMOVE));
         }
      }
      
      public function blockSelectedUser(param1:String) : void
      {
         if(!this._serverReadyForRequest)
         {
            return;
         }
         this._serverReadyForRequest = false;
         sendNotification(ContactsWindowNotifications.WAIT_FOR_SERVER_UNBLOCK);
         if(Boolean(this._selectedUser) && param1 == this._selectedUser.username)
         {
            if(!this.isUserNameOnBlacklist(param1))
            {
               sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ContactRequest(this._selectedUser.username,this._selectedUser.userID,ContactRequest.CONTACTREQUESTTYPE_BLACKLIST_ADD_CONTACT));
            }
            else
            {
               sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ContactRequest(this._selectedUser.username,this._selectedUser.userID,ContactRequest.CONTACTREQUESTTYPE_BLACKLIST_REMOVE_CONTACT));
            }
         }
         else if(!this.isUserNameOnBlacklist(param1))
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ContactRequest(param1,0,ContactRequest.CONTACTREQUESTTYPE_BLACKLIST_ADD_CONTACT));
         }
         else
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ContactRequest(param1,0,ContactRequest.CONTACTREQUESTTYPE_BLACKLIST_REMOVE_CONTACT));
         }
      }
      
      private function isUserNameOnBlacklist(param1:String) : Boolean
      {
         return this.isUserBlacklisted(param1);
      }
      
      public function isUserBlacklisted(param1:String, param2:int = -1) : Boolean
      {
         var _loc3_:ContactsWindowContactListEntryVO = null;
         if(!this.model)
         {
            return false;
         }
         for each(_loc3_ in this.model.listEntries)
         {
            if(_loc3_.hasState(ContactsWindowContactListEntryVO.STATE_BLOCK))
            {
               if(param2 > 0 && _loc3_.userID == param2 || Boolean(_loc3_.username && param1) && Boolean(_loc3_.username.toLowerCase() == param1.toLowerCase()))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function handleMapjump() : void
      {
         var _loc1_:ContactsWindowContactListEntryVO = null;
         if(this.model == null)
         {
            return;
         }
         for each(_loc1_ in this.model.listEntries)
         {
            _loc1_.updateShownState();
         }
         this.resendDataToView();
      }
      
      public function addWhisperContact(param1:String, param2:int = -1, param3:String = null, param4:String = null, param5:Boolean = true, param6:Boolean = true) : void
      {
         if(!param1)
         {
            return;
         }
         if(!this.model)
         {
            this.model = new ContactsWindowContactListVO(new Vector.<ContactsWindowContactListEntryVO>());
         }
         var _loc7_:ContactsWindowContactListEntryVO = this.findMatchingEntry(this.model.listEntries,param1,param2,false);
         if((Boolean(_loc7_)) && this.isEstablishedContact(_loc7_))
         {
            this.mergeWhisperEntryIntoContact(_loc7_);
            if(param4)
            {
               _loc7_.factionId = param4;
            }
            if(param5)
            {
               ++_loc7_.unreadWhisperCount;
            }
            if(param6)
            {
               this.resendDataToView();
            }
            return;
         }
         var _loc8_:ContactsWindowContactListEntryVO = this.findWhisperOnlyEntry(this.model.listEntries,param1,param2);
         if(_loc8_)
         {
            if(param4)
            {
               _loc8_.factionId = param4;
            }
            if(param5)
            {
               ++_loc8_.unreadWhisperCount;
            }
            if(param6)
            {
               this.resendDataToView();
            }
            return;
         }
         _loc8_ = new ContactsWindowContactListEntryVO(param1,ContactsWindowContactListEntryVO.STATE_WHISPER,param2,-1,null,ContactsWindowContactListEntryVO.CLAN_NONE,false,param3,param4);
         _loc8_.addStateToList(ContactsWindowContactListEntryVO.STATE_WHISPER);
         _loc8_.unreadWhisperCount = param5 ? 1 : 0;
         this.model.listEntries.push(_loc8_);
         if(param2 > 0 && !this.userIDtoEntryVO[param2])
         {
            this.userIDtoEntryVO[param2] = _loc8_;
         }
         if(param6)
         {
            this.resendDataToView();
         }
      }
      
      public function clearWhisperUnread(param1:String, param2:int = -1) : void
      {
         var _loc4_:ContactsWindowContactListEntryVO = null;
         if(!this.model)
         {
            return;
         }
         var _loc3_:Boolean = false;
         for each(_loc4_ in this.model.listEntries)
         {
            if((Boolean(param2 > 0 && _loc4_.userID == param2) || Boolean(param1 && _loc4_.username == param1)) && _loc4_.unreadWhisperCount > 0)
            {
               _loc4_.unreadWhisperCount = 0;
               _loc3_ = true;
            }
         }
         if(_loc3_)
         {
            this.resendDataToView();
         }
      }
      
      public function markOutgoingRequestDeclined(param1:String) : void
      {
         if(!param1)
         {
            return;
         }
         if(!this.model)
         {
            this.model = new ContactsWindowContactListVO(new Vector.<ContactsWindowContactListEntryVO>());
         }
         var _loc2_:int = -1;
         if(Boolean(this._selectedUser) && Boolean(this._selectedUser.username) && this._selectedUser.username.toLowerCase() == param1.toLowerCase())
         {
            _loc2_ = this._selectedUser.userID;
         }
         var _loc3_:ContactsWindowContactListEntryVO = this.findMatchingEntry(this.model.listEntries,param1,_loc2_,false);
         if(!_loc3_)
         {
            _loc3_ = Boolean(this._selectedUser) && _loc2_ > 0 ? this._selectedUser : new ContactsWindowContactListEntryVO(param1,ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_DECLINED,this._nextLocalContactID--);
            this.model.listEntries.push(_loc3_);
         }
         if(_loc3_.hasState(ContactsWindowContactListEntryVO.STATE_FRIEND))
         {
            return;
         }
         _loc3_.removeStateFromeList(ContactsWindowContactListEntryVO.STATE_PENDING);
         _loc3_.removeStateFromeList(ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_PENDING);
         if(!_loc3_.hasState(ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_DECLINED))
         {
            _loc3_.addStateToList(ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_DECLINED);
         }
         _loc3_.shownState = ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_DECLINED;
         if(_loc3_.userID > 0)
         {
            this.userIDtoEntryVO[_loc3_.userID] = _loc3_;
         }
         this.resendDataToView();
      }
      
      public function handleUpdateContactsFromServer(param1:Vector.<ContactsWindowContactListEntryVO>) : void
      {
         var _loc2_:ContactsWindowContactListEntryVO = null;
         var _loc3_:ContactsWindowContactListEntryVO = null;
         var _loc4_:int = 0;
         for each(_loc2_ in param1)
         {
            _loc3_ = this.userIDtoEntryVO[_loc2_.userID] as ContactsWindowContactListEntryVO;
            if(_loc3_ == null && Boolean(this.model))
            {
               _loc3_ = this.findMatchingEntry(this.model.listEntries,_loc2_.username,_loc2_.userID);
            }
            if(_loc3_ == null || this.isWhisperOnlyEntry(_loc3_))
            {
               if(!this.model)
               {
                  this.model = new ContactsWindowContactListVO(new Vector.<ContactsWindowContactListEntryVO>());
               }
               if(this.isWhisperOnlyEntry(_loc3_) && this.isEstablishedContact(_loc2_))
               {
                  _loc2_.unreadWhisperCount += _loc3_.unreadWhisperCount;
                  if(!_loc2_.factionId)
                  {
                     _loc2_.factionId = _loc3_.factionId;
                  }
                  _loc4_ = this.model.listEntries.indexOf(_loc3_);
                  if(_loc4_ >= 0)
                  {
                     this.model.listEntries.splice(_loc4_,1);
                  }
               }
               this.userIDtoEntryVO[_loc2_.userID] = _loc2_;
               this.model.listEntries.push(_loc2_);
            }
            else
            {
               _loc3_.updateShownState();
               this.mergeWhisperEntryIntoContact(_loc3_);
            }
         }
         this.resendDataToView();
      }
      
      public function handleUpdateContactAttributesFromServer(param1:ContactsWindowContactListEntryVO) : void
      {
         var _loc2_:ContactsWindowContactListEntryVO = this.userIDtoEntryVO[param1.userID] as ContactsWindowContactListEntryVO;
         if(_loc2_ == null)
         {
            return;
         }
         _loc2_.updateShownState();
         this.resendDataToView();
      }
      
      public function handleUpdateContactTypesFromServer(param1:ContactsWindowContactListEntryVO) : void
      {
         var _loc2_:ContactsWindowContactListEntryVO = this.userIDtoEntryVO[param1.userID] as ContactsWindowContactListEntryVO;
         if(_loc2_ == null)
         {
            return;
         }
         _loc2_.updateShownState();
         this.mergeWhisperEntryIntoContact(_loc2_);
         this.resendDataToView();
      }
      
      public function handleNewContactListFromServer(param1:ContactsWindowContactListVO) : void
      {
         var _loc4_:ContactsWindowContactListEntryVO = null;
         var _loc5_:ContactsWindowContactListEntryVO = null;
         var _loc6_:ContactsWindowContactListEntryVO = null;
         var _loc2_:Vector.<ContactsWindowContactListEntryVO> = this.model ? this.model.listEntries.slice() : new Vector.<ContactsWindowContactListEntryVO>(0);
         var _loc3_:Dictionary = new Dictionary();
         for each(_loc4_ in param1.listEntries)
         {
            _loc5_ = this.findMatchingEntry(_loc2_,_loc4_.username,_loc4_.userID,false);
            if(_loc5_)
            {
               _loc4_.unreadWhisperCount = _loc5_.unreadWhisperCount;
               if(!_loc4_.factionId)
               {
                  _loc4_.factionId = _loc5_.factionId;
               }
               _loc3_[_loc5_] = true;
            }
            _loc6_ = this.findWhisperOnlyEntry(_loc2_,_loc4_.username,_loc4_.userID);
            if((Boolean(_loc6_)) && this.isEstablishedContact(_loc4_))
            {
               _loc4_.unreadWhisperCount += _loc6_.unreadWhisperCount;
               if(!_loc4_.factionId)
               {
                  _loc4_.factionId = _loc6_.factionId;
               }
               _loc3_[_loc6_] = true;
            }
         }
         for each(_loc5_ in _loc2_)
         {
            if(!_loc3_[_loc5_] && this.isWhisperOnlyEntry(_loc5_))
            {
               param1.listEntries.push(_loc5_);
            }
         }
         this.userIDtoEntryVO = new Dictionary();
         this.model = param1;
         this.restoreCachedWhisperContacts();
         this.resendDataToView();
      }
      
      private function restoreCachedWhisperContacts() : void
      {
         var _loc1_:DOChatUserVO = null;
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         for each(_loc1_ in DOChatWhisperHistoryStorage.getConversationUsers())
         {
            if(!(!_loc1_ || !_loc1_.username))
            {
               _loc2_ = Number(_loc1_.userId);
               _loc3_ = isNaN(_loc2_) || _loc2_ <= 0 ? -1 : int(_loc2_);
               if(!this.isUserBlacklisted(_loc1_.username,_loc3_))
               {
                  this.addWhisperContact(_loc1_.username,_loc3_,_loc1_.clanTag,_loc1_.factionId,false,false);
               }
            }
         }
      }
      
      private function findMatchingEntry(param1:Vector.<ContactsWindowContactListEntryVO>, param2:String, param3:int, param4:Boolean = true) : ContactsWindowContactListEntryVO
      {
         var _loc5_:ContactsWindowContactListEntryVO = null;
         for each(_loc5_ in param1)
         {
            if(!(!param4 && this.isWhisperOnlyEntry(_loc5_) || !this.isSameUser(_loc5_,param2,param3)))
            {
               if(this.isSameUser(_loc5_,param2,param3))
               {
                  return _loc5_;
               }
            }
         }
         return null;
      }
      
      private function findWhisperOnlyEntry(param1:Vector.<ContactsWindowContactListEntryVO>, param2:String, param3:int) : ContactsWindowContactListEntryVO
      {
         var _loc4_:ContactsWindowContactListEntryVO = null;
         for each(_loc4_ in param1)
         {
            if(this.isWhisperOnlyEntry(_loc4_) && this.isSameUser(_loc4_,param2,param3))
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      private function isSameUser(param1:ContactsWindowContactListEntryVO, param2:String, param3:int) : Boolean
      {
         return param3 > 0 && param1.userID == param3 || param1.username && param2 && param1.username.toLowerCase() == param2.toLowerCase();
      }
      
      private function isWhisperOnlyEntry(param1:ContactsWindowContactListEntryVO) : Boolean
      {
         return param1 && param1.hasState(ContactsWindowContactListEntryVO.STATE_WHISPER) && !param1.hasState(ContactsWindowContactListEntryVO.STATE_FRIEND) && !param1.isClanMemberShit() && !this.isInvitationEntry(param1) && !param1.hasState(ContactsWindowContactListEntryVO.STATE_BLOCK);
      }
      
      private function isInvitationEntry(param1:ContactsWindowContactListEntryVO) : Boolean
      {
         return Boolean(param1) && (param1.hasState(ContactsWindowContactListEntryVO.STATE_PENDING) || param1.hasState(ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_PENDING) || param1.hasState(ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_DECLINED));
      }
      
      private function isEstablishedContact(param1:ContactsWindowContactListEntryVO) : Boolean
      {
         return Boolean(param1) && (param1.hasState(ContactsWindowContactListEntryVO.STATE_FRIEND) || param1.isClanMemberShit());
      }
      
      private function mergeWhisperEntryIntoContact(param1:ContactsWindowContactListEntryVO) : void
      {
         var _loc3_:int = 0;
         if(!this.model || !this.isEstablishedContact(param1))
         {
            return;
         }
         var _loc2_:ContactsWindowContactListEntryVO = this.findWhisperOnlyEntry(this.model.listEntries,param1.username,param1.userID);
         while(Boolean(_loc2_) && _loc2_ != param1)
         {
            param1.unreadWhisperCount += _loc2_.unreadWhisperCount;
            if(!param1.factionId)
            {
               param1.factionId = _loc2_.factionId;
            }
            if(param1.userID > 0)
            {
               this.userIDtoEntryVO[param1.userID] = param1;
            }
            if(_loc2_.userID > 0)
            {
               this.userIDtoEntryVO[_loc2_.userID] = param1;
            }
            _loc3_ = this.model.listEntries.indexOf(_loc2_);
            if(_loc3_ >= 0)
            {
               this.model.listEntries.splice(_loc3_,1);
            }
            _loc2_ = this.findWhisperOnlyEntry(this.model.listEntries,param1.username,param1.userID);
         }
      }
      
      private function mergeWhisperEntriesIntoEstablishedContacts() : void
      {
         var _loc2_:ContactsWindowContactListEntryVO = null;
         if(!this.model)
         {
            return;
         }
         var _loc1_:Vector.<ContactsWindowContactListEntryVO> = this.model.listEntries.slice();
         for each(_loc2_ in _loc1_)
         {
            if(this.isEstablishedContact(_loc2_))
            {
               this.mergeWhisperEntryIntoContact(_loc2_);
            }
         }
      }
      
      public function get model() : ContactsWindowContactListVO
      {
         return data as ContactsWindowContactListVO;
      }
      
      public function set model(param1:ContactsWindowContactListVO) : void
      {
         var _loc2_:ContactsWindowContactListEntryVO = null;
         for each(_loc2_ in param1.listEntries)
         {
            if(_loc2_.userID > 0 && (!this.isWhisperOnlyEntry(_loc2_) || !this.userIDtoEntryVO[_loc2_.userID]))
            {
               this.userIDtoEntryVO[_loc2_.userID] = _loc2_;
            }
         }
         data = param1;
      }
      
      private function sortModel(param1:ContactsWindowContactListVO) : ContactsWindowContactListVO
      {
         param1.listEntries.sort(this.compareUsernameEntries);
         param1.listEntries.sort(this.compareEntries);
         return param1;
      }
      
      private function compareEntries(param1:ContactsWindowContactListEntryVO, param2:ContactsWindowContactListEntryVO) : Number
      {
         if(param1.shownState == param2.shownState)
         {
            return orderedClanVector.indexOf(param1.clanRelation) - orderedClanVector.indexOf(param2.clanRelation);
         }
         return orderedStateVector.indexOf(param1.shownState) - orderedStateVector.indexOf(param2.shownState);
      }
      
      private function compareUsernameEntries(param1:ContactsWindowContactListEntryVO, param2:ContactsWindowContactListEntryVO) : Number
      {
         if(param1.username < param2.username)
         {
            return -1;
         }
         if(param1.username > param2.username)
         {
            return 1;
         }
         return 0;
      }
      
      private function filterModel() : ContactsWindowContactListVO
      {
         var _loc1_:ContactsWindowContactListEntryVO = null;
         var _loc3_:ContactsWindowContactListEntryVO = null;
         var _loc2_:Vector.<ContactsWindowContactListEntryVO> = new Vector.<ContactsWindowContactListEntryVO>();
         for each(_loc3_ in this.model.listEntries)
         {
            if(!(!this.showBlocked && _loc3_.hasState(ContactsWindowContactListEntryVO.STATE_BLOCK)))
            {
               if(this.showRequests && _loc3_.hasState(ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_PENDING))
               {
                  _loc1_ = _loc3_.clone();
                  _loc1_.shownState = ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_PENDING;
                  _loc2_.push(_loc1_);
               }
               if(this.showRequests && _loc3_.hasState(ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_DECLINED))
               {
                  _loc1_ = _loc3_.clone();
                  _loc1_.shownState = ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_DECLINED;
                  _loc2_.push(_loc1_);
               }
               if(this.showRequests && _loc3_.hasState(ContactsWindowContactListEntryVO.STATE_PENDING))
               {
                  _loc1_ = _loc3_.clone();
                  _loc1_.shownState = ContactsWindowContactListEntryVO.STATE_PENDING;
                  _loc2_.push(_loc1_);
               }
               if(this.showClanmembers && _loc3_.isClanMemberShit())
               {
                  _loc2_.push(_loc3_);
               }
               else if(this.showContacts && (_loc3_.hasState(ContactsWindowContactListEntryVO.STATE_FRIEND) || _loc3_.hasState(ContactsWindowContactListEntryVO.STATE_WHISPER)))
               {
                  _loc2_.push(_loc3_);
               }
               else if(this.showBlocked && _loc3_.hasState(ContactsWindowContactListEntryVO.STATE_BLOCK))
               {
                  _loc2_.push(_loc3_);
               }
            }
         }
         return new ContactsWindowContactListVO(_loc2_);
      }
      
      public function deleteContacts(param1:Vector.<int>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         for each(_loc2_ in param1)
         {
            if(this.userIDtoEntryVO)
            {
               delete this.userIDtoEntryVO[_loc2_];
            }
            if(this.model)
            {
               _loc3_ = 0;
               while(_loc3_ < this.model.listEntries.length)
               {
                  if(this.model.listEntries[_loc3_].userID == _loc2_)
                  {
                     this.model.listEntries.splice(_loc3_,1);
                  }
                  _loc3_++;
               }
            }
         }
         this.resendDataToView();
      }
      
      public function resendDataToView() : void
      {
         var _loc1_:ContactsWindowContactListVO = null;
         if(this.model)
         {
            this.mergeWhisperEntriesIntoEstablishedContacts();
            _loc1_ = this.filterModel();
            _loc1_ = this.sortModel(_loc1_);
            sendNotification(ContactsWindowNotifications.UPDATED_CONTACTLIST,_loc1_);
         }
         sendNotification(ContactsWindowNotifications.NEW_FILTERSETTINGS_FROM_SERVER,new ContactsWindowFilterSettingsVO(this.showContacts,this.showClanmembers,this.showRequests,this.showBlocked));
         sendNotification(ContactsWindowNotifications.UPDATE_BLOCK_NOTIFICATIONS_FROM_SERVER,this._blockAllNotifications);
         this.countAndSendFilterAmounts();
         sendNotification(ContactsWindowNotifications.WHISPER_UNREAD_CHANGED,this.unreadWhisperUserCount);
      }
      
      public function get totalWhisperUnreadCount() : int
      {
         var _loc2_:ContactsWindowContactListEntryVO = null;
         var _loc1_:int = 0;
         if(!this.model)
         {
            return _loc1_;
         }
         for each(_loc2_ in this.model.listEntries)
         {
            _loc1_ += _loc2_.unreadWhisperCount;
         }
         return _loc1_;
      }
      
      public function get unreadWhisperUserCount() : int
      {
         var _loc3_:ContactsWindowContactListEntryVO = null;
         var _loc4_:String = null;
         var _loc1_:int = 0;
         if(!this.model)
         {
            return _loc1_;
         }
         var _loc2_:Dictionary = new Dictionary();
         for each(_loc3_ in this.model.listEntries)
         {
            if(_loc3_.unreadWhisperCount > 0)
            {
               _loc4_ = _loc3_.username ? _loc3_.username.toLowerCase() : "#" + _loc3_.userID;
               if(!_loc2_[_loc4_])
               {
                  _loc2_[_loc4_] = true;
                  _loc1_++;
               }
            }
         }
         return _loc1_;
      }
      
      private function countAndSendFilterAmounts() : void
      {
         var _loc7_:ContactsWindowContactListEntryVO = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         for each(_loc7_ in this.model.listEntries)
         {
            if(!_loc7_.hasState(ContactsWindowContactListEntryVO.STATE_BLOCK) && _loc7_.hasState(ContactsWindowContactListEntryVO.STATE_FRIEND))
            {
               _loc2_++;
               if(_loc7_.online)
               {
                  _loc1_++;
               }
            }
            if(!_loc7_.hasState(ContactsWindowContactListEntryVO.STATE_BLOCK) && _loc7_.isClanMemberShit())
            {
               _loc4_++;
               if(_loc7_.online)
               {
                  _loc3_++;
               }
            }
            if(_loc7_.hasState(ContactsWindowContactListEntryVO.STATE_PENDING) || _loc7_.hasState(ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_PENDING) || _loc7_.hasState(ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_DECLINED))
            {
               _loc5_++;
            }
            if(_loc7_.hasState(ContactsWindowContactListEntryVO.STATE_BLOCK))
            {
               _loc6_++;
            }
         }
         sendNotification(ContactsWindowNotifications.LIST_AMOUNTS_CHANGED,[_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_]);
      }
      
      public function get showContacts() : Boolean
      {
         return this._showContacts;
      }
      
      public function set showContacts(param1:Boolean) : void
      {
         this._showContacts = param1;
      }
      
      public function get showClanmembers() : Boolean
      {
         return this._showClanmembers;
      }
      
      public function set showClanmembers(param1:Boolean) : void
      {
         this._showClanmembers = param1;
      }
      
      public function get showRequests() : Boolean
      {
         return this._showRequests;
      }
      
      public function set showRequests(param1:Boolean) : void
      {
         this._showRequests = param1;
      }
      
      public function get showBlocked() : Boolean
      {
         return this._showBlocked;
      }
      
      public function set showBlocked(param1:Boolean) : void
      {
         this._showBlocked = param1;
      }
      
      public function updateBlockAllNotificationsFromServer(param1:Boolean) : void
      {
         this._blockAllNotifications = param1;
      }
      
      public function updateBlockAllNotifications(param1:Boolean) : void
      {
         if(!this._serverReadyForRequest)
         {
            TweenLite.delayedCall(5,this.updateBlockAllNotifications,arguments);
            return;
         }
         this._serverReadyForRequest = false;
         sendNotification(ContactsWindowNotifications.WAIT_FOR_SERVER_UNBLOCK);
         this._blockAllNotifications = param1;
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ContactListBlockInvitationsModule(param1));
      }
      
      public function unblockUser(param1:int) : void
      {
         if(!this._serverReadyForRequest)
         {
            return;
         }
         this._serverReadyForRequest = false;
         sendNotification(ContactsWindowNotifications.WAIT_FOR_SERVER_UNBLOCK);
         var _loc2_:String = "";
         if(this.userIDtoEntryVO[param1] != null)
         {
            _loc2_ = (this.userIDtoEntryVO[param1] as ContactsWindowContactListEntryVO).username;
         }
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ContactRequest(_loc2_,param1,ContactRequest.CONTACTREQUESTTYPE_BLACKLIST_REMOVE_CONTACT));
      }
      
      public function removeOutgoingRequest(param1:int) : void
      {
         if(!this._serverReadyForRequest)
         {
            return;
         }
         if(param1 < 0)
         {
            this.deleteContacts(new <int>[param1]);
            return;
         }
         this._serverReadyForRequest = false;
         sendNotification(ContactsWindowNotifications.WAIT_FOR_SERVER_UNBLOCK);
         var _loc2_:String = "";
         if(this.userIDtoEntryVO[param1] != null)
         {
            _loc2_ = (this.userIDtoEntryVO[param1] as ContactsWindowContactListEntryVO).username;
         }
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ContactRequest(_loc2_,param1,ContactRequest.CONTACTREQUESTTYPE_RENDING_REQUEST_REMOVE));
      }
      
      public function acceptPendingRequest(param1:int) : void
      {
         if(!this._serverReadyForRequest)
         {
            return;
         }
         this._serverReadyForRequest = false;
         sendNotification(ContactsWindowNotifications.WAIT_FOR_SERVER_UNBLOCK);
         var _loc2_:String = "";
         if(this.userIDtoEntryVO[param1] != null)
         {
            _loc2_ = (this.userIDtoEntryVO[param1] as ContactsWindowContactListEntryVO).username;
         }
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ContactRequest(_loc2_,param1,ContactRequest.CONTACTREQUESTTYPE_PENDING_REQUEST_ACCEPT));
      }
      
      public function declinePendingRequest(param1:int) : void
      {
         if(!this._serverReadyForRequest)
         {
            return;
         }
         this._serverReadyForRequest = false;
         sendNotification(ContactsWindowNotifications.WAIT_FOR_SERVER_UNBLOCK);
         var _loc2_:String = "";
         if(this.userIDtoEntryVO[param1] != null)
         {
            _loc2_ = (this.userIDtoEntryVO[param1] as ContactsWindowContactListEntryVO).username;
         }
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ContactRequest(_loc2_,param1,ContactRequest.CONTACTREQUESTTYPE_PENDING_REQUEST_DECLINE));
      }
      
      public function getListEntryByUserID(param1:int) : ContactsWindowContactListEntryVO
      {
         return this.userIDtoEntryVO[param1] as ContactsWindowContactListEntryVO;
      }
   }
}

