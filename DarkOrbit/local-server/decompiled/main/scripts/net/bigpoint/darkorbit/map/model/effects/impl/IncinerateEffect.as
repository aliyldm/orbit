package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class IncinerateEffect extends MapObjectEffect
   {
      
      public function IncinerateEffect(param1:MapEntity)
      {
         super(EffectIDList.INCINERATE,param1);
      }
      
      override public function get ignoresCloak() : Boolean
      {
         return false;
      }
   }
}

