package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.FrostFieldEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class FrostFieldEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "fx_tech-frost-field.zip";
      
      public function FrostFieldEffect3D(param1:MapView3D, param2:FrostFieldEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
         fixedScale = 2.6;
      }
   }
}

