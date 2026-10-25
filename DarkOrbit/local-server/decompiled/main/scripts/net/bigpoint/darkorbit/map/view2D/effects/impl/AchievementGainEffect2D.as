package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import flash.media.Sound;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class AchievementGainEffect2D extends AbstractMapObjectEffect2D
   {
      
      private static const ANIMATION_SOUND_LINKAGE_ID:String = "soundfx";
      
      private static const STD_FRAME_DURATION:Number = 0.04;
      
      public function AchievementGainEffect2D(param1:MapView2D, param2:MapObjectEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         var _loc2_:Sound = null;
         if(Settings.playSFX.value)
         {
            _loc2_ = ResourceManager.getSound(pattern.resKey,ANIMATION_SOUND_LINKAGE_ID);
            if(_loc2_ != null)
            {
               _loc2_.play();
            }
         }
         this.clip.visible = true;
         this.clip.y -= 50;
         var _loc1_:Number = MovieClip(this.clip).framesLoaded * STD_FRAME_DURATION;
         TweenMax.to(this.clip,_loc1_,{
            "ease":Linear.easeNone,
            "frame":MovieClip(this.clip).framesLoaded,
            "onComplete":this.handleEffectFinished
         });
      }
      
      private function handleEffectFinished() : void
      {
         TweenMax.killTweensOf(this.clip);
         disposeView();
      }
   }
}

