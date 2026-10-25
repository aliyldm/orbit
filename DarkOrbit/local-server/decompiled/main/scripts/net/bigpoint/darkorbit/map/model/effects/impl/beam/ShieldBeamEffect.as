package net.bigpoint.darkorbit.map.model.effects.impl.beam
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class ShieldBeamEffect extends BeamEffect
   {
      
      public function ShieldBeamEffect(param1:int, param2:MapEntity, param3:MapEntity)
      {
         super(EffectIDList.CHARGE_SHIELD_BEAM_EFFECT,param2,param3,param1,4278255615,InGameCatalog.SOUND_ID_AEGIS_SHIELD_RECHARGE);
      }
   }
}

