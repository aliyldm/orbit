package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.AntiMineTransmitterEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class AntiMineTransmittorEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "anti-mine-transmitter.zip";
      
      public function AntiMineTransmittorEffect3D(param1:MapView3D, param2:AntiMineTransmitterEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
      }
   }
}

