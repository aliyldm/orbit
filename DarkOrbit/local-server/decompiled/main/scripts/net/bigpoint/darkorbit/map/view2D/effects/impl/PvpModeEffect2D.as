package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.PvpModeEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class PvpModeEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function PvpModeEffect2D(param1:MapView2D, param2:PvpModeEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         start();
      }
   }
}

