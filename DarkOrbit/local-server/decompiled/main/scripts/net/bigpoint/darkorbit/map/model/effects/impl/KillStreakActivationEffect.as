package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class KillStreakActivationEffect extends MapObjectEffect
   {
      
      public function KillStreakActivationEffect(param1:Ship, param2:int)
      {
         super(param2,param1,NOT_PERSISTANT);
      }
   }
}

