package net.bigpoint.darkorbit.map.common
{
   public final class LaserImpactGeometry
   {
      
      public function LaserImpactGeometry()
      {
         super();
      }
      
      public static function stopDistance(param1:Number, param2:Number, param3:Number) : Number
      {
         return Math.max(0,param1 * Math.abs(param2)) + Math.max(0,param3);
      }
   }
}

