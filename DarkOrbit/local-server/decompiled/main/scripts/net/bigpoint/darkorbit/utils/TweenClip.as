package net.bigpoint.darkorbit.utils
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   
   public class TweenClip extends Sprite
   {
      
      private var _disposed:Boolean;
      
      private var _clip:DisplayObject;
      
      public var fps:int;
      
      private var currentStartFrame:int;
      
      public function TweenClip(param1:DisplayObject = null, param2:int = 30)
      {
         super();
         this._clip = param1;
         this.fps = param2;
      }
      
      public function setClip(param1:DisplayObject, param2:Boolean = true) : void
      {
         if(this._clip)
         {
            this.stopAnimation(false);
            MovieClipUtils.removeDisplayObject(this._clip);
            if(this._clip is BitmapClip)
            {
               BitmapClip(this._clip).stop();
            }
         }
         this._clip = param1;
         this.clip.visible = false;
         if(param2)
         {
            this.addChild(param1);
         }
         this.resetMovieClip();
      }
      
      private function resetMovieClip() : void
      {
         if(this.clip is MovieClip)
         {
            MovieClip(this.clip).gotoAndStop(this.currentStartFrame);
         }
         else if(this.clip is BitmapClip)
         {
            BitmapClip(this.clip).gotoAndStop(this.currentStartFrame);
         }
      }
      
      public function playAnimation(param1:Boolean = true, param2:int = 1, param3:Boolean = true, param4:Boolean = false, param5:Boolean = false) : void
      {
         var _loc6_:int = 0;
         var _loc8_:Number = NaN;
         this.stopAnimation(param3);
         this.currentStartFrame = param2;
         if(this.clip is MovieClip)
         {
            _loc6_ = MovieClip(this.clip).framesLoaded;
            MovieClip(this.clip).gotoAndStop(param2);
         }
         else if(this.clip is BitmapClip)
         {
            _loc6_ = BitmapClip(this.clip).framesLoaded;
            BitmapClip(this.clip).gotoAndStop(param2);
         }
         var _loc7_:Number = _loc6_ / this.fps;
         if(param5)
         {
            _loc6_ = 1;
         }
         _loc8_ = 0;
         this.clip.visible = true;
         if(param3)
         {
            _loc8_ = 0.5;
            this.clip.alpha = 0;
            TweenLite.to(this.clip,_loc8_,{
               "ease":Linear.easeNone,
               "alpha":1
            });
         }
         if(param1)
         {
            this.loopAnimation(_loc7_,_loc6_);
         }
         else if(param4)
         {
            this.animateAndRemoveObject(_loc7_,_loc6_);
         }
         else if(param3)
         {
            this.animateAndFadeOut(_loc7_,_loc6_);
         }
         else
         {
            this.animateAndStop(_loc7_,_loc6_);
         }
      }
      
      public function playInstantAnimation(param1:int = 1, param2:Boolean = true, param3:Boolean = false, param4:int = 3) : void
      {
         var _loc5_:int = 0;
         this.stopAnimation(param2);
         if(this.clip is MovieClip)
         {
            _loc5_ = MovieClip(this.clip).framesLoaded;
            MovieClip(this.clip).gotoAndStop(param1);
         }
         else if(this.clip is BitmapClip)
         {
            _loc5_ = BitmapClip(this.clip).framesLoaded;
            BitmapClip(this.clip).gotoAndStop(param1);
         }
         var _loc6_:Number = _loc5_ / this.fps;
         var _loc7_:Number = 0;
         this.clip.visible = true;
         if(param2)
         {
            this.clip.alpha = 0;
            this.fadeInClip(0.5);
         }
         this.instantAnimation(_loc6_,_loc5_,param4,param2);
      }
      
      private function instantAnimation(param1:Number, param2:int, param3:int, param4:Boolean = true) : void
      {
         this.resetMovieClip();
         if(param3 > 0)
         {
            TweenLite.to(this.clip,param1,{
               "ease":Linear.easeNone,
               "frame":param2,
               "onComplete":this.instantAnimation,
               "onCompleteParams":[param1,param2,--param3]
            });
         }
         else if(param4)
         {
            this.fadeOutClip(0.5);
         }
      }
      
      private function loopAnimation(param1:Number, param2:int) : void
      {
         this.resetMovieClip();
         TweenLite.to(this.clip,param1,{
            "ease":Linear.easeNone,
            "frame":param2,
            "onComplete":this.loopAnimation,
            "onCompleteParams":[param1,param2]
         });
      }
      
      private function animateAndRemoveObject(param1:Number, param2:int) : void
      {
         TweenLite.to(this.clip,param1,{
            "ease":Linear.easeNone,
            "frame":param2,
            "onComplete":this.disposeView
         });
      }
      
      private function animateAndFadeOut(param1:Number, param2:int) : void
      {
         TweenLite.to(this.clip,param1,{
            "ease":Linear.easeNone,
            "frame":param2,
            "onComplete":this.fadeOutClip,
            "onCompleteParams":[0.5]
         });
      }
      
      private function animateAndStop(param1:Number, param2:int) : void
      {
         TweenLite.to(this.clip,param1,{
            "ease":Linear.easeNone,
            "frame":param2
         });
      }
      
      public function stopAnimation(param1:Boolean = true) : void
      {
         if(this.clip == null)
         {
            return;
         }
         TweenLite.killTweensOf(this.clip);
         if(param1)
         {
            this.fadeOutClip(0.5);
         }
      }
      
      public function fadeInClip(param1:Number) : void
      {
         TweenLite.to(this.clip,param1,{
            "ease":Linear.easeNone,
            "alpha":1
         });
      }
      
      public function fadeOutClip(param1:Number) : void
      {
         TweenLite.to(this.clip,param1,{
            "ease":Linear.easeNone,
            "alpha":0
         });
      }
      
      public function scaleClip(param1:Number, param2:Number = 0, param3:Number = 0, param4:Number = 0) : void
      {
         TweenLite.to(this.clip,param1,{
            "scaleX":param2,
            "scaleY":param3,
            "scaleZ":param4
         });
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this._disposed = true;
         this.stopAnimation(false);
         MovieClipUtils.removeDisplayObject(this);
         MovieClipUtils.removeDisplayObject(this._clip);
         if(this._clip is BitmapClip)
         {
            BitmapClip(this._clip).stop();
         }
      }
      
      public function get clip() : DisplayObject
      {
         return this._clip;
      }
      
      protected function get disposed() : Boolean
      {
         return this._disposed;
      }
   }
}

