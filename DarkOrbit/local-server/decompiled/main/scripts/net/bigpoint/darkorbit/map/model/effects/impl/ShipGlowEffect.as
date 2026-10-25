package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.glow.AbstractShipGlowEffect;
   
   public class ShipGlowEffect extends AbstractShipGlowEffect
   {
      
      public function ShipGlowEffect(param1:MapEntity, param2:uint)
      {
         super(EffectIDList.SHIP_GLOW_EFFECT,param1,param2,40,true,null,InGameCatalog.SOUND_ID_PIRATE_RAGE);
         this.pulseTime = 0.5;
         this.glowStrength = 3;
      }
   }
}

