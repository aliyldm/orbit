package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class LevelUpEffect extends MapObjectEffect
   {
      
      public function LevelUpEffect(param1:MapEntity)
      {
         super(EffectIDList.LEVEL_UP_EFFECT,param1,NOT_PERSISTANT,new EffectPattern(EffectIDList.LEVEL_UP_EFFECT,"levelUp"));
         this._excludeGroup = 1;
      }
   }
}

