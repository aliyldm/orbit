package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class ValentineBuffEffect extends MapObjectEffect
   {
      
      public function ValentineBuffEffect(param1:MapEntity)
      {
         super(EffectIDList.VALENTINE_BUFF,param1);
      }
      
      override public function get ignoresCloak() : Boolean
      {
         return false;
      }
   }
}

