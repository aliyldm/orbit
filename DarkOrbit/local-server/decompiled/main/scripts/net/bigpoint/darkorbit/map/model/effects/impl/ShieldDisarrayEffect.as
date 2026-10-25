package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class ShieldDisarrayEffect extends MapObjectEffect
   {
      
      public function ShieldDisarrayEffect(param1:MapEntity)
      {
         super(EffectIDList.SHIELD_DISARRAY,param1);
      }
      
      override public function get ignoresCloak() : Boolean
      {
         return true;
      }
   }
}

