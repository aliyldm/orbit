package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.LevelUpEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class LevelUpEffect2D extends AbstractMapObjectEffect2D
   {
      
      private static const STD_FRAME_DURATION:Number = 0.04;
      
      public function LevelUpEffect2D(param1:MapView2D, param2:LevelUpEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_LEVEL_UP,false,false);
         this.clip.visible = true;
         this.clip.y -= 50;
         var _loc1_:Number = MovieClip(this.clip).framesLoaded * STD_FRAME_DURATION;
         TweenMax.to(this.clip,_loc1_,{
            "ease":Linear.easeNone,
            "frame":MovieClip(this.clip).framesLoaded,
            "onComplete":this.disposeView
         });
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         TweenMax.killTweensOf(this.clip);
         super.disposeView(param1);
      }
   }
}

