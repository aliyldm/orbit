package net.bigpoint.darkorbit.map.view3D
{
   public class DenseEffectPolicy3D
   {
      
      public static const RADIUS:Number = 2000;
      
      public static const THRESHOLD:int = 40;
      
      public static const EXIT_THRESHOLD:int = 30;
      
      public static const RECOVERY_MS:int = 5000;
      
      public static var denseScene:Boolean = false;
      
      private static var belowSince:int = -1;
      
      public function DenseEffectPolicy3D()
      {
         super();
      }
      
      public static function includes(param1:Number, param2:Number, param3:Boolean, param4:Boolean, param5:Boolean) : Boolean
      {
         return !param3 && !param4 && !param5 && param1 * param1 + param2 * param2 <= RADIUS * RADIUS;
      }
      
      public static function update(param1:int, param2:int) : void
      {
         if(param1 >= THRESHOLD)
         {
            belowSince = -1;
            if(!denseScene)
            {
               denseScene = true;
            }
         }
         else if(param1 >= EXIT_THRESHOLD)
         {
            belowSince = -1;
         }
         else if(denseScene)
         {
            if(belowSince < 0)
            {
               belowSince = param2;
            }
            if(param2 - belowSince >= RECOVERY_MS)
            {
               denseScene = false;
               belowSince = -1;
            }
         }
      }
      
      public static function clear() : void
      {
         denseScene = false;
         belowSince = -1;
      }
   }
}

