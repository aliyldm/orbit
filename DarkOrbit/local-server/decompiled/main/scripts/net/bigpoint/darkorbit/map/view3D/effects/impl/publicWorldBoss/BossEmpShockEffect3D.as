package net.bigpoint.darkorbit.map.view3D.effects.impl.publicWorldBoss
{
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss.BossEmpShockEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.StandaloneParticle3D;
   
   public class BossEmpShockEffect3D extends StandaloneParticle3D
   {
      
      public function BossEmpShockEffect3D(param1:MapView3D, param2:BossEmpShockEffect)
      {
         var mapView:MapView3D = param1;
         var effect:BossEmpShockEffect = param2;
         super(effect,"BossEmpShock.awp",effect.source.position);
         setTimeout(function():void
         {
            new StandaloneParticle3D(effect,"BossEmpShock_01.awp",effect.source.position);
         },2000);
      }
   }
}

