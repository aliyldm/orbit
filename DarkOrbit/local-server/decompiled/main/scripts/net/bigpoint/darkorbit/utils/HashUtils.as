package net.bigpoint.darkorbit.utils
{
   import flash.utils.Dictionary;
   
   public class HashUtils
   {
      
      private static var _nextId:int = 0;
      
      private static const _hashtable:Dictionary = new Dictionary(true);
      
      public function HashUtils()
      {
         super();
      }
      
      public static function getObjectHash(param1:*) : String
      {
         if(_hashtable[param1] === undefined)
         {
            _hashtable[param1] = _nextId++;
         }
         return _hashtable[param1];
      }
      
      public static function getObjectsHash(param1:Array) : String
      {
         var _loc2_:String = "";
         var _loc3_:* = int(param1.length - 1);
         while(_loc3_ >= 0)
         {
            _loc2_ += getObjectHash(param1[0]);
            _loc3_--;
         }
         return _loc2_;
      }
   }
}

