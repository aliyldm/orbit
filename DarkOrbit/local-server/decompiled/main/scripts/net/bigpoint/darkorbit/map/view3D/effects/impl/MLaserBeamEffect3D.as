package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.beam.BeamEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class MLaserBeamEffect3D extends BeamEffect3D
   {
      
      private static const PARTICLES_FILE:String = "beam_chain_bolt_02.zip";
      
      public function MLaserBeamEffect3D(param1:MapView3D, param2:BeamEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position,param2.target.position);
         _denominatorX = 230;
         _denominatorZ = 100;
      }
   }
}

