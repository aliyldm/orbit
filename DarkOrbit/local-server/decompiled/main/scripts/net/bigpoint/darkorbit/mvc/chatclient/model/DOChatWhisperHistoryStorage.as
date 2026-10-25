package net.bigpoint.darkorbit.mvc.chatclient.model
{
   import flash.net.SharedObject;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.mvc.chatclient.model.backend.ChatSettings;
   
   public class DOChatWhisperHistoryStorage
   {
      
      private static var _sharedObject:SharedObject;
      
      private static var _ownerKey:String;
      
      public static const MAX_MESSAGES:int = 200;
      
      private static const SHARED_OBJECT_NAME:String = "chatMessage";
      
      private static const HISTORIES_KEY:String = "histories";
      
      private static var _messages:Vector.<DOChatMessageVO> = new Vector.<DOChatMessageVO>(0);
      
      private static var _knownMessages:Dictionary = new Dictionary(true);
      
      public function DOChatWhisperHistoryStorage()
      {
         super();
      }
      
      public static function getMessages() : Vector.<DOChatMessageVO>
      {
         ensureLoaded();
         return _messages.slice();
      }
      
      public static function addMessage(param1:DOChatMessageVO) : void
      {
         if(!isWhisperMessage(param1))
         {
            return;
         }
         ensureLoaded();
         if(_knownMessages[param1])
         {
            return;
         }
         _knownMessages[param1] = true;
         _messages.push(param1);
         trimMessages();
         save();
      }
      
      public static function removeConversation(param1:String) : Boolean
      {
         var _loc5_:DOChatMessageVO = null;
         if(!param1)
         {
            return false;
         }
         ensureLoaded();
         var _loc2_:String = param1.toLowerCase();
         var _loc3_:Boolean = false;
         var _loc4_:* = int(_messages.length - 1);
         while(_loc4_ >= 0)
         {
            _loc5_ = _messages[_loc4_];
            if(isMessageForUser(_loc5_,_loc2_))
            {
               _messages.splice(_loc4_,1);
               delete _knownMessages[_loc5_];
               _loc3_ = true;
            }
            _loc4_--;
         }
         if(_loc3_)
         {
            save();
         }
         return _loc3_;
      }
      
      public static function getConversationUsers() : Vector.<DOChatUserVO>
      {
         var _loc3_:DOChatMessageVO = null;
         var _loc4_:Vector.<DOChatUserVO> = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         ensureLoaded();
         var _loc1_:Object = {};
         var _loc2_:Array = [];
         for each(_loc3_ in _messages)
         {
            if(!(!_loc3_ || !_loc3_.user || !_loc3_.user.username))
            {
               _loc6_ = _loc3_.user.username.toLowerCase();
               if(!_loc1_[_loc6_])
               {
                  _loc2_.push(_loc6_);
               }
               _loc1_[_loc6_] = mergeUserData(_loc1_[_loc6_] as DOChatUserVO,_loc3_.user);
            }
         }
         _loc4_ = new Vector.<DOChatUserVO>(0);
         for each(_loc5_ in _loc2_)
         {
            _loc4_.push(_loc1_[_loc5_] as DOChatUserVO);
         }
         return _loc4_;
      }
      
      public static function getUserByName(param1:String) : DOChatUserVO
      {
         var _loc3_:DOChatUserVO = null;
         if(!param1)
         {
            return null;
         }
         var _loc2_:String = param1.toLowerCase();
         for each(_loc3_ in getConversationUsers())
         {
            if(Boolean(_loc3_) && Boolean(_loc3_.username) && _loc3_.username.toLowerCase() == _loc2_)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      private static function ensureLoaded() : void
      {
         var histories:Object = null;
         var storedMessages:Array = null;
         var storedMessage:Object = null;
         var message:DOChatMessageVO = null;
         var currentOwnerKey:String = getCurrentOwnerKey();
         if(Boolean(_sharedObject) && _ownerKey == currentOwnerKey)
         {
            return;
         }
         _ownerKey = currentOwnerKey;
         _messages = new Vector.<DOChatMessageVO>(0);
         _knownMessages = new Dictionary(true);
         try
         {
            _sharedObject = SharedObject.getLocal(SHARED_OBJECT_NAME);
            histories = _sharedObject.data[HISTORIES_KEY];
            storedMessages = histories ? histories[_ownerKey] as Array : null;
            if(!storedMessages)
            {
               return;
            }
            for each(storedMessage in storedMessages)
            {
               message = deserializeMessage(storedMessage);
               if(message)
               {
                  _knownMessages[message] = true;
                  _messages.push(message);
               }
            }
            trimMessages();
         }
         catch(error:Error)
         {
            _sharedObject = null;
         }
      }
      
      private static function save() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Array = null;
         var _loc3_:DOChatMessageVO = null;
         if(!_sharedObject)
         {
            return;
         }
         try
         {
            _loc1_ = _sharedObject.data[HISTORIES_KEY];
            if(!_loc1_)
            {
               _loc1_ = {};
               _sharedObject.data[HISTORIES_KEY] = _loc1_;
            }
            if(_messages.length == 0)
            {
               delete _loc1_[_ownerKey];
            }
            else
            {
               _loc2_ = [];
               for each(_loc3_ in _messages)
               {
                  _loc2_.push(serializeMessage(_loc3_));
               }
               _loc1_[_ownerKey] = _loc2_;
            }
            _sharedObject.flush();
         }
         catch(error:Error)
         {
         }
      }
      
      private static function trimMessages() : void
      {
         var _loc1_:DOChatMessageVO = null;
         while(_messages.length > MAX_MESSAGES)
         {
            _loc1_ = _messages.shift();
            delete _knownMessages[_loc1_];
         }
      }
      
      private static function serializeMessage(param1:DOChatMessageVO) : Object
      {
         var _loc2_:DOChatUserVO = param1.user;
         return {
            "m":param1.message,
            "t":param1.whisperType,
            "s":param1.timestamp,
            "u":{
               "n":(_loc2_ ? _loc2_.username : ""),
               "r":(_loc2_ ? _loc2_.usertype : DOChatUserVO.TYPE_USER),
               "c":(_loc2_ ? _loc2_.clanTag : ""),
               "g":(_loc2_ ? _loc2_.globalID : null),
               "i":(_loc2_ ? _loc2_.userId : null),
               "a":(_loc2_ ? _loc2_.avatarUrl : null),
               "f":(_loc2_ ? _loc2_.factionId : null)
            }
         };
      }
      
      private static function deserializeMessage(param1:Object) : DOChatMessageVO
      {
         if(!param1 || !isWhisperType(param1.t) || param1.m == null || !param1.u)
         {
            return null;
         }
         var _loc2_:Object = param1.u;
         var _loc3_:String = _loc2_.n == null ? "" : String(_loc2_.n);
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:DOChatUserVO = DOChatUserVO.createUser(_loc3_,_loc2_.r == null ? DOChatUserVO.TYPE_USER : String(_loc2_.r),_loc2_.c == null ? "" : String(_loc2_.c),_loc2_.g == null ? null : String(_loc2_.g),_loc2_.i == null ? null : String(_loc2_.i),_loc2_.a == null ? null : String(_loc2_.a),_loc2_.f == null ? null : String(_loc2_.f));
         var _loc5_:Object = param1.s != null ? param1.s : (param1.timestamp != null ? param1.timestamp : param1.time);
         var _loc6_:Number = _loc5_ == null ? NaN : Number(_loc5_);
         return new DOChatMessageVO(String(param1.m),_loc4_,String(param1.t),false,_loc6_);
      }
      
      private static function isWhisperMessage(param1:DOChatMessageVO) : Boolean
      {
         return Boolean(param1) && isWhisperType(param1.whisperType);
      }
      
      private static function isMessageForUser(param1:DOChatMessageVO, param2:String) : Boolean
      {
         return isWhisperMessage(param1) && param1.user && Boolean(param1.user.username) && param1.user.username.toLowerCase() == param2;
      }
      
      private static function isWhisperType(param1:Object) : Boolean
      {
         return param1 == DOChatMessageVO.WHISPER_TYPE_YOU || param1 == DOChatMessageVO.WHISPER_TYPE_THEY;
      }
      
      private static function mergeUserData(param1:DOChatUserVO, param2:DOChatUserVO) : DOChatUserVO
      {
         if(!param1)
         {
            return param2;
         }
         if(!param2)
         {
            return param1;
         }
         return new DOChatUserVO(param2.username || param1.username,param2.usertype || param1.usertype || DOChatUserVO.TYPE_USER,param2.clanTag || param1.clanTag,param2.globalID || param1.globalID,param2.userId || param1.userId,param2.avatarUrl || param1.avatarUrl,param2.factionId || param1.factionId);
      }
      
      private static function getCurrentOwnerKey() : String
      {
         if(Hero.userID > 0)
         {
            return "user_" + Hero.userID;
         }
         var _loc1_:String = ChatSettings.userName ? ChatSettings.userName.toLowerCase() : "unknown";
         return "name_" + _loc1_;
      }
   }
}

