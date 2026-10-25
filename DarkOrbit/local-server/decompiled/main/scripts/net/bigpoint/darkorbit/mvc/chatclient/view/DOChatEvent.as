package net.bigpoint.darkorbit.mvc.chatclient.view
{
   import flash.events.Event;
   
   public class DOChatEvent extends Event
   {
      
      public static const base:String = "DO_CHAT_EVENT_";
      
      public static const SEND_MESSAGE:String = base + "SEND_MESSAGE";
      
      public static const WHISPER_MESSAGE:String = base + "WHISPER_MESSAGE";
      
      public static const WHISPER_VIEW_OPENED:String = base + "WHISPER_VIEW_OPENED";
      
      public static const CLEAR_WHISPER_HISTORY_REQUESTED:String = base + "CLEAR_WHISPER_HISTORY_REQUESTED";
      
      public static const USERNAME_CLICKED:String = base + "USERNAME_CLICKED";
      
      public static const OPEN_REPORT_REQUESTED:String = base + "OPEN_REPORT_REQUESTED";
      
      public static const ADD_FRIEND_REQUESTED:String = base + "ADD_FRIEND_REQUESTED";
      
      public static const GROUP_INVITE_REQUESTED:String = base + "GROUP_INVITE_REQUESTED";
      
      public static const ADD_TO_BLACKLIST_REQUESTED:String = base + "ADD_TO_BLACKLIST_REQUESTED";
      
      public static const ACTIVE_ROOM_SELECTION_CHANGED:String = base + "ACTIVE_ROOM_SELECTION_CHANGED";
      
      public static const ACCEPT_INVITE_CLICKED:String = base + "ACCEPT_INVITE_CLICKED";
      
      public static const RECONNECT_USER_REQUEST:String = "RECONNECT_USER_REQUEST";
      
      public static const CMD_CLICKED:String = "CMD_CLICKED";
      
      public static const REPORT:String = base + "REPORT";
      
      private var _payload:Object;
      
      public function DOChatEvent(param1:String, param2:Object = null, param3:Boolean = false)
      {
         super(param1,param3);
         this._payload = param2;
      }
      
      public function get payload() : Object
      {
         return this._payload;
      }
      
      override public function clone() : Event
      {
         return new DOChatEvent(type,this.payload,bubbles);
      }
   }
}

