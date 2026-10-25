package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.beam.WorldBossContinuousLaserBeamEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class WorldBossContinuousLaserBeamEffect3D extends BeamEffect3D
   {
      
      private static const PARTICLES_FILE:String = "beam_chain_bolt_03.zip";
      
      public function WorldBossContinuousLaserBeamEffect3D(param1:MapView3D, param2:WorldBossContinuousLaserBeamEffect)
      {
         super(param2,PARTICLES_FILE,param2.sourcePosition,param2.targetPosition);
         _denominatorX = 240;
         _denominatorZ = 100;
      }
   }
}

