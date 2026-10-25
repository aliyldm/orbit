package net.bigpoint.darkorbit.map.view3D.effects.impl.cannon
{
   import net.bigpoint.darkorbit.map.model.effects.impl.cannon.CannonThermalWavesEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.StandaloneParticle3D;
   
   public class CannonThermalWavesEffect3D extends StandaloneParticle3D
   {
      
      public function CannonThermalWavesEffect3D(param1:MapView3D, param2:CannonThermalWavesEffect)
      {
         super(param2,"cannon_thermal_waves.zip",param2.source.position);
      }
   }
}

