package net.bigpoint.darkorbit.map.model.effects.impl.glow
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class EmbracingGlowEffect extends AbstractShipGlowEffect
   {
      
      public function EmbracingGlowEffect(param1:MapEntity)
      {
         super(EffectIDList.EMBRACING_GLOW_EFFECT,param1,15903743,40);
         this.pulseTime = 1;
         this.glowStrength = 1;
      }
   }
}

