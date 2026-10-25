package net.bigpoint.darkorbit.map.view2D.effects.combat.rocket
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.geom.Vector3D;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ObjectPoolManager;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.DamageReceivedEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.PyroEffect;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.map.view2D.effects.EffectRange2D;
   import net.bigpoint.darkorbit.mvc.battleStation.BattleStationModule;
   import net.bigpoint.darkorbit.pattern.ExplosionPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.RocketPattern;
   import net.bigpoint.darkorbit.pattern.RocketSmokePattern;
   
   public class Rocket2D extends Sprite
   {
      
      public static var nativeImpactDispatchDepth:int;
      
      private const RADTODEG:Number = 57.29577951308232;
      
      private var _rocketSmokePattern:RocketSmokePattern;
      
      private var _attackerShip:AttackerTrait;
      
      private var _targetShip:AttackTargetTrait;
      
      private var _rocketPattern:RocketPattern;
      
      private var _airstrikeMode:Boolean;
      
      private var _isTargetHero:Boolean;
      
      private var _heatSeeking:Boolean;
      
      private var _pulseClip:MovieClip;
      
      private var _duration:Number;
      
      private var _hit:Boolean;
      
      private var _gaps:Vector3D = new Vector3D();
      
      private var _prevRocketX:int = -2147483648;
      
      private var _prevRocketY:int = -2147483648;
      
      private var _prevSmokeRocketX:int = -2147483648;
      
      private var _prevSmokeRocketY:int = -2147483648;
      
      private var _showExplosion:Boolean;
      
      private var _disposed:Boolean = false;
      
      public function Rocket2D(param1:AttackerTrait, param2:AttackTargetTrait, param3:Boolean, param4:RocketPattern, param5:RocketSmokePattern, param6:Boolean, param7:Boolean = false, param8:Number = 0, param9:Boolean = true)
      {
         super();
         this._attackerShip = param1;
         this._targetShip = param2;
         this._hit = param3;
         this._showExplosion = param9;
         this._duration = Math.max(0.5,PointLite.distanceTwoPoints(param1.owner.position,param2.owner.position) / 500);
         if(param7)
         {
            this._duration += 0.3;
         }
         this._rocketSmokePattern = param5;
         this._heatSeeking = param6;
         this._airstrikeMode = param7;
         this._rocketPattern = param4;
         addChild(ResourceManager.getMovieClip(this._rocketPattern.getResKey(),"mc"));
         x = this._attackerShip.owner.position.x + this._attackerShip.rocketLauncher.localPosition.x;
         y = this._attackerShip.owner.position.y + this._attackerShip.rocketLauncher.localPosition.y;
         this._prevRocketX = x;
         this._prevRocketY = y;
         var _loc10_:Object = {
            "dynamicProps":{
               "x":this.getTargetShipXPos,
               "y":this.getTargetShipYPos
            },
            "delay":param8,
            "onUpdate":this.onUpdate,
            "onComplete":this.onFinishRocketTween
         };
         if(this._airstrikeMode || this._heatSeeking || this._attackerShip.owner is BattleStationModule)
         {
            this._gaps.x = this._attackerShip.rocketLauncher.direction.x;
            this._gaps.y = this._attackerShip.rocketLauncher.direction.y;
            TweenLite.to(this._gaps,this._duration * 0.7,{
               "x":0,
               "y":0,
               "z":0,
               "delay":_loc10_.delay
            });
         }
         else
         {
            _loc10_.ease = Linear.easeNone;
         }
         TweenLite.to(this,this._duration,_loc10_);
         this._isTargetHero = this._targetShip.owner.id == Hero.userID;
         if(this._heatSeeking)
         {
            ResourceManager.fileCollection.load("minePulse",this.addHeatSeaker);
         }
      }
      
      private function dispose() : void
      {
         if(this._disposed)
         {
            return;
         }
         this._disposed = true;
         ResourceManager.fileCollection.removeCallbacks("minePulse",this.addHeatSeaker);
         TweenLite.killTweensOf(this);
         TweenLite.killTweensOf(this._gaps);
         if(this._pulseClip != null)
         {
            TweenLite.killTweensOf(this._pulseClip);
            this._pulseClip.stop();
            if(this._pulseClip.parent)
            {
               this._pulseClip.parent.removeChild(this._pulseClip);
            }
            this._pulseClip = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function addHeatSeaker(param1:SWFFinisher) : void
      {
         if(this._disposed)
         {
            return;
         }
         this._pulseClip = param1.getEmbeddedMovieClip("mc");
         var _loc2_:ColorTransform = new ColorTransform();
         _loc2_.color = 16711680;
         this._pulseClip.transform.colorTransform = _loc2_;
         addChild(this._pulseClip);
         this.playPulseAnimation(this._pulseClip,15);
         this._pulseClip.x = -30;
      }
      
      private function playPulseAnimation(param1:MovieClip, param2:int) : void
      {
         if(this._disposed || !param1.parent)
         {
            return;
         }
         var _loc3_:int = param1.framesLoaded;
         var _loc4_:Number = _loc3_ / param2;
         param1.gotoAndStop(1);
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_PULSE,false,false,param1.parent.x,param1.parent.y);
         TweenLite.to(param1,_loc4_,{
            "ease":Linear.easeNone,
            "frame":_loc3_,
            "onComplete":this.playPulseAnimation,
            "onCompleteParams":[param1,param2]
         });
      }
      
      public function onFinishRocketTween() : void
      {
         if(this._disposed)
         {
            return;
         }
         if(this._pulseClip != null)
         {
            TweenLite.killTweensOf(this._pulseClip);
            if(this._pulseClip.parent)
            {
               this._pulseClip.parent.removeChild(this._pulseClip);
            }
            this._pulseClip = null;
         }
         if(!this._hit)
         {
            if(this._targetShip.owner.id == Hero.userID || this._attackerShip.owner.id == Hero.userID)
            {
               ScreenManager.getInstance().map.effects.addEffect(new DamageReceivedEffect(this._targetShip.owner,0));
            }
            this.showExplosion(PatternManager.getPyroPattern(ExplosionPattern.TYPE_LASER_DAMAGE,1));
         }
         if(this._hit || this._airstrikeMode)
         {
            this.showExplosion(PatternManager.getPyroPattern(ExplosionPattern.TYPE_ROCKET_DAMAGE,1));
         }
         this.dispose();
      }
      
      private function showExplosion(param1:ExplosionPattern) : void
      {
         var pyroPattern:ExplosionPattern = param1;
         if(this._showExplosion)
         {
            ++nativeImpactDispatchDepth;
            try
            {
               ScreenManager.getInstance().map.effects.playEffect(new PyroEffect(x,y,0,pyroPattern,this._targetShip.owner));
            }
            finally
            {
               --nativeImpactDispatchDepth;
            }
         }
      }
      
      private function onUpdate() : void
      {
         var _loc2_:BitmapClip = null;
         if(this._disposed || !parent)
         {
            return;
         }
         if(!EffectRange2D.link(this._attackerShip.owner.position,this._targetShip.owner.position))
         {
            this.dispose();
            return;
         }
         var _loc1_:Number = Math.atan2(y - this._prevRocketY,x - this._prevRocketX) * this.RADTODEG;
         rotation = Math.round(_loc1_ + 180);
         this._prevRocketX = x;
         this._prevRocketY = y;
         if(Math.abs(x - this._prevSmokeRocketX) + Math.abs(y - this._prevSmokeRocketY) > this._rocketSmokePattern.particleInterval)
         {
            this._prevSmokeRocketX = x;
            this._prevSmokeRocketY = y;
            _loc2_ = ObjectPoolManager.getRocketSmokeClip(this._rocketSmokePattern.resKey);
            if(_loc2_ == null)
            {
               return;
            }
            _loc2_.x = x;
            _loc2_.y = y;
            if(parent)
            {
               parent.addChild(_loc2_);
               _loc2_.frame = 1;
               TweenLite.to(_loc2_,this._rocketSmokePattern.particleDuration,{
                  "ease":Linear.easeNone,
                  "frame":_loc2_.framesLoaded,
                  "onComplete":this.handleSmokeFinished,
                  "onCompleteParams":[_loc2_]
               });
            }
         }
      }
      
      private function getTargetShipXPos() : Number
      {
         return this._targetShip.owner.position.x + this._gaps.x;
      }
      
      private function getTargetShipYPos() : Number
      {
         return this._targetShip.owner.position.y + this._gaps.y;
      }
      
      private function handleSmokeFinished(param1:BitmapClip) : void
      {
         if(param1 != null)
         {
            if(param1.parent != null)
            {
               param1.parent.removeChild(param1);
            }
            ObjectPoolManager.addRocketSmokeClip(param1);
         }
      }
      
      public function get duration() : Number
      {
         return this._duration;
      }
   }
}

