package net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class BossEscapeEffect extends MapObjectEffect
   {
      
      public function BossEscapeEffect(param1:MapEntity)
      {
         super(EffectIDList.BOSS_ESCAPE,param1,NOT_PERSISTANT,new EffectPattern(EffectIDList.BOSS_ESCAPE,"boss_escape"));
      }
   }
}

