package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class EmergencyRepairEffect extends MapObjectEffect
   {
      
      public function EmergencyRepairEffect(param1:MapEntity)
      {
         super(EffectIDList.EMERGENCY_REPAIR_EFFECT,param1);
      }
   }
}

