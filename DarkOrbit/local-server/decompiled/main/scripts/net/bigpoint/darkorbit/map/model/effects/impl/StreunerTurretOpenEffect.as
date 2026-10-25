package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class StreunerTurretOpenEffect extends MapObjectEffect
   {
      
      public function StreunerTurretOpenEffect(param1:MapEntity)
      {
         super(EffectIDList.STREUNER_TURRET_OPEN_EFFECT,param1,NOT_PERSISTANT);
      }
   }
}

