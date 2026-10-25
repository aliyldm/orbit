package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class ProtectedEffect extends MapObjectEffect
   {
      
      public function ProtectedEffect(param1:MapEntity)
      {
         super(EffectIDList.PROTECTED_EFFECT,param1);
      }
   }
}

