package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.ProtectedEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class ProtectedEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "protected.zip";
      
      public function ProtectedEffect3D(param1:MapView3D, param2:ProtectedEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
      }
   }
}

