package Infinicast
{
   public class ListenTerminateReason
   {
      
      public static var UserRemoved:int = 0;
      
      public static var RoleRemoved:int = 1;
      
      public static var PathDeleted:int = 2;
      
      public function ListenTerminateReason()
      {
         super();
      }
      
      public static function toString(param1:int) : String
      {
         switch(param1)
         {
            case 0:
               return "UserRemoved";
            case 1:
               return "RoleRemoved";
            case 2:
               return "PathDeleted";
            default:
               throw new ArgumentError("Unknown enumeration value");
         }
      }
      
      public static function parse(param1:String) : int
      {
         switch(param1)
         {
            case "UserRemoved":
               return 0;
            case "RoleRemoved":
               return 1;
            case "PathDeleted":
               return 2;
            default:
               throw new ArgumentError("Unknown enumeration value");
         }
      }
   }
}

