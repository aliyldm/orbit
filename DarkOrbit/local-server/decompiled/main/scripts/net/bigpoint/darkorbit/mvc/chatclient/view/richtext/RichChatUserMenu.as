package net.bigpoint.darkorbit.mvc.chatclient.view.richtext
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.InvitationModeModule;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatUserVO;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.ContactsWindowProxy;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowContactListEntryVO;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.GroupMember;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.proxy.GroupProxy;
   
   public class RichChatUserMenu extends Sprite
   {
      
      public static const ADD_FRIEND:String = "addFriend";
      
      public static const GROUP_INVITE:String = "groupInvite";
      
      public static const WHISPER:String = "whisper";
      
      public static const REPORT:String = "report";
      
      public static const ADD_TO_BLACKLIST:String = "addToBlacklist";
      
      private static const MENU_WIDTH:Number = 142;
      
      private static const ITEM_HEIGHT:Number = 24;
      
      private static const DESCRIPTION_HEIGHT:Number = 0;
      
      private static const BORDER_OVERLAP:Number = 1;
      
      private var _user:DOChatUserVO;
      
      private var _items:Vector.<RichChatUserMenuItem> = new Vector.<RichChatUserMenuItem>(0);
      
      private var _isFriend:Boolean;
      
      private var _isFriendRequest:Boolean;
      
      private var _isBlocked:Boolean;
      
      private var _isClanMember:Boolean;
      
      private var _isOnline:Boolean;
      
      public function RichChatUserMenu(param1:DOChatUserVO)
      {
         super();
         this._user = param1;
         mouseEnabled = true;
         this.build();
      }
      
      private function get relationshipDescription() : String
      {
         if(this._isBlocked)
         {
            return "Blacklisted";
         }
         if(this._isFriend)
         {
            return "Friend · " + (this._isOnline ? "Online" : "Offline");
         }
         if(this._isClanMember)
         {
            return "Clan Member · " + (this._isOnline ? "Online" : "Offline");
         }
         if(this._isFriendRequest)
         {
            return "Friend Request Pending";
         }
         return "Player";
      }
      
      private function build() : void
      {
         var _loc2_:Array = null;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:RichChatUserMenuItem = null;
         this.readContactState();
         var _loc1_:Array = [];
         if(!this._isFriend && !this._isFriendRequest && !this._isBlocked)
         {
            _loc1_.push([ADD_FRIEND,BPLocale.getItemInCategory("chat","chat_add_friend")]);
         }
         if(!this._isBlocked && this.canInviteToGroup())
         {
            _loc1_.push([GROUP_INVITE,BPLocale.getItemInCategory("chat","chat_group_invite")]);
         }
         if(!this._isBlocked)
         {
            _loc1_.push([WHISPER,BPLocale.getItemInCategory("chat","chat_chat_whisper")]);
         }
         _loc1_.push([ADD_TO_BLACKLIST,this._isBlocked ? BPLocale.getItemInCategory("chat","chat_remove_blacklist") : BPLocale.getItemInCategory("chat","chat_add_blacklist")]);
         _loc1_.push([REPORT,BPLocale.getItemInCategory("chat","chat_chat_report")]);
         for each(_loc2_ in _loc1_)
         {
            _loc5_ = new RichChatUserMenuItem(String(_loc2_[0]),String(_loc2_[1]));
            this._items.push(_loc5_);
         }
         _loc3_ = DESCRIPTION_HEIGHT + ITEM_HEIGHT + (_loc1_.length - 1) * (ITEM_HEIGHT - BORDER_OVERLAP);
         graphics.lineStyle(1,42441,1);
         graphics.beginFill(400677,0.96);
         graphics.drawRect(0,0,MENU_WIDTH,_loc3_);
         graphics.endFill();
         _loc4_ = 0;
         while(_loc4_ < this._items.length)
         {
            _loc5_ = this._items[_loc4_];
            _loc5_.setSize(MENU_WIDTH,ITEM_HEIGHT);
            _loc5_.y = DESCRIPTION_HEIGHT + _loc4_ * (ITEM_HEIGHT - BORDER_OVERLAP);
            _loc5_.addEventListener(MouseEvent.CLICK,this.handleItemClick);
            addChild(_loc5_);
            _loc4_++;
         }
      }
      
      private function readContactState() : void
      {
         var _loc2_:ContactsWindowContactListEntryVO = null;
         var _loc1_:ContactsWindowProxy = GameFacade.getInstance().retrieveProxy(ContactsWindowProxy.NAME) as ContactsWindowProxy;
         if(!_loc1_ || !_loc1_.model)
         {
            return;
         }
         for each(_loc2_ in _loc1_.model.listEntries)
         {
            if(this.isSameUser(_loc2_))
            {
               this._isFriend = this._isFriend || _loc2_.hasState(ContactsWindowContactListEntryVO.STATE_FRIEND);
               this._isFriendRequest = this._isFriendRequest || _loc2_.hasState(ContactsWindowContactListEntryVO.STATE_PENDING) || _loc2_.hasState(ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_PENDING) || _loc2_.hasState(ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_DECLINED);
               this._isBlocked = this._isBlocked || _loc2_.hasState(ContactsWindowContactListEntryVO.STATE_BLOCK);
               this._isClanMember = this._isClanMember || _loc2_.isClanMemberShit();
               this._isOnline = this._isOnline || _loc2_.online;
            }
         }
      }
      
      private function isSameUser(param1:ContactsWindowContactListEntryVO) : Boolean
      {
         var _loc2_:Number = Number(this._user.userId);
         return !isNaN(_loc2_) && _loc2_ > 0 && param1.userID == int(_loc2_) || param1.username && this._user.username && param1.username.toLowerCase() == this._user.username.toLowerCase();
      }
      
      private function canInviteToGroup() : Boolean
      {
         var _loc2_:GroupMember = null;
         var _loc1_:GroupProxy = GameFacade.getInstance().retrieveProxy(GroupProxy.NAME) as GroupProxy;
         if(!_loc1_ || !_loc1_.group)
         {
            return true;
         }
         for each(_loc2_ in _loc1_.group.members)
         {
            if(this.isSameGroupMember(_loc2_))
            {
               return false;
            }
         }
         return !_loc1_.isInGroup() || _loc1_.group.heroIsBoss || _loc1_.group.invitationBehavior == InvitationModeModule.INVITATIONMODE_FREE_FOR_ALL;
      }
      
      private function isSameGroupMember(param1:GroupMember) : Boolean
      {
         var _loc2_:Number = Number(this._user.userId);
         return !isNaN(_loc2_) && _loc2_ > 0 && param1.id == int(_loc2_) || param1.nickName && this._user.username && param1.nickName.toLowerCase() == this._user.username.toLowerCase();
      }
      
      private function createDescription() : TextField
      {
         var _loc1_:TextField = new TextField();
         _loc1_.mouseEnabled = false;
         _loc1_.multiline = true;
         _loc1_.wordWrap = false;
         _loc1_.width = MENU_WIDTH - 12;
         _loc1_.height = DESCRIPTION_HEIGHT - 4;
         _loc1_.x = 6;
         _loc1_.y = 3;
         _loc1_.defaultTextFormat = new TextFormat("Verdana",10,15327936,true);
         _loc1_.text = this._user.toString() + "\n" + this.relationshipDescription;
         return _loc1_;
      }
      
      private function handleItemClick(param1:MouseEvent) : void
      {
         var _loc2_:RichChatUserMenuItem = param1.currentTarget as RichChatUserMenuItem;
         if(_loc2_)
         {
            dispatchEvent(new RichChatUserMenuEvent(RichChatUserMenuEvent.ACTION,this._user,_loc2_.action,null,true));
         }
      }
   }
}

