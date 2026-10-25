package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class SpawnChildrenEffect extends MapObjectEffect
   {
      
      public function SpawnChildrenEffect(param1:MapEntity)
      {
         super(EffectIDList.SPAWN_CHILDREN_EFFECT,param1,PERSISTANT);
      }
   }
}

