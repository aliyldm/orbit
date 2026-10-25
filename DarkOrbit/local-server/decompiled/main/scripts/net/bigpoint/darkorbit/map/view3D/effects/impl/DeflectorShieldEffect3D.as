package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.DeflectorShieldEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class DeflectorShieldEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "shield_deflector.zip";
      
      public function DeflectorShieldEffect3D(param1:MapView3D, param2:DeflectorShieldEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
      }
   }
}

