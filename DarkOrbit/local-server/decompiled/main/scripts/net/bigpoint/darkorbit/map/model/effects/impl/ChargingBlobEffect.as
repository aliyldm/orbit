package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class ChargingBlobEffect extends AbstractStickyBombEffect
   {
      
      public function ChargingBlobEffect(param1:MapEntity, param2:MapEntity)
      {
         super(EffectIDList.CHARGING_BLOB_EFFECT,param1,param2,AbstractStickyBombEffect.EXPLODING_CHARGING_BLOB);
      }
   }
}

