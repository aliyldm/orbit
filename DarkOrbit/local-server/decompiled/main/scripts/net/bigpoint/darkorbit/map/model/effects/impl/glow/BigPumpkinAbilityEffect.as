package net.bigpoint.darkorbit.map.model.effects.impl.glow
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class BigPumpkinAbilityEffect extends AbstractShipGlowEffect
   {
      
      public function BigPumpkinAbilityEffect(param1:MapEntity, param2:uint)
      {
         super(EffectIDList.BIG_PUMPKIN_ABILITY_EFFECT,param1,param2,40);
         this.pulseTime = 1;
         this.glowStrength = 0.5;
      }
   }
}

