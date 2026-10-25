package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.beam.BeamEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class DamageTrasferBeamEffect3D extends BeamEffect3D
   {
      
      private static const PARTICLES_FILE:String = "beam_damage_transfer.zip";
      
      public function DamageTrasferBeamEffect3D(param1:MapView3D, param2:BeamEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position,param2.target.position);
      }
   }
}

