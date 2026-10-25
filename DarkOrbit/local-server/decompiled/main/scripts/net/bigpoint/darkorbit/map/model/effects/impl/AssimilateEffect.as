package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class AssimilateEffect extends MapObjectEffect
   {
      
      public function AssimilateEffect(param1:MapEntity)
      {
         super(EffectIDList.ASSIMILATE,param1);
      }
   }
}

