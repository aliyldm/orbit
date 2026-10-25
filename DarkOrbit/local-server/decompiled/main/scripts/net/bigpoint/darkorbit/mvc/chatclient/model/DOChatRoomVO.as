package net.bigpoint.darkorbit.mvc.chatclient.model
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.chatclient.model.backend.ChatSettings;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   import org.osflash.signals.Signal;
   
   public class DOChatRoomVO
   {
      
      public static const MAX_MSG:int = 100;
      
      private static const TYPE2NAME:Object = {};
      
      public static const TYPE_GLOBAL:String = "global";
      
      public static const TYPE_NEWBIE:String = "newbie";
      
      public static const TYPE_FACTION:String = "faction";
      
      public static const TYPE_CLAN:String = "clan";
      
      public static const TYPE_GROUP:String = "group";
      
      public static const TYPE_UBA:String = "uba";
      
      public static const TYPE_RZONE:String = "rzone";
      
      public static const TYPE_PRIVATE:String = "private_";
      
      public static const TYPE_NORMAL:String = "normal";
      
      private static const TYPE_SORT_VALUES:Object = {};
      
      TYPE2NAME[TYPE_GROUP] = function():String
      {
         return BPLocale.getItem("title_group");
      };
      TYPE2NAME[TYPE_CLAN] = function():String
      {
         return BPLocale.getItemInCategory("","company_hierarchy_desc_clan");
      };
      TYPE2NAME[TYPE_GLOBAL] = function():String
      {
         return BPLocale.getItemInCategory("chat","dochat.chat.globalChannel");
      };
      TYPE2NAME[TYPE_FACTION] = function():String
      {
         return BPLocale.getItemInCategory("chat","dochat.chat.companyChannel");
      };
      TYPE2NAME[TYPE_NORMAL] = function():String
      {
         return BPLocale.getItemInCategory("chat","chat_chat_all");
      };
      TYPE_SORT_VALUES[TYPE_GLOBAL] = 0;
      TYPE_SORT_VALUES[TYPE_FACTION] = 1;
      TYPE_SORT_VALUES[TYPE_CLAN] = 2;
      TYPE_SORT_VALUES[TYPE_GROUP] = 3;
      
      public const messagesChanged:Signal = new Signal();
      
      public const unreadChanged:Signal = new Signal();
      
      public const roomClosed:Signal = new Signal();
      
      private var _name:String;
      
      private var _type:String;
      
      private var _active:Boolean;
      
      private var _users:Vector.<DOChatUserVO>;
      
      private var _messages:Vector.<DOChatMessageVO>;
      
      private var _joinMessage:DOChatMessageVO;
      
      private var _hasUnreadMessages:Boolean = false;
      
      private var _path:String;
      
      public function DOChatRoomVO(param1:String, param2:String, param3:String, param4:Boolean, param5:int, param6:Vector.<DOChatUserVO>, param7:Vector.<DOChatMessageVO>)
      {
         super();
         this._path = param2;
         this._users = param6;
         this._messages = param7;
         this._name = param1;
         this._type = param3 ? param3.toLowerCase() : null;
         this._active = param4;
         this._joinMessage = new DOChatMessageVO(BPLocale.getItemInCategory("chat","dochat.chat.joinRoom").replace("%ROOM",HtmlTextUtils.escapeHtmlText(this.translatedName)),DOChatUserVO.getDefaultSystemUser());
      }
      
      public static function compare(param1:DOChatRoomVO, param2:DOChatRoomVO) : Number
      {
         return param1.tabOrder - param2.tabOrder;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set active(param1:Boolean) : void
      {
         var _loc2_:Boolean = this._hasUnreadMessages;
         this._active = param1;
         if(this._active)
         {
            this._hasUnreadMessages = false;
         }
         if(_loc2_ && !this._hasUnreadMessages)
         {
            this.unreadChanged.dispatch();
         }
      }
      
      public function get users() : Vector.<DOChatUserVO>
      {
         return this._users;
      }
      
      public function get messages() : Vector.<DOChatMessageVO>
      {
         return this._messages;
      }
      
      public function get joinMessage() : DOChatMessageVO
      {
         return this._joinMessage;
      }
      
      public function get hasUnreadMessages() : Boolean
      {
         return this._hasUnreadMessages;
      }
      
      public function markUnread() : void
      {
         if(!this._hasUnreadMessages)
         {
            this._hasUnreadMessages = true;
            this.unreadChanged.dispatch();
         }
      }
      
      public function get path() : String
      {
         return this._path;
      }
      
      public function get translatedName() : String
      {
         return TYPE2NAME[this.type] ? TYPE2NAME[this.type]() : this.defaultTranslation();
      }
      
      public function get tabOrder() : int
      {
         return TYPE_SORT_VALUES[this.type] !== undefined ? int(TYPE_SORT_VALUES[this.type]) : int.MAX_VALUE;
      }
      
      public function close() : void
      {
         this.roomClosed.dispatch();
      }
      
      public function addMessage(param1:DOChatMessageVO) : void
      {
         this._messages.push(param1);
         if(this._messages.length > MAX_MSG)
         {
            this._messages.splice(0,this._messages.length - MAX_MSG);
         }
         var _loc2_:Boolean = this._hasUnreadMessages;
         if(param1.whisperType == DOChatMessageVO.WHISPER_TYPE_NONE && param1.user.usertype != DOChatUserVO.TYPE_SYSTEM && !this.isCurrentUserMessage(param1) && !this._active)
         {
            this._hasUnreadMessages = true;
         }
         this.messagesChanged.dispatch();
         if(!_loc2_ && this._hasUnreadMessages)
         {
            this.unreadChanged.dispatch();
         }
      }
      
      private function isCurrentUserMessage(param1:DOChatMessageVO) : Boolean
      {
         return param1 != null && param1.user != null && ChatSettings.userName != null && ChatSettings.userName != "" && param1.user.username == ChatSettings.userName;
      }
      
      public function removeUser(param1:String) : void
      {
         var _loc2_:uint = this._users.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._users[_loc3_].username == param1)
            {
               this._users.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
      
      public function addUser(param1:DOChatUserVO) : void
      {
         this._users.push(param1);
      }
      
      public function getUserByName(param1:String) : DOChatUserVO
      {
         var _loc4_:DOChatUserVO = null;
         var _loc2_:int = int(this._users.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._users[_loc3_];
            if(_loc4_.username == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function removeAllUsers() : void
      {
         this._users.length = 0;
      }
      
      private function defaultTranslation() : String
      {
         if(!this._name)
         {
            return "";
         }
         var _loc1_:String = this._name.toLocaleLowerCase();
         if(_loc1_.indexOf(TYPE_GROUP) != -1)
         {
            return BPLocale.getItem("title_group");
         }
         if(_loc1_.indexOf(TYPE_UBA) != -1)
         {
            return BPLocale.getItem("title_traininggrounds");
         }
         if(_loc1_.indexOf(TYPE_RZONE) != -1)
         {
            return BPLocale.getItem("title_rzone_ui");
         }
         if(_loc1_.indexOf(TYPE_CLAN) != -1)
         {
            return BPLocale.getItem("sta_clan");
         }
         if(_loc1_.indexOf(TYPE_PRIVATE) != -1)
         {
            return this._name.replace(TYPE_PRIVATE,"");
         }
         if(_loc1_.indexOf(TYPE_NEWBIE) != -1)
         {
            return BPLocale.getItem("title_5");
         }
         return this._name;
      }
   }
}

