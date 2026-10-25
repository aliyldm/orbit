package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class SpreadEffect extends MapObjectEffect
   {
      
      public function SpreadEffect(param1:MapEntity, param2:int)
      {
         super(EffectIDList.SPREAD_EFFECT,param1,Effect.PERSISTANT);
      }
   }
}

