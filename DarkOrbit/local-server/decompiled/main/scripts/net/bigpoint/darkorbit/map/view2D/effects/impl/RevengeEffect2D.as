package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.RevengeEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class RevengeEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function RevengeEffect2D(param1:MapView2D, param2:RevengeEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         start();
      }
   }
}

