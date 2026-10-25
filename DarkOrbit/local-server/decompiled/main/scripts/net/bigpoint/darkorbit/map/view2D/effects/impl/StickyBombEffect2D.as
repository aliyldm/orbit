package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenLite;
   import com.greensock.TweenNano;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.media.SoundChannel;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.effects.impl.AbstractStickyBombEffect;
   import net.bigpoint.darkorbit.map.model.traits.ShipDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.display.ship.Ship2D;
   
   public class StickyBombEffect2D implements IDisposable, IFrameObserver
   {
      
      private static var beepSoundChannel:SoundChannel = null;
      
      private static const DATA:Object = {};
      
      DATA[AbstractStickyBombEffect.NORMAL] = {
         "libId":"stickyBomb",
         "warmUpDuration":9
      };
      DATA[AbstractStickyBombEffect.EMPEROR] = {
         "libId":"emperorStickyBomb",
         "warmUpDuration":7
      };
      DATA[AbstractStickyBombEffect.EXPLODING_CHARGING_BLOB] = {
         "libId":"explosiveChargingBlob",
         "warmUpDuration":9
      };
      
      private const FRAMES_OF_FIRST_MC:int = 4;
      
      private var _mapView:MapView2D;
      
      private var _effect:AbstractStickyBombEffect;
      
      private var _stage1View:MovieClip;
      
      private var _stage2View:Sprite;
      
      private var _light:Bitmap;
      
      private var _stage2ViewAnimation:MovieClip;
      
      private var _secondsLeft:int = -1;
      
      private var _libId:String;
      
      private var _warmUpDuration:Number;
      
      private var _fps:int = 5;
      
      public function StickyBombEffect2D(param1:MapView2D, param2:AbstractStickyBombEffect)
      {
         super();
         this._mapView = param1;
         this._effect = param2;
         this._libId = DATA[param2.stickyBombType].libId;
         this._warmUpDuration = DATA[param2.stickyBombType].warmUpDuration;
         if(param2.source != null)
         {
            this.stage1();
         }
         else
         {
            this.stage2();
         }
      }
      
      private function get stickyEffect() : AbstractStickyBombEffect
      {
         return this._effect as AbstractStickyBombEffect;
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this.cleanupStage1();
         this.cleanupStage2();
      }
      
      private function cleanupStage2() : void
      {
         if(beepSoundChannel)
         {
            AudioManager.removeLoop(beepSoundChannel);
         }
         if(this._stage2View)
         {
            if(this._stage2View.parent)
            {
               this._stage2View.parent.removeChild(this._stage2View);
            }
            this._stage2View = null;
         }
         TweenNano.killTweensOf(this.updateSpeed);
         TweenNano.killTweensOf(this.proceed);
         TweenNano.killTweensOf(this.loopFunc);
         ScreenManager.removeObserver(this);
      }
      
      public function updateTimer(param1:Number) : void
      {
         if(Boolean(this._stage2ViewAnimation) && Boolean(this.targetView))
         {
            this._stage2ViewAnimation.gotoAndStop(this.targetView.base.clip.currentFrame % 4 + 1);
         }
      }
      
      private function get targetView() : Ship2D
      {
         return this._mapView.entitiesLayer.getViewByTrait(this.stickyEffect.source.getFirstTrait(ShipDisplayTrait)) as Ship2D;
      }
      
      private function stage1() : void
      {
         ResourceManager.fileCollection.load(this._libId,this.handleStage1ResourceReady);
      }
      
      private function cleanupStage1() : void
      {
         if(this._stage1View)
         {
            TweenLite.killTweensOf(this._stage1View);
            if(this._stage1View.parent)
            {
               this._stage1View.parent.removeChild(this._stage1View);
            }
            this._stage1View = null;
         }
      }
      
      private function handleStage1ResourceReady(param1:SWFFinisher) : void
      {
         if(param1 == null || this.stickyEffect.bombSource == null)
         {
            this.disposeView();
         }
         else
         {
            this._stage1View = param1.getEmbeddedMovieClip("flying_mc");
            this._stage1View.x = this.stickyEffect.bombSource.x;
            this._stage1View.y = this.stickyEffect.bombSource.y;
            this.updateStage1Rotation();
            this._mapView.fxLayer.addChild(this._stage1View);
            TweenLite.to(this._stage1View,1,{
               "dynamicProps":{
                  "x":this.getX,
                  "y":this.getY
               },
               "onUpdate":this.updateStage1Rotation,
               "onComplete":this.handleStage1Finished
            });
         }
      }
      
      private function handleStage1Finished() : void
      {
         this.cleanupStage1();
         this.stage2();
      }
      
      private function getX() : int
      {
         return this.stickyEffect.bombTarget.x;
      }
      
      private function getY() : int
      {
         return this.stickyEffect.bombTarget.y;
      }
      
      private function updateStage1Rotation() : void
      {
         var _loc1_:Number = Math.atan2(this.stickyEffect.bombTarget.y - this._stage1View.y,this.stickyEffect.bombTarget.x - this._stage1View.x) * 180 / Math.PI + 180;
         var _loc2_:int = _loc1_ % 360;
         while(_loc2_ < 0)
         {
            _loc2_ = 360 + _loc2_;
         }
         this._stage1View.gotoAndStop(int((32 * _loc2_ / 360 + 0.5) % 32 + 1));
      }
      
      private function stage2() : void
      {
         ResourceManager.fileCollection.load(this._libId,this.handleStage2ResourceReady);
      }
      
      private function handleStage2ResourceReady(param1:SWFFinisher) : void
      {
         this._stage2View = new Sprite();
         if(this.targetView)
         {
            this.targetView.addChild(this._stage2View);
            this._light = param1.getEmbeddedBitmap("light");
            this._light.x = -0.5 * this._light.width;
            this._light.y = -0.5 * this._light.height;
            this._light.visible = false;
            this._stage2View.addChild(this._light);
            this._stage2ViewAnimation = param1.getEmbeddedMovieClip("rotating_mc");
            this._stage2ViewAnimation.gotoAndStop(1);
            this._stage2View.addChild(this._stage2ViewAnimation);
            this._secondsLeft = this._warmUpDuration;
            this._fps = 5;
            this.proceed();
            TweenNano.delayedCall(1,this.updateSpeed);
         }
         else
         {
            this.disposeView();
         }
      }
      
      private function updateSpeed() : void
      {
         if(this._secondsLeft-- > 0)
         {
            ++this._fps;
            TweenNano.delayedCall(1,this.updateSpeed);
         }
      }
      
      private function proceed() : void
      {
         this._stage2ViewAnimation.gotoAndStop(this._stage2ViewAnimation.currentFrame + 1);
         if(this._stage2ViewAnimation.currentFrame == this.FRAMES_OF_FIRST_MC)
         {
            this._stage2ViewAnimation.gotoAndStop(1);
            this._stage2View.addChild(this._stage2ViewAnimation);
            this._stage2View.addChild(this._light);
            ScreenManager.addObserver(this);
            this._fps = 1;
            this.loopFunc();
         }
         else
         {
            TweenNano.delayedCall(1 / this._fps,this.proceed);
         }
      }
      
      private function loopFunc() : void
      {
         this._light.visible = !this._light.visible;
         if(this._light.visible)
         {
            AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_STICKYBOMB_BEEP);
         }
         if(this._secondsLeft <= 1)
         {
            this._light.visible = true;
            if(beepSoundChannel)
            {
               AudioManager.removeLoop(beepSoundChannel);
            }
            beepSoundChannel = AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_STICKYBOMB_BEEP,true);
            return;
         }
         TweenNano.delayedCall(1 / this._fps,this.loopFunc);
      }
   }
}

