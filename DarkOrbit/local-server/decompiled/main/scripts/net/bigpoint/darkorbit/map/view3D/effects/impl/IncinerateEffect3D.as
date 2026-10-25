package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.IncinerateEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class IncinerateEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "incinerate.zip";
      
      public function IncinerateEffect3D(param1:MapView3D, param2:IncinerateEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
         fixedScale = 2;
      }
   }
}

