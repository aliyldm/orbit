package net.bigpoint.darkorbit.map.view3D.effects.impl.paladin
{
   import net.bigpoint.darkorbit.map.model.effects.impl.paladin.RipperEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.StandaloneParticle3D;
   
   public class RipperEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "ripperEffect.zip";
      
      public function RipperEffect3D(param1:MapView3D, param2:RipperEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
      }
   }
}

