package away3d.tools.utils
{
   import flash.display.BitmapData;
   
   public class TextureUtils
   {
      
      private static const MAX_SIZE:uint = 4096;
      
      public function TextureUtils()
      {
         super();
      }
      
      public static function isBitmapDataValid(param1:BitmapData) : Boolean
      {
         if(param1 == null)
         {
            return true;
         }
         return isDimensionValid(param1.width) && isDimensionValid(param1.height);
      }
      
      public static function isDimensionValid(param1:uint) : Boolean
      {
         return param1 >= 1 && param1 <= MAX_SIZE && isPowerOfTwo(param1);
      }
      
      public static function isPowerOfTwo(param1:int) : Boolean
      {
         return param1 ? (param1 & -param1) == param1 : false;
      }
      
      public static function getBestPowerOf2(param1:uint) : uint
      {
         var _loc2_:uint = 1;
         while(_loc2_ < param1)
         {
            _loc2_ <<= 1;
         }
         if(_loc2_ > MAX_SIZE)
         {
            _loc2_ = MAX_SIZE;
         }
         return _loc2_;
      }
   }
}

