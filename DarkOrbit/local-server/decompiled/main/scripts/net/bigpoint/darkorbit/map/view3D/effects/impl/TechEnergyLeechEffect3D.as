package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.TechEnergyLeechEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class TechEnergyLeechEffect3D extends StandaloneParticle3D
   {
      
      private static const URL:String = "tech_energy_leech.zip";
      
      public function TechEnergyLeechEffect3D(param1:MapView3D, param2:TechEnergyLeechEffect)
      {
         super(param2,URL,param2.source.position);
      }
   }
}

