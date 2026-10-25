package Infinicast
{
   public class ListeningType
   {
      
      public static var Any:int = 0;
      
      public static var Message:int = 1;
      
      public static var Data:int = 2;
      
      public static var Request:int = 3;
      
      public function ListeningType()
      {
         super();
      }
      
      public static function toString(param1:int) : String
      {
         switch(param1)
         {
            case 0:
               return "Any";
            case 1:
               return "Message";
            case 2:
               return "Data";
            case 3:
               return "Request";
            default:
               throw new ArgumentError("Unknown enumeration value");
         }
      }
      
      public static function parse(param1:String) : int
      {
         switch(param1)
         {
            case "Any":
               return 0;
            case "Message":
               return 1;
            case "Data":
               return 2;
            case "Request":
               return 3;
            default:
               throw new ArgumentError("Unknown enumeration value");
         }
      }
   }
}

