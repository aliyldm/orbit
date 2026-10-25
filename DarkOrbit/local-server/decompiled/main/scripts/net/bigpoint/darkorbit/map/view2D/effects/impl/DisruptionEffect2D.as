package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.DisruptionEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class DisruptionEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function DisruptionEffect2D(param1:MapView2D, param2:DisruptionEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         start();
      }
   }
}

