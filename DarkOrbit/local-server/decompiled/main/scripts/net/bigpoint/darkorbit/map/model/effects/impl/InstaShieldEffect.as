package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class InstaShieldEffect extends MapObjectEffect
   {
      
      public function InstaShieldEffect(param1:MapEntity)
      {
         super(EffectIDList.INSTA_SHIELD,param1,Effect.NOT_PERSISTANT,new EffectPattern(EffectIDList.INSTA_SHIELD,"instaShield"),InGameCatalog.SOUND_ID_INSTASHIELD_0);
      }
   }
}

