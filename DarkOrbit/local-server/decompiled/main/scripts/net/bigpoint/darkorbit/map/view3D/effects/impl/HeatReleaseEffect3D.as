package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.HeatReleaseEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class HeatReleaseEffect3D extends StandaloneParticle3D
   {
      
      private static const URL:String = "pet-gear_heat-release.zip";
      
      public function HeatReleaseEffect3D(param1:MapView3D, param2:HeatReleaseEffect)
      {
         super(param2,URL,param2.source.position);
         this.fixedScale = param2.radius / 150;
      }
   }
}

