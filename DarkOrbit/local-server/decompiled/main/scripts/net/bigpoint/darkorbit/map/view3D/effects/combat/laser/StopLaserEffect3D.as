package net.bigpoint.darkorbit.map.view3D.effects.combat.laser
{
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.StopLaserEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class StopLaserEffect3D
   {
      
      public function StopLaserEffect3D(param1:MapView3D, param2:StopLaserEffect)
      {
         super();
         if(param2.attacker)
         {
            LaserSalvo3D.stopSalvos(param2.attacker);
         }
      }
   }
}

