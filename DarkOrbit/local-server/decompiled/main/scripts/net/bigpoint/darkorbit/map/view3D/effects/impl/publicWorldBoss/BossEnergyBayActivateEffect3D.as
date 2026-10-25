package net.bigpoint.darkorbit.map.view3D.effects.impl.publicWorldBoss
{
   import net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss.BossEnergyBayActivateEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.StandaloneParticle3D;
   
   public class BossEnergyBayActivateEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "BossEnergyBayActive.awp";
      
      public function BossEnergyBayActivateEffect3D(param1:MapView3D, param2:BossEnergyBayActivateEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
         this.offset3D.y += 300;
      }
   }
}

