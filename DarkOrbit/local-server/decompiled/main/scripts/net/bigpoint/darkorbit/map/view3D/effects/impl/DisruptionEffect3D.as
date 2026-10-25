package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.DisruptionEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class DisruptionEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "disruption.zip";
      
      public function DisruptionEffect3D(param1:MapView3D, param2:DisruptionEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
      }
   }
}

