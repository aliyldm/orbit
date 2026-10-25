package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.SpawnEffectWithFadeIn;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class SpawnEffectWithFadeIn3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "emperor_lodakium_spawn.zip";
      
      public function SpawnEffectWithFadeIn3D(param1:MapView3D, param2:SpawnEffectWithFadeIn)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
      }
   }
}

