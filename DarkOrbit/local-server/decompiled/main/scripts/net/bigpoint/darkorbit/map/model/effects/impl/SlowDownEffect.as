package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class SlowDownEffect extends MapObjectEffect
   {
      
      public function SlowDownEffect(param1:MapEntity)
      {
         super(EffectIDList.SLOW_DOWN_EFFECT,param1,PERSISTANT,new EffectPattern(EffectIDList.SLOW_DOWN_EFFECT,"slow-effect"));
      }
   }
}

