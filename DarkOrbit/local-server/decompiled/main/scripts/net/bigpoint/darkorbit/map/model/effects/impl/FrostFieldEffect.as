package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class FrostFieldEffect extends MapObjectEffect
   {
      
      public function FrostFieldEffect(param1:MapEntity)
      {
         super(EffectIDList.FROST_FIELD,param1,Effect.PERSISTANT);
      }
   }
}

