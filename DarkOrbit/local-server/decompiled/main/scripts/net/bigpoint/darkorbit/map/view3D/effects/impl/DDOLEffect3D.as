package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.DDOLEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class DDOLEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "ddol.zip";
      
      public function DDOLEffect3D(param1:MapView3D, param2:DDOLEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
         fixedScale = 0.4;
      }
   }
}

