package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.AssimilateEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class AssimilateEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function AssimilateEffect2D(param1:MapView2D, param2:AssimilateEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         start();
      }
   }
}

