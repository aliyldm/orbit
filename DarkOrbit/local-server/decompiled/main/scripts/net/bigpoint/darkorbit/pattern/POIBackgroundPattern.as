package net.bigpoint.darkorbit.pattern
{
   public class POIBackgroundPattern extends POIPattern
   {
      
      public var backgroundID:int;
      
      public var simpleBackgroundID:int;
      
      public function POIBackgroundPattern(param1:int, param2:String, param3:int, param4:int, param5:Boolean = false, param6:Number = 1, param7:String = null, param8:Number = 0)
      {
         super(param1,param2,param5,param6,param7,param8);
         this.backgroundID = param3;
         this.simpleBackgroundID = param4;
      }
   }
}

