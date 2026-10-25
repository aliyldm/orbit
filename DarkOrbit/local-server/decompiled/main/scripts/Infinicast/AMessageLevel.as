package Infinicast
{
   public class AMessageLevel
   {
      
      public static var Error:int = 0;
      
      public function AMessageLevel()
      {
         super();
      }
      
      public static function toString(param1:int) : String
      {
         switch(param1)
         {
            case 0:
               return "Error";
            default:
               throw new ArgumentError("Unknown enumeration value");
         }
      }
      
      public static function parse(param1:String) : int
      {
         switch(param1)
         {
            case "Error":
               return 0;
            default:
               throw new ArgumentError("Unknown enumeration value");
         }
      }
   }
}

