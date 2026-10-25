package net.bigpoint.darkorbit.fui.components.list.slideshow.transitions
{
   import com.greensock.TweenLite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   
   public class CrossFadeTransition implements IItemTransition
   {
      
      private var _duration:Number = 0.5;
      
      public function CrossFadeTransition()
      {
         super();
      }
      
      public function fromTo(param1:Coreponent, param2:Coreponent) : void
      {
         param2.alpha = 0;
         TweenLite.to(param2,this._duration,{"autoAlpha":1});
         TweenLite.to(param1,this._duration,{"autoAlpha":0});
      }
   }
}

