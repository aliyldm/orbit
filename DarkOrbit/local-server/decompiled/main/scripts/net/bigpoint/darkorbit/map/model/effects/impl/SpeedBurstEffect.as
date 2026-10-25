package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class SpeedBurstEffect extends MapObjectEffect
   {
      
      public function SpeedBurstEffect(param1:MapEntity)
      {
         super(EffectIDList.SPEED_BURST,param1);
      }
      
      override public function get ignoresCloak() : Boolean
      {
         return false;
      }
   }
}

