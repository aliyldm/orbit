package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class PolarityPowerupEffect extends MapObjectEffect
   {
      
      public function PolarityPowerupEffect(param1:MapEntity)
      {
         super(EffectIDList.POLARITY_POWERUP_EFFECT,param1,NOT_PERSISTANT);
      }
   }
}

