package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.IncinerateEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class IncinerateEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function IncinerateEffect2D(param1:MapView2D, param2:IncinerateEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         effectMc.scaleX = 3.3;
         effectMc.scaleY = 3.3;
         start();
      }
   }
}

