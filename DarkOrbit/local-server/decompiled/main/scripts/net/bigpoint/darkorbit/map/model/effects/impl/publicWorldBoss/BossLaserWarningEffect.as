package net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.beam.BeamEffect;
   
   public class BossLaserWarningEffect extends BeamEffect
   {
      
      private var _target:MapEntity;
      
      public function BossLaserWarningEffect(param1:MapEntity, param2:MapEntity)
      {
         var _loc3_:int = 2000;
         super(EffectIDList.BOSS_LASER_WARNING,param1,param2,_loc3_,4294901760,InGameCatalog.SOUND_ID_NOISE);
         this._target = param2;
      }
      
      public function set target(param1:MapEntity) : void
      {
         this._target = param1;
      }
      
      public function get durationSeconds() : int
      {
         return 2000;
      }
   }
}

