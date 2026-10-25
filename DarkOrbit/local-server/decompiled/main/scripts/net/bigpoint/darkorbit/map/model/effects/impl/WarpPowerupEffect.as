package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class WarpPowerupEffect extends MapObjectEffect
   {
      
      public function WarpPowerupEffect(param1:MapEntity)
      {
         super(EffectIDList.WARP_POWERUP_EFFECT,param1);
      }
   }
}

