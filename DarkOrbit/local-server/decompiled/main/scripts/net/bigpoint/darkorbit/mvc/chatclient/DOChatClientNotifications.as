package net.bigpoint.darkorbit.mvc.chatclient
{
   public class DOChatClientNotifications
   {
      
      private static const PREFIX:String = "DOChatClientNotifications";
      
      public static const STARTUP:String = PREFIX + "STARTUP";
      
      public static const TOGGLE_VISIBILITY:String = PREFIX + "toggleVisibility";
      
      public static const LOAD_CHAT_CLIENT:String = PREFIX + "loadChatCLient";
      
      public static const CHECK_LOALISATION_REASSIGNMENT:String = PREFIX + "checkLocalisationReassigment";
      
      public static const OPEN_CHAT_WINDOW_CLIENT:String = PREFIX + "openChatWindowClient";
      
      public static const SEND_MESSAGE:String = PREFIX + "SEND_MESSAGE";
      
      public static const WHISPER_MESSAGE:String = PREFIX + "WHISPER_MESSAGE";
      
      public static const CHANGE_ACTIVE_ROOM:String = PREFIX + "CHANGE_ACTIVE_ROOM";
      
      public static const NEW_PROPOSAL:String = PREFIX + "NEW_PROPOSAL";
      
      public static const INVITE_ACCEPTED:String = PREFIX + "INVITE_ACCEPTED";
      
      public static const NEW_MESSAGE:String = PREFIX + "NEW_MESSAGE";
      
      public static const RECONNECT:String = PREFIX + "RECONNECT";
      
      public static const REPORT_USER:String = PREFIX + "REPORT_USER";
      
      public static const OPEN_REPORT:String = PREFIX + "OPEN_REPORT";
      
      public static const OPEN_WHISPER:String = PREFIX + "OPEN_WHISPER";
      
      public static const UNREAD_CHANGED:String = PREFIX + "UNREAD_CHANGED";
      
      public function DOChatClientNotifications()
      {
         super();
      }
   }
}

