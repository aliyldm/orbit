package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.MirroredControlsEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class MirroredControlsEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function MirroredControlsEffect2D(param1:MapView2D, param2:MirroredControlsEffect)
      {
         super(param1,param2);
      }
      
      override protected function get effectMovieClipName() : String
      {
         return "malusCloud";
      }
      
      override protected function initEffectVisuals() : void
      {
         start();
      }
   }
}

