package net.bigpoint.darkorbit.map.model.effects.impl.glow
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class SheerChaosEffect extends AbstractShipGlowEffect
   {
      
      public function SheerChaosEffect(param1:Ship)
      {
         super(EffectIDList.SHEER_CHAOS_EFFECT,param1,16766720);
         this.glowStrength = 0.4;
      }
   }
}

