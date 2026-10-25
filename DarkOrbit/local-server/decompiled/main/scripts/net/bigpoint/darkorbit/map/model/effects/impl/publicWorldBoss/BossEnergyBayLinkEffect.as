package net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AbstractBoltEffect;
   
   public class BossEnergyBayLinkEffect extends AbstractBoltEffect
   {
      
      public function BossEnergyBayLinkEffect(param1:MapEntity, param2:MapEntity)
      {
         super(EffectIDList.BOSS_ENERGY_BAY_LINK,param1,[param2.id],PERSISTANT);
      }
   }
}

