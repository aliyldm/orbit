package net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class BossLaserChargeEffect extends MapObjectEffect
   {
      
      public function BossLaserChargeEffect(param1:MapEntity)
      {
         super(EffectIDList.BOSS_LASER_CHARGE,param1,NOT_PERSISTANT,new EffectPattern(EffectIDList.BOSS_LASER_CHARGE,"boss_laser_charge"));
      }
   }
}

