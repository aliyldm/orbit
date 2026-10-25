package net.bigpoint.darkorbit.map.model.effects.impl.beam
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class MLaserBeamEffect extends BeamEffect
   {
      
      public function MLaserBeamEffect(param1:int, param2:Ship, param3:Ship)
      {
         super(EffectIDList.M_LASER_BEAM_EFFECT,param2,param3,param1,4294901760);
      }
   }
}

