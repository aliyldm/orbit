package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import flash.display.MovieClip;
   import net.bigpoint.darkorbit.map.model.effects.impl.KillStreakTrailEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractShipEffect2D;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class KillStreakTrailEffect2D extends AbstractShipEffect2D
   {
      
      public function KillStreakTrailEffect2D(param1:MapView2D, param2:KillStreakTrailEffect)
      {
         super(param1,param2);
         Settings.qualityShip.changed.add(this.updateBySetting);
         fps = 24;
      }
      
      private function updateBySetting() : void
      {
         var _loc1_:int = Settings.qualityShip.value;
         if(_loc1_ < Settings.QUALITY_MEDIUM)
         {
            stopAnimation(false);
            this.clip.visible = true;
            this.clip.alpha = 1;
         }
         else
         {
            playAnimation(true);
         }
      }
      
      override protected function initEffectVisuals() : void
      {
         var _loc1_:MovieClip = shipView.base.clip;
         var _loc2_:Number = 1;
         if(_loc1_)
         {
            _loc2_ = Math.max(MovieClipUtils.movieClipMaxWidth(_loc1_) / clip.width,MovieClipUtils.movieClipMaxHeight(_loc1_) / clip.height);
         }
         clip.y -= 10 * _loc2_;
         this.updateBySetting();
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         Settings.qualityShip.changed.remove(this.updateBySetting);
         super.disposeView(param1);
      }
   }
}

