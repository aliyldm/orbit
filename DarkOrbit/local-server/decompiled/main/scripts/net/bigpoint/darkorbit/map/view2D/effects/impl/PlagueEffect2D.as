package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import flash.display.MovieClip;
   import net.bigpoint.darkorbit.map.model.effects.impl.PlagueEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractShipEffect2D;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class PlagueEffect2D extends AbstractShipEffect2D
   {
      
      public function PlagueEffect2D(param1:MapView2D, param2:PlagueEffect)
      {
         super(param1,param2);
         fps = 24;
      }
      
      override protected function initEffectVisuals() : void
      {
         var _loc1_:MovieClip = shipView.base.clip;
         var _loc2_:Number = 1;
         if(_loc1_)
         {
            _loc2_ = Math.max(MovieClipUtils.movieClipMaxWidth(_loc1_) / clip.width,MovieClipUtils.movieClipMaxHeight(_loc1_) / clip.height);
         }
         MovieClipUtils.scale(clip,_loc2_ + 0.4);
         playAnimation(true);
      }
   }
}

