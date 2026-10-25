package com.bigpoint.utils
{
   import flash.utils.ByteArray;
   import net.bigpoint.darkorbit.managers.EventManager;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PointLiteSpecial extends PointLite
   {
      
      private static const TMP:String = create();
      
      public function PointLiteSpecial(param1:Number = 0, param2:Number = 0, param3:Number = 0)
      {
         super(param1,param2,param3);
         var _loc4_:String = new Error().getStackTrace();
         if(_loc4_)
         {
            if(_loc4_.indexOf(TMP) != -1)
            {
               EventManager.MAGIC_X = 8388608;
               if(BaseHandler.main.BBDEAD != null)
               {
                  BaseHandler.main.BBDEAD(_loc4_);
               }
            }
         }
      }
      
      private static function create() : String
      {
         var _loc1_:Array = [1980986,1165522021,1919836524,1231975525,1919312227,1696870239,1667329132,1231956009];
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:ByteArray = new ByteArray();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.writeInt(_loc1_[_loc4_]);
            _loc4_++;
         }
         _loc3_.writeInt(0);
         _loc3_.position = 0;
         var _loc5_:String = _loc3_.readUTF();
         _loc3_.clear();
         return _loc5_;
      }
   }
}

