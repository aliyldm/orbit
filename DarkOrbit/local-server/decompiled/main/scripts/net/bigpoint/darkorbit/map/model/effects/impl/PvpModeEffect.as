package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class PvpModeEffect extends MapObjectEffect
   {
      
      public function PvpModeEffect(param1:MapEntity)
      {
         super(EffectIDList.PVP_MODE,param1);
      }
      
      override public function get ignoresCloak() : Boolean
      {
         return false;
      }
   }
}

