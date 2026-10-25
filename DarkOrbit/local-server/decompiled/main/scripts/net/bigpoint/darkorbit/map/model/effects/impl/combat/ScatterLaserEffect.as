package net.bigpoint.darkorbit.map.model.effects.impl.combat
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class ScatterLaserEffect extends MapObjectEffect
   {
      
      public function ScatterLaserEffect(param1:MapEntity)
      {
         super(EffectIDList.SCATTER_LASER,param1,PERSISTANT);
      }
   }
}

