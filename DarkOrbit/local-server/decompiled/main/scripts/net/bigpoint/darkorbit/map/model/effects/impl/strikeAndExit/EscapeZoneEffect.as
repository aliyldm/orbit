package net.bigpoint.darkorbit.map.model.effects.impl.strikeAndExit
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class EscapeZoneEffect extends MapObjectEffect
   {
      
      public function EscapeZoneEffect(param1:MapEntity)
      {
         super(EffectIDList.ESCAPE_ZONE,param1,PERSISTANT,new EffectPattern(EffectIDList.ESCAPE_ZONE,"escape_zone"));
      }
   }
}

