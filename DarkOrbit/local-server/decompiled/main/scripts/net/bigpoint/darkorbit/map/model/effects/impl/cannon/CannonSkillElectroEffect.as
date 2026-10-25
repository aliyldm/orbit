package net.bigpoint.darkorbit.map.model.effects.impl.cannon
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AbstractBoltEffect;
   
   public class CannonSkillElectroEffect extends AbstractBoltEffect
   {
      
      public function CannonSkillElectroEffect(param1:MapEntity, param2:Array)
      {
         super(EffectIDList.CANNON_SKILL_ELECTRO,param1,param2,NOT_PERSISTANT);
      }
   }
}

