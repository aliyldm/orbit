package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import flash.media.SoundChannel;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpeedBuffEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractShipEffect2D;
   
   public class SpeedBuffEffect2D extends AbstractShipEffect2D implements IFrameObserver
   {
      
      private var _shakeTween:TweenMax;
      
      private var _speedBuffStartupSound:SoundChannel;
      
      private var _speedBuffSound:SoundChannel;
      
      private var _startupSoundPlayed:Boolean = false;
      
      private var _shake:Boolean = false;
      
      private var _turboEngines:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private var _engines:Vector.<MovieClip>;
      
      private var _effect:SpeedBuffEffect;
      
      private var _shakeOffset:PointLite = new PointLite(-2,-2);
      
      public function SpeedBuffEffect2D(param1:MapView2D, param2:SpeedBuffEffect)
      {
         this._effect = param2;
         this._shake = param2.shake;
         super(param1,param2,true);
      }
      
      private function reload() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         this.removeTurboEngines();
         this._turboEngines = new Vector.<MovieClip>();
         this._engines = new Vector.<MovieClip>();
         if(shipView != null && shipView.engines != null)
         {
            this._engines = shipView.engines.engineClips;
            _loc2_ = 0;
            while(_loc2_ < this._engines.length)
            {
               if(this._engines[_loc2_] != undefined && this._engines[_loc2_] != null)
               {
                  _loc1_ = ResourceManager.getMovieClip(pattern.resKey,"mc");
                  _loc1_.alpha = 0;
                  _loc1_.x = this._engines[_loc2_].x;
                  _loc1_.y = this._engines[_loc2_].y;
                  _loc1_.rotation = ship.rotation.degrees;
                  addChild(_loc1_);
                  this._turboEngines.push(_loc1_);
               }
               _loc2_++;
            }
         }
         clip.visible = false;
      }
      
      override protected function initEffectVisuals() : void
      {
         this.reload();
         if(this._shake)
         {
            this._shakeTween = TweenMax.to(this._shakeOffset,0.075,{
               "y":2,
               "x":2,
               "repeat":-1,
               "yoyo":true
            });
            if(!ship.moveTrait.isMoving)
            {
               this._shakeTween.pause();
            }
            ship.moveTrait.moveStarted.add(this.moveStarted);
            ship.moveTrait.moveStopped.add(this.moveStopped);
         }
         ScreenManager.addObserver(this);
      }
      
      private function moveStopped() : void
      {
         this._shakeTween.pause();
      }
      
      private function moveStarted() : void
      {
         this._shakeTween.resume();
      }
      
      private function handleRotation() : void
      {
         if(this._turboEngines.length != this._engines.length)
         {
            this.reload();
         }
         if(ship.moveTrait.isMoving)
         {
            this.actionOnMovingRotation();
         }
         else
         {
            this.actionOnStationaryRotation();
         }
      }
      
      private function actionOnMovingRotation() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         for each(_loc1_ in this._turboEngines)
         {
            _loc1_.visible = true;
         }
         if(clip != null)
         {
            if(shipView != null)
            {
               shipView.x += this._shakeOffset.x;
               shipView.y += this._shakeOffset.y;
            }
            if(!this._startupSoundPlayed && shipView != null && ship.isHeroShip())
            {
               this._speedBuffStartupSound = AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_LIGHTNING_AFTERBURNER_START,false,false,ship.x,ship.y);
               this._startupSoundPlayed = true;
            }
            _loc2_ = 0;
            while(_loc2_ < this._turboEngines.length)
            {
               TweenMax.to(this._turboEngines[_loc2_],0.1,{
                  "ease":Linear.easeNone,
                  "alpha":1
               });
               TweenMax.to(this._turboEngines[_loc2_],0.25,{"shortRotation":{"rotation":ship.rotation.degrees}});
               this._turboEngines[_loc2_].x = this._engines[_loc2_].x;
               this._turboEngines[_loc2_].y = this._engines[_loc2_].y;
               _loc2_++;
            }
            if(this._speedBuffSound == null && ship.isHeroShip())
            {
               _loc3_ = -1;
               if(shipView != null)
               {
                  if(ship.shipPattern.getPatternID() == "69")
                  {
                     _loc3_ = InGameCatalog.SOUND_ID_CITADEL_TRAVEL_MODE_LOOP;
                  }
                  else if(ship.shipPattern.getPatternID() == "18")
                  {
                     _loc3_ = InGameCatalog.SOUND_ID_LIGHTNING_AFTERBURNER_LOOP;
                  }
                  if(_loc3_ != -1)
                  {
                     this._speedBuffSound = AudioManager.playSoundEffect(_loc3_,true,true);
                  }
               }
            }
         }
      }
      
      private function actionOnStationaryRotation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         if(shipView != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this._turboEngines.length)
            {
               _loc2_ = this._turboEngines[_loc1_];
               TweenMax.to(_loc2_,0.1,{
                  "ease":Linear.easeNone,
                  "alpha":0
               });
               _loc2_.x = this._engines[_loc1_].x;
               _loc2_.y = this._engines[_loc1_].y;
               _loc1_++;
            }
            if(this._speedBuffSound != null)
            {
               AudioManager.removeLoop(this._speedBuffSound,true);
               this._speedBuffSound = null;
            }
         }
      }
      
      private function removeTurboEngines() : void
      {
         var _loc1_:MovieClip = null;
         while(this._turboEngines != null && this._turboEngines.length > 0)
         {
            _loc1_ = this._turboEngines.pop();
            if(_loc1_.parent)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         ScreenManager.removeObserver(this);
         this.removeTurboEngines();
         if(this._effect.shake)
         {
            TweenMax.killTweensOf(this._shakeOffset);
            ship.moveTrait.moveStarted.remove(this.moveStarted);
            ship.moveTrait.moveStopped.remove(this.moveStopped);
            if(shipView != null)
            {
               shipView.x -= this._shakeOffset.x;
               shipView.y -= this._shakeOffset.y;
            }
         }
         if(this._speedBuffSound != null)
         {
            AudioManager.removeLoop(this._speedBuffSound,true);
            this._speedBuffSound = null;
         }
         super.disposeView(param1);
      }
      
      public function updateTimer(param1:Number) : void
      {
         this.handleRotation();
      }
   }
}

