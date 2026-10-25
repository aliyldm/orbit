package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.SkullEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class SkullEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "skull.zip";
      
      public function SkullEffect3D(param1:MapView3D, param2:SkullEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
      }
   }
}

