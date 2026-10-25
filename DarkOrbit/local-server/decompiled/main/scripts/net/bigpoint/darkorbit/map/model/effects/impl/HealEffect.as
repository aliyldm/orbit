package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class HealEffect extends MapObjectEffect
   {
      
      public function HealEffect(param1:MapEntity)
      {
         super(EffectIDList.HEAL_EFFECT,param1);
      }
   }
}

