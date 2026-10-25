package net.bigpoint.darkorbit.pattern
{
   public class POITexturePattern extends POIPattern
   {
      
      public var resKey:String;
      
      public var repeat:Boolean;
      
      public function POITexturePattern(param1:int, param2:String, param3:String, param4:Boolean, param5:Boolean = false, param6:Number = 1, param7:String = null, param8:Number = 0)
      {
         super(param1,param2,param5,param6,param7,param8);
         this.resKey = param3;
         this.repeat = param4;
      }
   }
}

