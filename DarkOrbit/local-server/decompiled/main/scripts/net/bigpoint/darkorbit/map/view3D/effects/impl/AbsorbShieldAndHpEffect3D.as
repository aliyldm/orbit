package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.beam.BeamEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class AbsorbShieldAndHpEffect3D extends BeamEffect3D
   {
      
      private static const PARTICLES_FILE:String = "laser_absorb_shield_hp.zip";
      
      private const MAX_DIST:Number = 1820;
      
      public function AbsorbShieldAndHpEffect3D(param1:MapView3D, param2:BeamEffect)
      {
         super(param2,PARTICLES_FILE,param2.target.position,param2.source.position,0,false,this.MAX_DIST);
      }
   }
}

