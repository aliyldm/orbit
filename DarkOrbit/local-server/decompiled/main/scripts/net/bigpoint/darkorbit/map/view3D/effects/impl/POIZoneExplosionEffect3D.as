package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.bigpoint.utils.bindables.BindablePointLite;
   import net.bigpoint.darkorbit.map.model.effects.impl.POIZoneExplosionEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class POIZoneExplosionEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "poizone_explosion.zip";
      
      public function POIZoneExplosionEffect3D(param1:MapView3D, param2:POIZoneExplosionEffect)
      {
         super(param2,PARTICLES_FILE,new BindablePointLite(param2.position.x,param2.position.y));
      }
   }
}

