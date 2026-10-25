package net.bigpoint.darkorbit.map.model.effects.impl.glow
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class WargameGlowEffect extends AbstractShipGlowEffect
   {
      
      public function WargameGlowEffect(param1:Ship, param2:Boolean)
      {
         super(EffectIDList.WARGAME_GLOW_EFFECT,param1,param2 ? 16724736 : 52479);
         this.glowStrength = 0.5;
      }
   }
}

