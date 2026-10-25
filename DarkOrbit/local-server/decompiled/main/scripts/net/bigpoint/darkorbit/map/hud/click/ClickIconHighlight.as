package net.bigpoint.darkorbit.map.hud.click
{
   import com.greensock.TweenMax;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   
   public class ClickIconHighlight
   {
      
      private var _target:DisplayObjectContainer;
      
      private var _running:Boolean;
      
      private var _effect:MovieClip;
      
      public function ClickIconHighlight(param1:DisplayObjectContainer)
      {
         super();
         this._target = param1;
      }
      
      public function activate() : void
      {
         this._running = true;
         if(this._effect)
         {
            this.doHighlite();
            this.doOnionEffect();
         }
         else
         {
            ResourceManager.fileCollection.load("highlightEffect",this.handleAssetLoadComplete);
         }
      }
      
      public function deactivate() : void
      {
         this._running = false;
      }
      
      private function handleAssetLoadComplete(param1:SWFFinisher) : void
      {
         if(!this._running)
         {
            return;
         }
         this._effect = param1.getEmbeddedMovieClip("mc");
         if(this._effect)
         {
            this._target.addChild(this._effect);
            this.doHighlite();
            this.doOnionEffect();
         }
      }
      
      private function doHighlite() : void
      {
         if(this._running)
         {
            TweenMax.to(this._target,0.5,{
               "colorMatrixFilter":{
                  "brightness":1.5,
                  "contrast":1.5,
                  "saturation":1.5
               },
               "yoyo":true,
               "repeat":1,
               "onComplete":this.doHighlite
            });
         }
      }
      
      private function doOnionEffect() : void
      {
         if(this._running)
         {
            this._effect.alpha = 1;
            this._effect.visible = true;
            this._effect.scaleX = this._effect.scaleY = 1;
            this._effect.x = -this._effect.width / 2;
            this._effect.y = -this._effect.height - 34;
            TweenMax.to(this._effect,1,{
               "transformAroundCenter":{"scale":1.5},
               "autoAlpha":0,
               "onComplete":this.doOnionEffect
            });
         }
      }
   }
}

