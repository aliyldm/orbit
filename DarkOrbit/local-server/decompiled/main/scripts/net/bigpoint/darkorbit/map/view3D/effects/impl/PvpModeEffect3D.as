package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.PvpModeEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class PvpModeEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "pvpMode.zip";
      
      public function PvpModeEffect3D(param1:MapView3D, param2:PvpModeEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
         fixedScale = 0.75;
      }
   }
}

