package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class ShipWarpEffect extends MapObjectEffect
   {
      
      public function ShipWarpEffect(param1:MapEntity)
      {
         super(EffectIDList.SHIP_WARP_EFFECT,param1);
      }
   }
}

