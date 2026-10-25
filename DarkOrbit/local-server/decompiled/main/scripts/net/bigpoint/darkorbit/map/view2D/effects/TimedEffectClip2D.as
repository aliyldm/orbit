package net.bigpoint.darkorbit.map.view2D.effects
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class TimedEffectClip2D
   {
      
      public function TimedEffectClip2D()
      {
         super();
      }
      
      public static function play(param1:MovieClip, param2:DisplayObject, param3:Boolean, param4:Function = null) : void
      {
         stop(param1);
         param1.gotoAndStop(1);
         var _loc5_:Number = Boolean(param2) && Boolean(param2.stage) ? param2.stage.frameRate : 60;
         TweenMax.to(param1,param1.totalFrames / _loc5_,{
            "frame":param1.totalFrames,
            "ease":Linear.easeNone,
            "repeat":(param3 ? -1 : 0),
            "onComplete":param4
         });
      }
      
      public static function stop(param1:MovieClip) : void
      {
         if(!param1)
         {
            return;
         }
         TweenMax.killTweensOf(param1);
         param1.addFrameScript(param1.totalFrames - 1,null);
         param1.stop();
      }
   }
}

