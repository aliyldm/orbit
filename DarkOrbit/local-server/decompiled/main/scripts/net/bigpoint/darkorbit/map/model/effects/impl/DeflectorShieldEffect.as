package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class DeflectorShieldEffect extends MapObjectEffect
   {
      
      public function DeflectorShieldEffect(param1:MapEntity)
      {
         super(EffectIDList.DEFLECTOR_SHIELD_EFFECT,param1);
      }
   }
}

