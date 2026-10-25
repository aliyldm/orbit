package net.bigpoint.darkorbit.map.view2D.effects.impl.publicWorldBoss
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss.BossShieldEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.template.SimpleEffect2D;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class BossShieldEffect2D extends SimpleEffect2D
   {
      
      public function BossShieldEffect2D(param1:MapView2D, param2:BossShieldEffect)
      {
         super(param1,param2);
      }
      
      protected function get bossShieldEffect() : BossShieldEffect
      {
         return this.effect as BossShieldEffect;
      }
      
      override protected function start() : void
      {
         playAnimation();
      }
      
      override protected function initEffectVisuals() : void
      {
         this.clip.visible = true;
         this.clip.scaleX = this.clip.scaleY = this.bossShieldEffect.level == 4 ? 4 : 2;
         var _loc1_:Number = MovieClip(this.clip).framesLoaded * frameDuration;
         TweenMax.to(this.clip,_loc1_,{
            "ease":Linear.easeNone,
            "frame":MovieClip(this.clip).framesLoaded,
            "onComplete":this.handleEffectComplete
         });
      }
      
      override protected function get effectMovieClipName() : String
      {
         return PatternManager.bossShieldPatterns[this.bossShieldEffect.level].resKey;
      }
      
      private function handleEffectComplete() : void
      {
         if(effect.activate())
         {
            playAnimation();
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(this.disposed)
         {
            return;
         }
         super.disposeView(param1);
      }
   }
}

