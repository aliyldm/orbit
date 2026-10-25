package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class DisruptionEffect extends MapObjectEffect
   {
      
      public function DisruptionEffect(param1:MapEntity)
      {
         super(EffectIDList.DISRUPTION_EFFECT,param1,PERSISTANT);
      }
   }
}

