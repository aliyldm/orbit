package net.bigpoint.darkorbit.map.view3D.effects.impl.cannon
{
   import net.bigpoint.darkorbit.map.model.effects.impl.cannon.CannonSkillThermalEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.StandaloneParticle3D;
   
   public class CannonSkillThermalEffect3D extends StandaloneParticle3D
   {
      
      public function CannonSkillThermalEffect3D(param1:MapView3D, param2:CannonSkillThermalEffect)
      {
         super(param2,"cannon_skill_thermal.zip",param2.source.position,null,true,0,true,1.2);
         scale = 1;
      }
      
      override protected function updateScale() : void
      {
      }
   }
}

