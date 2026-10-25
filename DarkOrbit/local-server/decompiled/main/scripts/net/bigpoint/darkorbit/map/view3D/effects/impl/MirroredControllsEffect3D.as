package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.MirroredControlsEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class MirroredControllsEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "mirrored_controls.zip";
      
      public function MirroredControllsEffect3D(param1:MapView3D, param2:MirroredControlsEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
      }
   }
}

