package net.bigpoint.darkorbit.map.model.effects.impl.glow
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class HomeBonusEffect extends AbstractShipGlowEffect
   {
      
      public function HomeBonusEffect(param1:MapEntity)
      {
         super(EffectIDList.HOME_BONUS_EFFECT,param1,65535,20,true,null);
         this.glowStrength = 0.3;
         this.pulseTime = 3;
      }
   }
}

