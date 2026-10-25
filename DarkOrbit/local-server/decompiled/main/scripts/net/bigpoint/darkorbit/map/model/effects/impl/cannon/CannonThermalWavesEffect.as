package net.bigpoint.darkorbit.map.model.effects.impl.cannon
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class CannonThermalWavesEffect extends MapObjectEffect
   {
      
      public function CannonThermalWavesEffect(param1:MapEntity)
      {
         super(EffectIDList.CANNON_THERMAL_WAVES,param1,NOT_PERSISTANT);
      }
   }
}

