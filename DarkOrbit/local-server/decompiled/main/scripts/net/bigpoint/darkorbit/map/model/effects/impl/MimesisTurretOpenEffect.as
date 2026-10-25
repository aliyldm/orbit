package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class MimesisTurretOpenEffect extends MapObjectEffect
   {
      
      public function MimesisTurretOpenEffect(param1:MapEntity)
      {
         super(EffectIDList.MIMESIS_TURRET_OPEN_EFFECT,param1,NOT_PERSISTANT);
      }
   }
}

