package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class ChargeShotEffect extends MapObjectEffect
   {
      
      public function ChargeShotEffect(param1:MapEntity)
      {
         super(EffectIDList.CHARGE_SHOT,param1,Effect.PERSISTANT);
      }
   }
}

