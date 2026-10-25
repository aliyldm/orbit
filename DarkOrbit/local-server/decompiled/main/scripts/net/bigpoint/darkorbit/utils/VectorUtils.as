package net.bigpoint.darkorbit.utils
{
   public class VectorUtils
   {
      
      public function VectorUtils()
      {
         super();
      }
      
      public static function unique(param1:Object, param2:Function) : Object
      {
         var _loc5_:* = undefined;
         var _loc6_:* = 0;
         var _loc7_:int = 0;
         var _loc3_:int = int(param1.length);
         var _loc4_:* = int(param1.length - 1);
         while(_loc4_ >= 0)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = int(_loc4_ - 1);
            while(_loc6_ >= 0)
            {
               _loc7_ = param2(_loc5_,param1[_loc6_]);
               if(_loc7_ < 0)
               {
                  param1.splice(_loc6_,1);
               }
               else if(_loc7_ > 0)
               {
                  param1.splice(_loc4_,1);
               }
               _loc6_--;
            }
            _loc4_--;
         }
         return param1;
      }
      
      public static function toArray(param1:*) : Array
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc2_.push(_loc3_);
         }
         return _loc2_;
      }
   }
}

