package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.glow.AbstractShipGlowEffect;
   
   public class RageEffect extends AbstractShipGlowEffect
   {
      
      public function RageEffect(param1:MapEntity)
      {
         super(EffectIDList.RAGE,param1,16711680,40,true,null,InGameCatalog.SOUND_ID_PIRATE_RAGE);
         this.pulseTime = 0.5;
         this.glowStrength = 0.4;
      }
   }
}

