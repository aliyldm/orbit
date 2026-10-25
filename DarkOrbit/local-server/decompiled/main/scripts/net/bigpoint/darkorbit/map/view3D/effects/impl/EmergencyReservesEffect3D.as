package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.EmergencyReservesEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class EmergencyReservesEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "tech_emergency-reserves.zip";
      
      public function EmergencyReservesEffect3D(param1:MapView3D, param2:EmergencyReservesEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
      }
   }
}

