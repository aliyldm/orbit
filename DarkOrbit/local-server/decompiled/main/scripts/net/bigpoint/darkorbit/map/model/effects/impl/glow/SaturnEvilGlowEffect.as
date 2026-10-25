package net.bigpoint.darkorbit.map.model.effects.impl.glow
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class SaturnEvilGlowEffect extends AbstractShipGlowEffect
   {
      
      public function SaturnEvilGlowEffect(param1:Ship)
      {
         super(EffectIDList.SATURN_EVIL_GLOW_EFFECT,param1,0);
         this.glowStrength = 0.5;
      }
   }
}

