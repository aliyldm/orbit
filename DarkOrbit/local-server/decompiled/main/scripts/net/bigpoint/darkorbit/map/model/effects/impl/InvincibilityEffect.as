package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class InvincibilityEffect extends MapObjectEffect
   {
      
      public function InvincibilityEffect(param1:MapEntity)
      {
         super(EffectIDList.INVINCIBILITY,param1,PERSISTANT,new EffectPattern(EffectIDList.INVINCIBILITY,"invincibilityShield"),InGameCatalog.SOUND_ID_PIRATE_INVINCIBILITY);
      }
   }
}

