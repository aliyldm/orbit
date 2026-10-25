package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.glow.AbstractShipGlowEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class MayhemRageEffect extends AbstractShipGlowEffect
   {
      
      public function MayhemRageEffect(param1:Ship)
      {
         super(EffectIDList.MAYHEM_RAGE_EFFECT,param1,16758049,20);
         this.pulseTime = 1;
         this.glowStrength = 1.5;
         this.innerGlow = true;
      }
   }
}

