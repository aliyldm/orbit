package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.ValentineBuffEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class ValentineBuffEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function ValentineBuffEffect2D(param1:MapView2D, param2:ValentineBuffEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         effectMc.scaleX = 1.8;
         effectMc.scaleY = 1.8;
         start();
      }
   }
}

