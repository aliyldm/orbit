package net.bigpoint.darkorbit.map.model.effects.impl.glow
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class UberEffect extends AbstractShipGlowEffect
   {
      
      public function UberEffect(param1:Ship)
      {
         super(EffectIDList.UBER_EFFECT,param1,16711680);
      }
   }
}

