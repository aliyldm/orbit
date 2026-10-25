package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class ConstructingEffect extends MapObjectEffect
   {
      
      public function ConstructingEffect(param1:MapEntity)
      {
         super(EffectIDList.CONSTRUCTING_EFFECT,param1);
      }
   }
}

