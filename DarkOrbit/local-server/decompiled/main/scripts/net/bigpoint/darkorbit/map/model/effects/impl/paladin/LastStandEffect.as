package net.bigpoint.darkorbit.map.model.effects.impl.paladin
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class LastStandEffect extends MapObjectEffect
   {
      
      public function LastStandEffect(param1:MapEntity, param2:EffectPattern = null)
      {
         super(EffectIDList.LAST_STAND,param1,NOT_PERSISTANT,param2 ? param2 : new EffectPattern(EffectIDList.LAST_STAND,"lastStand"));
      }
      
      override public function get ignoresCloak() : Boolean
      {
         return true;
      }
   }
}

