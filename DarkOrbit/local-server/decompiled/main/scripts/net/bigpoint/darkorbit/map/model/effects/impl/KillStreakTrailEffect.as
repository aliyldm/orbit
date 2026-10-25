package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class KillStreakTrailEffect extends MapObjectEffect
   {
      
      public function KillStreakTrailEffect(param1:Ship, param2:int)
      {
         super(param2,param1,PERSISTANT);
      }
   }
}

