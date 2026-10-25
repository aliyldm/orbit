package net.bigpoint.darkorbit.map.model.effects.impl.cannon
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class CannonPositionAreaEffect extends MapObjectEffect
   {
      
      public function CannonPositionAreaEffect(param1:MapEntity)
      {
         super(EffectIDList.CANNON_POSITION_AREA,param1,PERSISTANT);
      }
   }
}

