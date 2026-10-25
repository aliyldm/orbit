package net.bigpoint.darkorbit.map.model.effects.impl.combat
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class ChainBoltEffect extends AbstractBoltEffect
   {
      
      public function ChainBoltEffect(param1:MapEntity, param2:Array)
      {
         super(EffectIDList.CHAIN_BOLT,param1,param2,NOT_PERSISTANT);
      }
   }
}

