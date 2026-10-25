package net.bigpoint.darkorbit.map.model.effects.impl.cannon
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class CannonSkillCorrosiveEffect extends MapObjectEffect
   {
      
      public function CannonSkillCorrosiveEffect(param1:MapEntity)
      {
         super(EffectIDList.CANNON_SKILL_CORROSIVE,param1,PERSISTANT,new EffectPattern(EffectIDList.CANNON_SKILL_CORROSIVE,"cannon_skill_corrosive"));
      }
   }
}

