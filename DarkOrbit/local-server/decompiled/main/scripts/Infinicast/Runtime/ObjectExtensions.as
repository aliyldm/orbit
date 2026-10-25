package Infinicast.Runtime
{
   public class ObjectExtensions
   {
      
      public function ObjectExtensions()
      {
         super();
      }
      
      public static function toString(param1:*) : String
      {
         return param1.toString();
      }
      
      public static function clone(param1:Object) : Object
      {
         var _loc2_:String = JSON.stringify(param1);
         return JSON.parse(_loc2_);
      }
      
      public static function getStringArray(param1:Object, param2:String) : Vector.<String>
      {
         var _loc5_:* = undefined;
         var _loc3_:Vector.<String> = new Vector.<String>();
         var _loc4_:Vector.<Object> = Vector.<Object>(param1[param2]);
         for(_loc5_ in _loc4_)
         {
            _loc3_.push(_loc5_);
         }
         return _loc3_;
      }
   }
}

