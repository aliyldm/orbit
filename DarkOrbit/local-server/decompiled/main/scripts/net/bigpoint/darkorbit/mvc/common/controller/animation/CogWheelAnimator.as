package net.bigpoint.darkorbit.mvc.common.controller.animation
{
   import flash.display.MovieClip;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class CogWheelAnimator
   {
      
      private var _big:MovieClip;
      
      private var _small:MovieClip;
      
      private var _interval:uint;
      
      public function CogWheelAnimator(param1:MovieClip, param2:MovieClip)
      {
         super();
         this._small = param1;
         this._big = param2;
      }
      
      public function set playing(param1:Boolean) : void
      {
         clearInterval(this._interval);
         if(param1)
         {
            this._interval = setInterval(this.update,1);
         }
      }
      
      private function update() : void
      {
         ++this._small.rotation;
         --this._big.rotation;
      }
   }
}

