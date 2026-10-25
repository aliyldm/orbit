package net.bigpoint.darkorbit.map.view3D.effects.impl.cannon
{
   import net.bigpoint.darkorbit.map.model.effects.impl.cannon.CannonSkillCorrosiveEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.StandaloneParticle3D;
   
   public class CannonSkillCorrosiveEffect3D extends StandaloneParticle3D
   {
      
      public function CannonSkillCorrosiveEffect3D(param1:MapView3D, param2:CannonSkillCorrosiveEffect)
      {
         super(param2,"cannon_skill_corrosive.zip",param2.source.position);
      }
   }
}

