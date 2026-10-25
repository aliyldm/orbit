package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class DecloakEffect extends MapObjectEffect
   {
      
      public function DecloakEffect(param1:MapEntity)
      {
         super(EffectIDList.DECLOAK_EFFECT,param1);
      }
   }
}

