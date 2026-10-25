package net.bigpoint.darkorbit.map.model.effects.impl.glow
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class SolarGlowEffect extends AbstractShipGlowEffect
   {
      
      public function SolarGlowEffect(param1:Ship)
      {
         super(EffectIDList.SOLAR_GLOW_EFFECT,param1,5635840,40,true,null);
         this.pulseTime = 1;
         this.glowStrength = 0.5;
      }
   }
}

