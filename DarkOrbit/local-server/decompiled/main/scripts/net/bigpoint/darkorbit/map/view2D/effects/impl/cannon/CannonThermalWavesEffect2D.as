package net.bigpoint.darkorbit.map.view2D.effects.impl.cannon
{
   import net.bigpoint.darkorbit.map.model.effects.impl.cannon.CannonThermalWavesEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.StandaloneEffect2D;
   
   public class CannonThermalWavesEffect2D extends StandaloneEffect2D
   {
      
      public function CannonThermalWavesEffect2D(param1:MapView2D, param2:CannonThermalWavesEffect)
      {
         super(param1,param2,"cannon_thermal_waves",param2.source.position);
      }
   }
}

