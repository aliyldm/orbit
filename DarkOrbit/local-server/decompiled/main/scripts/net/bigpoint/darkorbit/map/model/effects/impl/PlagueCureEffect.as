package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class PlagueCureEffect extends MapObjectEffect
   {
      
      public function PlagueCureEffect(param1:MapEntity)
      {
         super(EffectIDList.PLAGUE_CURE,param1,Effect.NOT_PERSISTANT);
      }
   }
}

