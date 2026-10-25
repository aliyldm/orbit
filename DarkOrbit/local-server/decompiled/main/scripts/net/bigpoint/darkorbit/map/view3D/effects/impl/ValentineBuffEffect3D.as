package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.ValentineBuffEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class ValentineBuffEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "valentineBuff.zip";
      
      public function ValentineBuffEffect3D(param1:MapView3D, param2:ValentineBuffEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
         fixedScale = 0.75;
      }
   }
}

