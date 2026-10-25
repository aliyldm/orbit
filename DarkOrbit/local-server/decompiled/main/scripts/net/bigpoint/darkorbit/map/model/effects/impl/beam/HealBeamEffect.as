package net.bigpoint.darkorbit.map.model.effects.impl.beam
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class HealBeamEffect extends BeamEffect
   {
      
      public function HealBeamEffect(param1:int, param2:MapEntity, param3:MapEntity)
      {
         super(EffectIDList.HEALBEAM_EFFECT,param2,param3,param1,4278255360,InGameCatalog.SOUND_ID_AEGIS_HEALING_BEAM);
      }
   }
}

