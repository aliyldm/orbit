package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class WarpPowerupEffect2D extends AbstractMapObjectEffect2D
   {
      
      private var _shockRing:MovieClip;
      
      private var _thunderbolt:MovieClip;
      
      public function WarpPowerupEffect2D(param1:MapView2D, param2:MapObjectEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         playAnimation();
         ResourceManager.fileCollection.load("shockwaves",this.handleRequestedAssetLoaded);
         scaleX = 0.3;
         scaleY = 0.3;
         TweenLite.to(this,2.5,{
            "scaleX":1,
            "scaleY":1
         });
         TweenLite.delayedCall(2.5,this.delayCompleteHandler);
      }
      
      private function handleRequestedAssetLoaded(param1:SWFFinisher) : void
      {
         if(mapObjectView)
         {
            this._thunderbolt = param1.getEmbeddedMovieClip("blitz");
            this._shockRing = param1.getEmbeddedMovieClip("shockringUltimate");
            addChild(this._thunderbolt);
         }
      }
      
      private function delayCompleteHandler() : void
      {
         stopAnimation(false);
         if(this._shockRing)
         {
            this._shockRing.scaleX = 0.1;
            this._shockRing.scaleY = 0.1;
            addChild(this._shockRing);
            TweenLite.to(this._shockRing,0.6,{
               "scaleX":3,
               "scaleY":3,
               "alpha":0
            });
         }
         clip.cacheAsBitmap = true;
         TweenLite.to(clip,0.6,{
            "scaleX":3,
            "scaleY":3
         });
         TweenLite.to(mapObjectView,0.6,{
            "autoAlpha":0,
            "onComplete":this.handleEffectFinished
         });
      }
      
      private function handleEffectFinished() : void
      {
         TweenLite.killTweensOf(this._shockRing);
         TweenLite.killTweensOf(clip);
         TweenLite.killTweensOf(mapObjectView);
         TweenLite.killTweensOf(this);
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         TweenMax.killTweensOf(mapObjectView);
         TweenMax.killDelayedCallsTo(this.delayCompleteHandler);
         mapObjectView.alpha = 1;
         mapObjectView.visible = true;
         if(this._shockRing)
         {
            TweenMax.killTweensOf(this._shockRing);
            TweenMax.killDelayedCallsTo(this._shockRing);
         }
         MovieClipUtils.removeDisplayObject(this._thunderbolt);
         MovieClipUtils.removeDisplayObject(this._shockRing);
         super.disposeView(param1);
      }
   }
}

