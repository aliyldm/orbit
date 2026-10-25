package net.bigpoint.darkorbit.map.view2D.effects.impl.template
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class SimpleEffect2D extends AbstractMapObjectEffect2D
   {
      
      protected var frameDuration:Number = 0.04;
      
      public function SimpleEffect2D(param1:MapView2D, param2:MapObjectEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         this.clip.visible = true;
         var _loc1_:Number = MovieClip(this.clip).framesLoaded * this.frameDuration;
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

