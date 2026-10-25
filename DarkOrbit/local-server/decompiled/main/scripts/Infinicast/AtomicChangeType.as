package Infinicast
{
   public class AtomicChangeType
   {
      
      public static var Set:int = 0;
      
      public static var AddToArray:int = 1;
      
      public static var RemoveFromArray:int = 2;
      
      public static var IncValue:int = 3;
      
      public static var DecValue:int = 4;
      
      public static var AddToSet:int = 5;
      
      public static var RemoveFromSet:int = 6;
      
      public static var RemoveProperty:int = 7;
      
      public static var SetIfEmpty:int = 8;
      
      public function AtomicChangeType()
      {
         super();
      }
      
      public static function toString(param1:int) : String
      {
         switch(param1)
         {
            case 0:
               return "Set";
            case 1:
               return "AddToArray";
            case 2:
               return "RemoveFromArray";
            case 3:
               return "IncValue";
            case 4:
               return "DecValue";
            case 5:
               return "AddToSet";
            case 6:
               return "RemoveFromSet";
            case 7:
               return "RemoveProperty";
            case 8:
               return "SetIfEmpty";
            default:
               throw new ArgumentError("Unknown enumeration value");
         }
      }
      
      public static function parse(param1:String) : int
      {
         switch(param1)
         {
            case "Set":
               return 0;
            case "AddToArray":
               return 1;
            case "RemoveFromArray":
               return 2;
            case "IncValue":
               return 3;
            case "DecValue":
               return 4;
            case "AddToSet":
               return 5;
            case "RemoveFromSet":
               return 6;
            case "RemoveProperty":
               return 7;
            case "SetIfEmpty":
               return 8;
            default:
               throw new ArgumentError("Unknown enumeration value");
         }
      }
   }
}

