package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class KillStreakCloudEffect extends MapObjectEffect
   {
      
      public function KillStreakCloudEffect(param1:Ship, param2:int)
      {
         super(param2,param1,PERSISTANT);
      }
   }
}

