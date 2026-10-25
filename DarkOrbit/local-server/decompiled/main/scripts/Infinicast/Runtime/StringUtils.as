package Infinicast.Runtime
{
   public class StringUtils
   {
      
      public function StringUtils()
      {
         super();
      }
      
      public static function IsNullOrEmpty(param1:String) : Boolean
      {
         if(null === param1)
         {
            return true;
         }
         if(0 == param1.length)
         {
            return true;
         }
         return false;
      }
      
      public static function GetStringPathEleByIdx(param1:String, param2:int) : String
      {
         if(IsNullOrEmpty(param1))
         {
            return "";
         }
         var _loc3_:String = "";
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         while(_loc6_ < param1.length)
         {
            if(param1.charAt(_loc6_) === "/")
            {
               switch(_loc4_)
               {
                  case param2:
                     _loc5_ = true;
                     break;
                  case param2 + 1:
                     return _loc3_.toString();
               }
               _loc4_++;
            }
            else if(_loc5_)
            {
               _loc3_ += param1.charAt(_loc6_);
            }
            _loc6_++;
         }
         return "";
      }
      
      public static function contains(param1:String, param2:String) : Boolean
      {
         return param1.indexOf(param2) > -1;
      }
      
      public static function splitAsPath(param1:String) : Vector.<String>
      {
         return Vector.<String>(param1.split("/"));
      }
      
      public static function startsWith(param1:String, param2:String) : Boolean
      {
         return param1.indexOf(param2) === 0;
      }
      
      public static function endsWith(param1:String, param2:String) : Boolean
      {
         return param1.lastIndexOf(param2) === param1.length - param2.length;
      }
      
      public static function remove(param1:String, param2:int) : String
      {
         return param1.substring(0,param2);
      }
      
      public static function butLast(param1:String) : String
      {
         if(0 === param1.length)
         {
            return param1;
         }
         return remove(param1,param1.length - 1);
      }
   }
}

