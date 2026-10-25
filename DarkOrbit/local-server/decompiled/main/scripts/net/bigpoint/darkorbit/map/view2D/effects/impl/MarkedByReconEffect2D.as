package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.MarkedByReconEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class MarkedByReconEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function MarkedByReconEffect2D(param1:MapView2D, param2:MarkedByReconEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         setClip(ResourceManager.getMovieClip("ui","markTarget"));
         fps = 60;
         playAnimation(true,1,true);
      }
   }
}

