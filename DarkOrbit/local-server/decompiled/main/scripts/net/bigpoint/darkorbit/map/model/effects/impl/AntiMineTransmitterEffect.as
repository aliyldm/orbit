package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class AntiMineTransmitterEffect extends MapObjectEffect
   {
      
      public function AntiMineTransmitterEffect(param1:MapEntity)
      {
         super(EffectIDList.ANTI_MINE_TRANSMITTER,param1,Effect.PERSISTANT);
      }
   }
}

