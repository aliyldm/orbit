package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.EmergencyRepairEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class EmergencyRepairEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "abstract_ui_emergency_repair.zip";
      
      public function EmergencyRepairEffect3D(param1:MapView3D, param2:EmergencyRepairEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
      }
   }
}

