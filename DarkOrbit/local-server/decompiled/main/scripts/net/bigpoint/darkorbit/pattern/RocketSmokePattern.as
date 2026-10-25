package net.bigpoint.darkorbit.pattern
{
   public class RocketSmokePattern extends ResourcePattern
   {
      
      public var particleInterval:int;
      
      public var particleDuration:Number;
      
      public var fx3D:String;
      
      public function RocketSmokePattern(param1:int, param2:String, param3:int, param4:Number, param5:String)
      {
         super(param1,param2);
         this.particleInterval = param3;
         this.particleDuration = param4;
         this.fx3D = param5;
      }
   }
}

