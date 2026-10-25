package net.bigpoint.darkorbit.map.view2D.effects.impl.strikeAndExit
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import net.bigpoint.darkorbit.map.model.effects.impl.strikeAndExit.EscapeZoneEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.template.SimpleEffect2D;
   
   public class EscapeZoneEffect2D extends SimpleEffect2D
   {
      
      public function EscapeZoneEffect2D(param1:MapView2D, param2:EscapeZoneEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         super.initEffectVisuals();
         var _loc1_:Number = MovieClip(this.clip).framesLoaded * frameDuration;
         TweenMax.to(this.clip,_loc1_,{
            "ease":Linear.easeNone,
            "frame":MovieClip(this.clip).framesLoaded,
            "onComplete":this.handleEffectComplete
         });
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

