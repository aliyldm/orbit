package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class SentinelEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "sentinel.zip";
      
      public function SentinelEffect3D(param1:MapView3D, param2:MapObjectEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
      }
   }
}

