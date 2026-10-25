package net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class BossEnergyBayEmpEffect extends MapObjectEffect
   {
      
      private var _range:int;
      
      public function BossEnergyBayEmpEffect(param1:MapEntity, param2:int)
      {
         super(EffectIDList.BOSS_ENERGY_BAY_EMP,param1,PERSISTANT,new EffectPattern(EffectIDList.BOSS_ENERGY_BAY_EMP,"bay_emp_shock"));
         this._range = param2;
      }
      
      public function get range() : int
      {
         return this._range;
      }
   }
}

