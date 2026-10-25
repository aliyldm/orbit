package net.bigpoint.darkorbit.map.view3D.effects.impl.publicWorldBoss
{
   import net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss.BossLaserChargeEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.StandaloneParticle3D;
   
   public class BossLaserChargeEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "BossLaserCharge.awp";
      
      public function BossLaserChargeEffect3D(param1:MapView3D, param2:BossLaserChargeEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
      }
   }
}

