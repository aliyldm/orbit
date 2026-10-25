package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class DrawFireEffect extends MapObjectEffect
   {
      
      public function DrawFireEffect(param1:MapEntity)
      {
         super(EffectIDList.DRAW_FIRE_EFFECT,param1);
      }
   }
}

