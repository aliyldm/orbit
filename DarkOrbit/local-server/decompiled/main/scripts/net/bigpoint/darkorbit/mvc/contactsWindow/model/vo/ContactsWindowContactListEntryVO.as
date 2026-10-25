package net.bigpoint.darkorbit.mvc.contactsWindow.model.vo
{
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class ContactsWindowContactListEntryVO
   {
      
      public static const STATE_NONE:uint = 0;
      
      public static const STATE_ONLINE:uint = 1;
      
      public static const STATE_OFFLINE:uint = 2;
      
      public static const STATE_ON_MAP:uint = 3;
      
      public static const STATE_PENDING:uint = 4;
      
      public static const STATE_BLOCK:uint = 5;
      
      public static const STATE_OUTGOING_REQUEST_PENDING:uint = 6;
      
      public static const STATE_OUTGOING_REQUEST_DECLINED:uint = 7;
      
      public static const STATE_FRIEND:uint = 8;
      
      public static const STATE_WHISPER:uint = 9;
      
      public static const CLAN_NONE:uint = 1;
      
      public static const CLAN_FRIENDLY:uint = 2;
      
      public static const CLAN_ENEMY:uint = 3;
      
      public static const CLAN_NEUTRAL:uint = 4;
      
      public static const CLAN_MINE:uint = 5;
      
      private var _userID:int;
      
      private var _mapID:int;
      
      private var _level:int;
      
      private var _shownState:uint;
      
      private var _clanRelation:uint;
      
      private var _clanTag:String;
      
      private var _factionId:String;
      
      private var _isClanmember:Boolean = false;
      
      private var _online:Boolean;
      
      private var _unreadWhisperCount:int;
      
      private var _stateList:Vector.<uint> = new Vector.<uint>();
      
      private var _username:String;
      
      public function ContactsWindowContactListEntryVO(param1:String = null, param2:uint = 0, param3:int = -1, param4:int = -1, param5:Vector.<uint> = null, param6:uint = 1, param7:Boolean = false, param8:String = null, param9:String = null)
      {
         super();
         this._username = param1;
         this._shownState = param2;
         this._userID = param3;
         this._mapID = param4;
         if(param5)
         {
            this._stateList = param5;
         }
         this._clanRelation = param6;
         this._online = param7;
         this._clanTag = param8;
         this._factionId = param9;
      }
      
      public function set username(param1:String) : void
      {
         this._username = param1;
      }
      
      public function get username() : String
      {
         return this._username;
      }
      
      public function set shownState(param1:uint) : void
      {
         this._shownState = param1;
      }
      
      public function get shownState() : uint
      {
         return this._shownState;
      }
      
      public function set userID(param1:int) : void
      {
         this._userID = param1;
      }
      
      public function get userID() : int
      {
         return this._userID;
      }
      
      public function set mapID(param1:int) : void
      {
         this._mapID = param1;
      }
      
      public function get mapID() : int
      {
         return this._mapID;
      }
      
      public function set level(param1:int) : void
      {
         this._level = param1;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function set clanRelation(param1:int) : void
      {
         this._clanRelation = param1;
      }
      
      public function get clanRelation() : int
      {
         return this._clanRelation;
      }
      
      public function set clanTag(param1:String) : void
      {
         this._clanTag = param1;
      }
      
      public function get clanTag() : String
      {
         return this._clanTag;
      }
      
      public function set factionId(param1:String) : void
      {
         this._factionId = param1;
      }
      
      public function get factionId() : String
      {
         return this._factionId;
      }
      
      public function addStateToList(param1:uint) : void
      {
         this._stateList.push(param1);
      }
      
      public function removeStateFromeList(param1:uint) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._stateList.length)
         {
            if(this._stateList[_loc2_] == param1)
            {
               this._stateList.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public function hasState(param1:uint) : Boolean
      {
         var _loc2_:int = 0;
         for each(_loc2_ in this._stateList)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function clearStateList() : void
      {
         this._stateList = new Vector.<uint>();
      }
      
      public function getStateList() : Vector.<uint>
      {
         return this._stateList;
      }
      
      public function set online(param1:Boolean) : void
      {
         this._online = param1;
      }
      
      public function get online() : Boolean
      {
         return this._online;
      }
      
      public function set unreadWhisperCount(param1:int) : void
      {
         this._unreadWhisperCount = Math.max(0,param1);
      }
      
      public function get unreadWhisperCount() : int
      {
         return this._unreadWhisperCount;
      }
      
      public function updateShownState() : void
      {
         if(this.hasState(STATE_BLOCK))
         {
            this.shownState = ContactsWindowContactListEntryVO.STATE_BLOCK;
         }
         else if(this.hasState(STATE_WHISPER) && !this.hasState(STATE_FRIEND) && !this.isClanMemberShit())
         {
            this.shownState = ContactsWindowContactListEntryVO.STATE_WHISPER;
         }
         else if(!this.online)
         {
            this.shownState = ContactsWindowContactListEntryVO.STATE_OFFLINE;
         }
         else if(Settings.mapID == this.mapID)
         {
            this.shownState = ContactsWindowContactListEntryVO.STATE_ON_MAP;
         }
         else
         {
            this.shownState = ContactsWindowContactListEntryVO.STATE_ONLINE;
         }
      }
      
      public function isClanMemberShit() : Boolean
      {
         return this._isClanmember;
      }
      
      public function set isClanmember(param1:Boolean) : void
      {
         this._isClanmember = param1;
      }
      
      public function clone() : ContactsWindowContactListEntryVO
      {
         var _loc1_:Vector.<uint> = null;
         _loc1_ = this.getStateList();
         if(_loc1_)
         {
            _loc1_ = _loc1_.slice();
         }
         var _loc2_:ContactsWindowContactListEntryVO = new ContactsWindowContactListEntryVO(this.username,this.shownState,this.userID,this.mapID,_loc1_,this.clanRelation,this.online,this.clanTag,this.factionId);
         _loc2_.unreadWhisperCount = this.unreadWhisperCount;
         return _loc2_;
      }
   }
}

