package net.bigpoint.darkorbit.map.view2D.effects.impl.cannon
{
   import net.bigpoint.darkorbit.map.model.effects.impl.cannon.CannonSkillThermalEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.StandaloneEffect2D;
   
   public class CannonSkillThermalEffect2D extends StandaloneEffect2D
   {
      
      public function CannonSkillThermalEffect2D(param1:MapView2D, param2:CannonSkillThermalEffect)
      {
         super(param1,param2,"cannon_skill_thermal",param2.source.position);
      }
   }
}

