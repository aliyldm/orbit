package net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class BossEmpShockEffect extends MapObjectEffect
   {
      
      public function BossEmpShockEffect(param1:MapEntity)
      {
         super(EffectIDList.BOSS_EMP_SHOCK,param1,NOT_PERSISTANT,new EffectPattern(EffectIDList.BOSS_EMP_SHOCK,"boss_emp_shock"));
      }
   }
}

