package net.bigpoint.darkorbit.map.view3D.effects.impl.publicWorldBoss
{
   import net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss.BossLaserWarningEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.CrossTargetBeamEffect3D;
   
   public class BossLaserWarningEffect3D extends CrossTargetBeamEffect3D
   {
      
      public function BossLaserWarningEffect3D(param1:MapView3D, param2:BossLaserWarningEffect)
      {
         super(param1,param2,param2.source,param2.target,"BossLaserPreparation.awp",param2.targetPosition);
      }
   }
}

