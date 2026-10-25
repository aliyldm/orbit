package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class StickBombEffect extends AbstractStickyBombEffect
   {
      
      public function StickBombEffect(param1:MapEntity, param2:MapEntity, param3:String)
      {
         super(EffectIDList.STICKYBOMB_EFFECT,param1,param2,param3);
      }
   }
}

