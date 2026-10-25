package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class VenomEffect extends MapObjectEffect
   {
      
      public function VenomEffect(param1:MapEntity, param2:int = 1, param3:EffectPattern = null, param4:int = -1)
      {
         super(EffectIDList.VENOM_EFFECT,param1,param2,param3,param4);
      }
   }
}

