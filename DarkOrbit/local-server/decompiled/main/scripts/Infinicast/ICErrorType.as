package Infinicast
{
   public class ICErrorType
   {
      
      public static var TimedOut:int = 0;
      
      public static var RightsCheck:int = 1;
      
      public static var NoListener:int = 2;
      
      public static var CouldNotLoginWithoutCredentials:int = 3;
      
      public static var CouldNotLoginWithWrongCredentials:int = 4;
      
      public static var NoServer:int = 5;
      
      public static var InternalError:int = 6;
      
      public static var ParseFailed:int = 7;
      
      public static var SendLimitReached:int = 8;
      
      public static var Custom:int = 9;
      
      public function ICErrorType()
      {
         super();
      }
      
      public static function toString(param1:int) : String
      {
         switch(param1)
         {
            case 0:
               return "TimedOut";
            case 1:
               return "RightsCheck";
            case 2:
               return "NoListener";
            case 3:
               return "CouldNotLoginWithoutCredentials";
            case 4:
               return "CouldNotLoginWithWrongCredentials";
            case 5:
               return "NoServer";
            case 6:
               return "InternalError";
            case 7:
               return "ParseFailed";
            case 8:
               return "SendLimitReached";
            case 9:
               return "Custom";
            default:
               throw new ArgumentError("Unknown enumeration value");
         }
      }
      
      public static function parse(param1:String) : int
      {
         switch(param1)
         {
            case "TimedOut":
               return 0;
            case "RightsCheck":
               return 1;
            case "NoListener":
               return 2;
            case "CouldNotLoginWithoutCredentials":
               return 3;
            case "CouldNotLoginWithWrongCredentials":
               return 4;
            case "NoServer":
               return 5;
            case "InternalError":
               return 6;
            case "ParseFailed":
               return 7;
            case "SendLimitReached":
               return 8;
            case "Custom":
               return 9;
            default:
               throw new ArgumentError("Unknown enumeration value");
         }
      }
   }
}

