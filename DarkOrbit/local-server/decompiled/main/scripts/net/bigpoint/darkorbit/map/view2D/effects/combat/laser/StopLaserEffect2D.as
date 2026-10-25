package net.bigpoint.darkorbit.map.view2D.effects.combat.laser
{
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.StopLaserEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   
   public class StopLaserEffect2D
   {
      
      public function StopLaserEffect2D(param1:MapView2D, param2:StopLaserEffect)
      {
         super();
         if(param2.attacker)
         {
            LaserSalvo2D.stopSalvos(param2.attacker);
         }
      }
   }
}

