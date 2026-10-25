package net.bigpoint.darkorbit.utils
{
   import flash.utils.ByteArray;
   
   public class ByteArrayUtils
   {
      
      public function ByteArrayUtils()
      {
         super();
      }
      
      public static function equal(param1:ByteArray, param2:ByteArray) : Boolean
      {
         var _loc3_:int = int(param1.position);
         var _loc4_:int = int(param2.position);
         if(param1.length == param2.length)
         {
            param1.position = param2.position = 0;
            while(param1.bytesAvailable)
            {
               if(param1.readByte() != param2.readByte())
               {
                  param1.position = _loc3_;
                  param2.position = _loc4_;
                  return false;
               }
            }
            param1.position = _loc3_;
            param2.position = _loc4_;
            return true;
         }
         return false;
      }
      
      public static function traceOut(param1:ByteArray) : void
      {
         param1.position = 0;
         while(param1.bytesAvailable)
         {
         }
      }
   }
}

