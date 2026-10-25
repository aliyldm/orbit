package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.EmergencyReservesEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class EmergencyReservesEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function EmergencyReservesEffect2D(param1:MapView2D, param2:EmergencyReservesEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         effectMc.y = -20;
         start();
      }
   }
}

