package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.greensock.TweenMax;
   import flash.media.SoundChannel;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpeedBuffEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class SpeedBuffEffect3D implements IDisposable
   {
      
      private var _effect:SpeedBuffEffect;
      
      private var _shakeTween:TweenMax;
      
      private var _startSoundplayed:Boolean = false;
      
      private var _speedBuffSound:SoundChannel;
      
      public function SpeedBuffEffect3D(param1:MapView3D, param2:SpeedBuffEffect)
      {
         super();
         this._effect = param2;
         this.ship.hasSpeedBuff.value = true;
         this.ship.moveTrait.moveStarted.add(this.moveStarted);
         this.ship.moveTrait.moveStopped.add(this.moveStoped);
         if(this._effect.shake)
         {
            this._shakeTween = TweenMax.to(this._effect.source.position,0.075,{
               "z":4,
               "repeat":-1,
               "yoyo":true
            });
         }
         if(!this.ship.moveTrait.isMoving)
         {
            this.moveStoped();
         }
      }
      
      private function moveStoped() : void
      {
         if(this._effect.shake)
         {
            this._shakeTween.pause();
         }
         if(this._speedBuffSound != null)
         {
            AudioManager.removeLoop(this._speedBuffSound,true);
            this._speedBuffSound = null;
         }
      }
      
      private function moveStarted() : void
      {
         var _loc1_:int = 0;
         if(this._effect.shake)
         {
            this._shakeTween.resume();
         }
         if(!this._startSoundplayed && this.ship.isHeroShip())
         {
            AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_LIGHTNING_AFTERBURNER_START,false,false,this.ship.position.x,this.ship.position.y);
            this._startSoundplayed = true;
         }
         if(this._speedBuffSound == null && this.ship.isHeroShip())
         {
            _loc1_ = -1;
            if(this.ship.shipPattern.getPatternID() == "69")
            {
               _loc1_ = InGameCatalog.SOUND_ID_CITADEL_TRAVEL_MODE_LOOP;
            }
            else if(this.ship.shipPattern.getPatternID() == "18")
            {
               _loc1_ = InGameCatalog.SOUND_ID_LIGHTNING_AFTERBURNER_LOOP;
            }
            if(_loc1_ != -1)
            {
               this._speedBuffSound = AudioManager.playSoundEffect(_loc1_,true,true);
            }
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._effect.shake)
         {
            this._shakeTween.restart();
            this._shakeTween.kill();
         }
         this.ship.moveTrait.moveStarted.remove(this.moveStarted);
         this.ship.moveTrait.moveStopped.remove(this.moveStoped);
         this.ship.hasSpeedBuff.value = false;
      }
      
      private function get ship() : Ship
      {
         return this._effect.source as Ship;
      }
   }
}

