package net.bigpoint.darkorbit.utils
{
   import com.coolorus.panel.core.utils.color.HSV;
   
   public class ColorUtils
   {
      
      public function ColorUtils()
      {
         super();
      }
      
      public static function interpolate(param1:uint, param2:uint, param3:Number) : uint
      {
         var _loc4_:uint = uint(param1 >> 16 & 0xFF);
         var _loc5_:uint = uint(param1 >> 8 & 0xFF);
         var _loc6_:uint = uint(param1 & 0xFF);
         var _loc7_:int = (param2 >> 16 & 0xFF) - _loc4_;
         var _loc8_:int = (param2 >> 8 & 0xFF) - _loc5_;
         var _loc9_:int = (param2 & 0xFF) - _loc6_;
         return _loc4_ + _loc7_ * param3 << 16 | _loc5_ + _loc8_ * param3 << 8 | _loc6_ + _loc9_ * param3;
      }
      
      public static function niceRandomColor() : uint
      {
         return new HSV(Math.random() * 360,0.4 + Math.random() * 0.5,0.1 + Math.random() * 0.8).rawColor;
      }
   }
}

