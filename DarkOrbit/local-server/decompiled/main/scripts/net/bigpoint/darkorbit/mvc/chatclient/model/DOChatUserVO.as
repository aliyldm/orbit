package net.bigpoint.darkorbit.mvc.chatclient.model
{
   import mx.utils.ObjectUtil;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.eventstream.EventStreamClient;
   
   public class DOChatUserVO
   {
      
      public static const TYPE_USER:String = "chatter";
      
      public static const TYPE_DEVELOPER:String = "dev";
      
      public static const TYPE_SUPPORT_LEAD:String = "customerServiceLead";
      
      public static const TYPE_SUPPORTER:String = "customerService";
      
      public static const TYPE_ADMIN:String = "admin";
      
      public static const TYPE_CHAT_MOD:String = "mod";
      
      public static const TYPE_SYSTEM:String = "system";
      
      public static const TYPE_CMD:String = "cmd";
      
      private static const SYS_USER:DOChatUserVO = new DOChatUserVO("",TYPE_SYSTEM,"");
      
      private var _factionId:String;
      
      private var _username:String;
      
      private var _usertype:String;
      
      private var _clanTag:String;
      
      private var _globalID:String;
      
      private var _userId:String;
      
      private var _avatarUrl:String;
      
      public function DOChatUserVO(param1:String, param2:String, param3:String, param4:String = null, param5:String = null, param6:String = null, param7:String = null)
      {
         super();
         this._username = param1;
         this._usertype = param2;
         this._clanTag = param3;
         this._globalID = param4;
         this._userId = param5;
         this._avatarUrl = param6;
         this._factionId = normalizeFactionId(param7);
      }
      
      public static function getDefaultSystemUser() : DOChatUserVO
      {
         return SYS_USER;
      }
      
      public static function getNonameSystemUser() : DOChatUserVO
      {
         return new DOChatUserVO("",TYPE_SYSTEM,"");
      }
      
      public static function fromJson(param1:Object) : DOChatUserVO
      {
         var _loc2_:Object = Boolean(param1) && Boolean(param1.endpointData) ? param1.endpointData : param1 || {};
         var _loc3_:String = _loc2_.userId == null ? "" : String(_loc2_.userId);
         var _loc4_:String = _loc2_.globalId == null ? null : String(_loc2_.globalId);
         if(!_loc4_)
         {
            EventStreamClient.track("flash.achat.error",{
               "error":"Global ID is null on user",
               "json":ObjectUtil.toString(param1)
            });
         }
         return new DOChatUserVO(_loc3_,DOChatUserVO.TYPE_USER,_loc2_.clanTag == null ? "" : String(_loc2_.clanTag),_loc4_,null,readAvatarUrl(_loc2_),normalizeFactionId(_loc2_.factionId));
      }
      
      public static function fromJsonInvite(param1:Object) : DOChatUserVO
      {
         var _loc2_:Object = param1 || {};
         var _loc3_:String = _loc2_.userId == null ? "" : String(_loc2_.userId);
         var _loc4_:String = _loc2_.globalId == null ? null : String(_loc2_.globalId);
         var _loc5_:String = _loc2_.id == null ? null : String(_loc2_.id);
         if(!_loc4_)
         {
            EventStreamClient.track("flash.achat.error",{
               "error":"Global ID is null on invite",
               "json":ObjectUtil.toString(param1)
            });
         }
         return new DOChatUserVO(_loc3_,DOChatUserVO.TYPE_USER,_loc2_.clanTag == null ? "" : String(_loc2_.clanTag),_loc4_,_loc5_,readAvatarUrl(_loc2_),normalizeFactionId(_loc2_.factionId));
      }
      
      public static function getCommandUser(param1:String) : DOChatUserVO
      {
         return new DOChatUserVO(param1,DOChatUserVO.TYPE_CMD,"");
      }
      
      public static function createUser(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String = null, param7:String = null) : DOChatUserVO
      {
         if(param2 == TYPE_SYSTEM)
         {
            return getDefaultSystemUser();
         }
         return new DOChatUserVO(param1,param2,param3,param4,param5,param6,param7);
      }
      
      public static function normalizeFactionId(param1:Object) : String
      {
         if(param1 == null || param1 === "")
         {
            return null;
         }
         var _loc2_:int = int(param1);
         return _loc2_ >= 1 && _loc2_ <= 3 ? String(_loc2_) : null;
      }
      
      private static function readAvatarUrl(param1:Object) : String
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:Object = param1.avatarUrl != null ? param1.avatarUrl : param1.avatar;
         return _loc2_ is String ? String(_loc2_) : null;
      }
      
      public function get username() : String
      {
         if(this._usertype == TYPE_SYSTEM)
         {
            this._username = BPLocale.getItemInCategory("chat","dochat.chat.system");
         }
         return this._username;
      }
      
      public function get usertype() : String
      {
         return this._usertype;
      }
      
      public function get clanTag() : String
      {
         return this._clanTag;
      }
      
      public function get globalID() : String
      {
         return this._globalID;
      }
      
      public function get userId() : String
      {
         return this._userId;
      }
      
      public function get avatarUrl() : String
      {
         return this._avatarUrl;
      }
      
      public function isMod() : Boolean
      {
         switch(this.usertype)
         {
            case TYPE_CHAT_MOD:
            case TYPE_ADMIN:
            case TYPE_DEVELOPER:
               return true;
            default:
               return false;
         }
      }
      
      public function isSystem() : Boolean
      {
         return this.usertype == TYPE_SYSTEM;
      }
      
      public function isSupp() : Boolean
      {
         switch(this.usertype)
         {
            case TYPE_SUPPORT_LEAD:
            case TYPE_SUPPORTER:
            case TYPE_DEVELOPER:
               return true;
            default:
               return false;
         }
      }
      
      public function toString() : String
      {
         return this._clanTag ? "[" + this._clanTag + "]" + this._username : "" + this._username;
      }
      
      public function get factionId() : String
      {
         return this._factionId;
      }
      
      public function set factionId(param1:String) : void
      {
         this._factionId = normalizeFactionId(param1);
      }
   }
}

