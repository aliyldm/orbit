package net.bigpoint.darkorbit.map.model.effects.impl.beam
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class DamageTransferBeamEffect extends BeamEffect
   {
      
      public function DamageTransferBeamEffect(param1:int, param2:Ship, param3:Ship)
      {
         super(EffectIDList.DAMAGE_TRANSFER_BEAM_EFFECT,param2,param3,param1,4294901760);
      }
   }
}

