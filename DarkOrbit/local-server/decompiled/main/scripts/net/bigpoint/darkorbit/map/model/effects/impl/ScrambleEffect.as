package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class ScrambleEffect extends MapObjectEffect
   {
      
      public function ScrambleEffect(param1:Ship)
      {
         super(EffectIDList.SCRAMBLE_EFFECT,param1);
      }
   }
}

