package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class SpawnEffectWithFadeIn extends MapObjectEffect
   {
      
      public function SpawnEffectWithFadeIn(param1:MapEntity)
      {
         super(EffectIDList.EMPEROR_LORDAKIUM_SPAWN_EFFECT,param1,NOT_PERSISTANT);
      }
   }
}

