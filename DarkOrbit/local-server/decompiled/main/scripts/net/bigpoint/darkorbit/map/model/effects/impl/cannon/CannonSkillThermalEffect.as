package net.bigpoint.darkorbit.map.model.effects.impl.cannon
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class CannonSkillThermalEffect extends MapObjectEffect
   {
      
      public function CannonSkillThermalEffect(param1:MapEntity)
      {
         super(EffectIDList.CANNON_SKILL_THERMAL,param1,NOT_PERSISTANT);
      }
   }
}

