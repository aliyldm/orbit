package net.bigpoint.darkorbit.map.view3D.loaders
{
   import flash.display.BlendMode;
   
   public final class ParticleBlendPolicy3D
   {
      
      public function ParticleBlendPolicy3D()
      {
         super();
      }
      
      public static function select(param1:String, param2:String, param3:String) : String
      {
         if(Boolean(param1) && Boolean(param1.indexOf("glow_add") == 0) && param3 == BlendMode.NORMAL)
         {
            return BlendMode.ADD;
         }
         return param3;
      }
   }
}

