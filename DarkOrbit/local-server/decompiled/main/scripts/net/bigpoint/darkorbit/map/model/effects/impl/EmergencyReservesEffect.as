package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class EmergencyReservesEffect extends MapObjectEffect
   {
      
      public function EmergencyReservesEffect(param1:MapEntity)
      {
         super(EffectIDList.EMERGENCY_RESERVES,param1);
      }
   }
}

