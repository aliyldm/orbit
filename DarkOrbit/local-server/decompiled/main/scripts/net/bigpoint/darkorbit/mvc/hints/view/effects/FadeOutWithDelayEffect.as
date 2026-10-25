package net.bigpoint.darkorbit.mvc.hints.view.effects
{
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import net.bigpoint.darkorbit.mvc.hints.view.effects.interfaces.IShowHideEffect;
   
   public class FadeOutWithDelayEffect implements IShowHideEffect
   {
      
      private var _delayValue:Number;
      
      public function FadeOutWithDelayEffect(param1:Number = 1)
      {
         super();
         this._delayValue = param1;
      }
      
      public function show(param1:DisplayObject) : void
      {
         TweenLite.to(param1,1,{
            "autoAlpha":1,
            "onComplete":this.onFadeInComplete,
            "onCompleteParams":[param1]
         });
      }
      
      private function onFadeInComplete(param1:DisplayObject) : void
      {
         if(param1)
         {
            TweenLite.to(param1,0.5,{
               "delay":this._delayValue,
               "alpha":0.5
            });
         }
      }
      
      public function hide(param1:DisplayObject, param2:Function) : void
      {
         if(param1)
         {
            TweenLite.killTweensOf(param1);
            TweenLite.killDelayedCallsTo(param1);
            TweenLite.to(param1,0.5,{
               "autoAlpha":0,
               "onComplete":param2
            });
         }
      }
   }
}

