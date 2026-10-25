package net.bigpoint.darkorbit.mvc.chatclient.model
{
   import com.bigpoint.utils.bindables.BindableString;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.osflash.signals.Signal;
   
   public class DOChatModelVO
   {
      
      public const roomsChanged:Signal = new Signal();
      
      public const unreadChanged:Signal = new Signal();
      
      public const banned:BindableString = new BindableString();
      
      private var _roomsByID:Dictionary = new Dictionary();
      
      private var _roomsVector:Vector.<DOChatRoomVO>;
      
      private var notifyChatRoomsChangedPointer:uint;
      
      private var _activeRoom:DOChatRoomVO = null;
      
      private var _lastMessageTime:int;
      
      public function DOChatModelVO()
      {
         super();
         this._roomsVector = new Vector.<DOChatRoomVO>();
      }
      
      public function get activeRoom() : DOChatRoomVO
      {
         return this._activeRoom || this.getRoomByType(DOChatRoomVO.TYPE_GLOBAL);
      }
      
      public function get hasUnreadMessages() : Boolean
      {
         var _loc1_:DOChatRoomVO = null;
         for each(_loc1_ in this._roomsVector)
         {
            if(_loc1_.hasUnreadMessages)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get hasUnreadPublicChannelMessages() : Boolean
      {
         var _loc1_:DOChatRoomVO = null;
         for each(_loc1_ in this._roomsVector)
         {
            if(this.isPublicChannelRoom(_loc1_) && _loc1_.hasUnreadMessages)
            {
               return true;
            }
         }
         return false;
      }
      
      private function isPublicChannelRoom(param1:DOChatRoomVO) : Boolean
      {
         return param1 != null && (param1.type == DOChatRoomVO.TYPE_GLOBAL || param1.type == DOChatRoomVO.TYPE_GROUP || param1.type == DOChatRoomVO.TYPE_CLAN || param1.type == DOChatRoomVO.TYPE_FACTION);
      }
      
      public function get lastMessageTime() : int
      {
         return this._lastMessageTime;
      }
      
      public function set lastMessageTime(param1:int) : void
      {
         this._lastMessageTime = param1;
      }
      
      public function addRoom(param1:DOChatRoomVO) : void
      {
         if(this.getRoomById(param1.path) == null)
         {
            this._roomsByID[param1.path] = param1;
            this._roomsVector.push(param1);
            this._roomsVector.sort(DOChatRoomVO.compare);
            param1.unreadChanged.add(this.handleRoomUnreadChanged);
            clearTimeout(this.notifyChatRoomsChangedPointer);
            this.notifyChatRoomsChangedPointer = setTimeout(this.notifyChatRoomsChanged,100);
         }
         if(!this._activeRoom)
         {
            this.setActiveRoomByID(param1.path);
         }
      }
      
      public function closeRoom(param1:String) : void
      {
         var _loc4_:Vector.<DOChatRoomVO> = null;
         var _loc5_:DOChatRoomVO = null;
         var _loc2_:DOChatRoomVO = this._roomsByID[param1] as DOChatRoomVO;
         if(!_loc2_)
         {
            return;
         }
         _loc2_.close();
         _loc2_.unreadChanged.remove(this.handleRoomUnreadChanged);
         if(this.activeRoom == _loc2_)
         {
            _loc4_ = this.getRoomsAsVector();
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_ != _loc2_)
               {
                  this.setActiveRoomByID(_loc5_.path);
                  break;
               }
            }
         }
         var _loc3_:int = this._roomsVector.indexOf(this._roomsByID[param1]);
         if(_loc3_ != -1)
         {
            this._roomsVector.splice(_loc3_,1);
         }
         delete this._roomsByID[param1];
         this.roomsChanged.dispatch();
         this.unreadChanged.dispatch();
      }
      
      public function getRoomsAsVector() : Vector.<DOChatRoomVO>
      {
         return this._roomsVector;
      }
      
      public function getRoomById(param1:String) : DOChatRoomVO
      {
         return this._roomsByID[param1];
      }
      
      public function hasRoomWithType(param1:String) : Boolean
      {
         var _loc2_:DOChatRoomVO = null;
         for each(_loc2_ in this.getRoomsAsVector())
         {
            if(_loc2_.type == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getRoomByType(param1:String) : DOChatRoomVO
      {
         var _loc4_:DOChatRoomVO = null;
         var _loc2_:int = int(this._roomsVector.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._roomsVector[_loc3_];
            if(_loc4_.type == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function setActiveRoomByID(param1:String) : void
      {
         var _loc2_:DOChatRoomVO = this._activeRoom;
         if(Boolean(this._activeRoom) && this._activeRoom.path == param1)
         {
            return;
         }
         this._activeRoom = this._roomsByID[param1];
         if(_loc2_)
         {
            _loc2_.active = false;
         }
         if(this._activeRoom)
         {
            this._activeRoom.active = true;
            this.roomsChanged.dispatch();
            return;
         }
         this._activeRoom = _loc2_;
      }
      
      public function cleanup() : void
      {
         var _loc2_:DOChatRoomVO = null;
         var _loc1_:* = int(this._roomsVector.length - 1);
         while(_loc1_ >= 0)
         {
            _loc2_ = this._roomsVector[_loc1_];
            this.closeRoom(_loc2_.path);
            _loc1_--;
         }
         this._activeRoom = null;
         this.banned.value = null;
      }
      
      public function getRoomByName(param1:String) : DOChatRoomVO
      {
         var _loc4_:DOChatRoomVO = null;
         var _loc2_:int = int(this._roomsVector.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._roomsVector[_loc3_];
            if(_loc4_.name == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      private function notifyChatRoomsChanged() : void
      {
         this.notifyChatRoomsChangedPointer = 0;
         this.roomsChanged.dispatch();
      }
      
      private function handleRoomUnreadChanged() : void
      {
         this.unreadChanged.dispatch();
      }
   }
}

