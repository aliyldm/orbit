package net.bigpoint.darkorbit.map.view3D.effects.impl.publicWorldBoss
{
   import net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss.BossShieldEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.StandaloneParticle3D;
   
   public class BossShieldEffect3D extends StandaloneParticle3D
   {
      
      public function BossShieldEffect3D(param1:MapView3D, param2:BossShieldEffect)
      {
         super(param2,param2.particleFilename,param2.source.position);
      }
   }
}

