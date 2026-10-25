package Infinicast.Runtime
{
   import flash.utils.Dictionary;
   
   public class DictionaryExtensions
   {
      
      public function DictionaryExtensions()
      {
         super();
      }
      
      public static function getOrAdd(param1:Dictionary, param2:*, param3:*) : *
      {
         if(param2 in param1)
         {
            return param1[param2];
         }
         param1[param2] = param3;
         return param3;
      }
      
      public static function containsKey(param1:Dictionary, param2:*) : Boolean
      {
         return param2 in param1;
      }
      
      public static function add(param1:Dictionary, param2:*, param3:*) : void
      {
         param1[param2] = param3;
      }
      
      public static function remove(param1:Dictionary, param2:*) : Boolean
      {
         if(param2 in param1)
         {
            delete param1[param2];
            return true;
         }
         return false;
      }
      
      public static function clear(param1:Dictionary) : void
      {
         var _loc2_:Object = null;
         for(_loc2_ in param1)
         {
            delete param1[_loc2_];
         }
      }
      
      public static function getValue(param1:Dictionary, param2:*) : *
      {
         return param1[param2];
      }
   }
}

