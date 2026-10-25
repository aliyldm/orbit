package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class PvpProtectionEffect extends MapObjectEffect
   {
      
      public function PvpProtectionEffect(param1:MapEntity)
      {
         super(EffectIDList.PVP_PROTECTION,param1,PERSISTANT,new EffectPattern(EffectIDList.PVP_PROTECTION,"invincibilityShieldPvp"),InGameCatalog.SOUND_ID_PIRATE_INVINCIBILITY);
      }
   }
}

