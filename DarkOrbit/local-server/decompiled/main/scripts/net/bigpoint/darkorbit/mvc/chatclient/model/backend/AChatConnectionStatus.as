package net.bigpoint.darkorbit.mvc.chatclient.model.backend
{
   public class AChatConnectionStatus
   {
      
      public static const Connecting:int = 0;
      
      public static const LoggingIn:int = 1;
      
      public static const LoggedIn:int = 2;
      
      public static const Disconnected:int = -1;
      
      public static const Failed:int = -2;
      
      public static const Banned:int = -3;
      
      public function AChatConnectionStatus()
      {
         super();
      }
      
      public static function toString(param1:int) : String
      {
         switch(param1)
         {
            case Connecting:
               return "Connecting";
            case LoggingIn:
               return "LoggingIn";
            case LoggedIn:
               return "LoggedIn";
            case Disconnected:
               return "Disconnected";
            case Failed:
               return "Failed";
            case Banned:
               return "Banned";
            default:
               return "Unknown";
         }
      }
   }
}

