package net.bigpoint.darkorbit.utils
{
   import net.bigpoint.darkorbit.utils.math.FastMath;
   
   public class RandomUtils
   {
      
      public function RandomUtils()
      {
         super();
      }
      
      public static function getRandomItem(param1:Array) : Object
      {
         return param1[FastMath.getRandomCount(0,param1.length - 1)];
      }
   }
}

