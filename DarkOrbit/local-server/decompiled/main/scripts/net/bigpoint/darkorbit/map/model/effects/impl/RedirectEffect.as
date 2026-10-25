package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class RedirectEffect extends MapObjectEffect
   {
      
      public function RedirectEffect(param1:MapEntity)
      {
         super(EffectIDList.REDIRECT,param1);
      }
      
      override public function get ignoresCloak() : Boolean
      {
         return true;
      }
   }
}

