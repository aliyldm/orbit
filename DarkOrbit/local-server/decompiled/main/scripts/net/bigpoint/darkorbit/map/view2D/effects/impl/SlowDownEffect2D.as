package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import flash.events.Event;
   import net.bigpoint.darkorbit.lazyload.AssetLazyLoader;
   import net.bigpoint.darkorbit.map.model.effects.impl.SlowDownEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractShipEffect2D;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class SlowDownEffect2D extends AbstractShipEffect2D
   {
      
      private var _clipStationary:MovieClip;
      
      private var _clipMoving:MovieClip;
      
      public function SlowDownEffect2D(param1:MapView2D, param2:SlowDownEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         this._clipStationary = MovieClip(this.effectMc).stationary;
         this._clipMoving = MovieClip(this.effectMc).moving;
         this.start();
         this._clipStationary.alpha = 0;
         this._clipMoving.alpha = 0;
         this.handleRotation();
         ship.moveTrait.moveStarted.add(this.actionOnMovingRotation);
         ship.moveTrait.moveStopped.add(this.actionOnStationaryRotation);
      }
      
      private function handleRotation() : void
      {
         if(ship.moveTrait.isMoving)
         {
            this.actionOnMovingRotation();
         }
         else
         {
            this.actionOnStationaryRotation();
         }
      }
      
      override protected function start() : void
      {
         var _loc1_:AssetLazyLoader = null;
         if(this.effectMc != null)
         {
            this.handlePlayOnLoaded();
         }
         else
         {
            _loc1_ = new AssetLazyLoader();
            _loc1_.addEventListener(AssetLazyLoader.ASSET_LOADED,this.handlePlayOnLoaded);
            _loc1_.loadAsset(pattern.resKey);
         }
      }
      
      private function handlePlayOnLoaded(param1:Event = null) : void
      {
         this.effectMc.visible = true;
         MovieClipUtils.playAnimation(this._clipMoving,15,true);
         MovieClipUtils.playAnimation(this._clipStationary,15,true);
      }
      
      private function actionOnMovingRotation() : void
      {
         TweenLite.to(this._clipMoving,1,{
            "ease":Linear.easeNone,
            "alpha":1
         });
         TweenLite.to(this._clipStationary,0.7,{
            "ease":Linear.easeNone,
            "alpha":0
         });
         TweenLite.to(this.effectMc,0.125,{"shortRotation":{"rotation":ship.rotation.degrees}});
      }
      
      private function actionOnStationaryRotation() : void
      {
         TweenLite.to(this._clipMoving,0.7,{
            "ease":Linear.easeNone,
            "alpha":0
         });
         TweenLite.to(this._clipStationary,1,{
            "ease":Linear.easeNone,
            "alpha":1
         });
         TweenLite.to(this.effectMc,0.25,{"shortRotation":{"rotation":ship.rotation.degrees}});
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         TweenLite.killTweensOf(this._clipMoving);
         TweenLite.killTweensOf(this._clipStationary);
         TweenLite.killTweensOf(this.effectMc);
         ship.rotation.changed.remove(this.handleRotation);
         ship.moveTrait.moveStarted.remove(this.actionOnMovingRotation);
         ship.moveTrait.moveStopped.remove(this.actionOnStationaryRotation);
         if(Boolean(effectMc) && Boolean(effectMc.parent))
         {
            effectMc.parent.removeChild(effectMc);
         }
         super.disposeView(param1);
      }
   }
}

