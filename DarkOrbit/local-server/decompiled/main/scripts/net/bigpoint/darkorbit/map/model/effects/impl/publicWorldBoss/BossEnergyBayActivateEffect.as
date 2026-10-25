package net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class BossEnergyBayActivateEffect extends MapObjectEffect
   {
      
      public function BossEnergyBayActivateEffect(param1:MapEntity)
      {
         super(EffectIDList.BOSS_ENERGY_BAY_ACTIVATE,param1,PERSISTANT,new EffectPattern(EffectIDList.BOSS_ENERGY_BAY_ACTIVATE,"boss_bay_activate"));
      }
   }
}

