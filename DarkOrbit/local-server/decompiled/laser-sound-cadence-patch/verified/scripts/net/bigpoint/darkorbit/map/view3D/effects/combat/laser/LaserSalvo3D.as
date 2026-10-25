package net.bigpoint.darkorbit.map.view3D.effects.combat.laser
{
   import away3d.animators.ParticleGroupAnimator;
   import away3d.entities.ParticleGroup;
   import away3d.events.ParticleGroupEvent;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.common.LaserEmissionSchedule;
   import net.bigpoint.darkorbit.map.common.LaserImpactGeometry;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.map.model.traits.HPTrait;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.model.traits.weapons.ILaserPositionProvider;
   import net.bigpoint.darkorbit.map.model.traits.weapons.LaserCannon;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.ship.Lasers3D;
   import net.bigpoint.darkorbit.map.view3D.effects.combat.ShieldImpactEffect;
   import net.bigpoint.darkorbit.map.view3D.settings.LightSettings;
   import net.bigpoint.darkorbit.map.view3D.settings.Settings3D;
   import net.bigpoint.darkorbit.map.view3D.utils.ObjectsPool;
   import net.bigpoint.darkorbit.pattern.LaserPattern;
   import org.osflash.signals.Promise;
   
   public class LaserSalvo3D implements ILaserPositionProvider
   {
      
      private static const ALL_SALVOS:Dictionary = new Dictionary(true);
      
      private static const DEFAULT_SALVOS:Vector.<Vector.<String>> = new Vector.<Vector.<String>>();
      
      private static const CALCULATION_VECTOR3D:Vector3D = new Vector3D();
      
      private static const CALCULATION_VECTOR3D_2:Vector3D = new Vector3D();
      
      private static const CALCULATION_VECTOR3D_3:Vector3D = new Vector3D();
      
      DEFAULT_SALVOS.push(Vector.<String>(["mainCannon"]));
      
      private const _tmp:Vector3D = new Vector3D();
      
      private var _visualSize:Number;
      
      private var _laserPattern:LaserPattern;
      
      private var attackerShip:MapEntity;
      
      private var targetShip:MapEntity;
      
      private var _skilledLaser:Boolean;
      
      private var _skilledShield:Boolean;
      
      private var _shieldVisualType:int;
      
      private var _timeouts:Vector.<uint> = new Vector.<uint>();
      
      private var _stopped:Boolean = false;
      
      private var _spawnPointsProvider:ILaserPositionProvider;
      
      private var _debug:Boolean;
      
      private var _muzzleFlash:ParticleGroup;
      
      private var _muzzlesToStart:Vector.<ParticleGroupAnimator>;
      
      private var _muzzleFlashLightColor:uint = 0;
      
      private var _animator2mesh:Dictionary = new Dictionary(true);
      
      private var _resKey:String;
      
      private var _laserTypeID:int;
      
      private var _muzzlePromise:Promise;
      
      private var _activeBullets:int;
      
      private var _emitting:Boolean;
      
      private var _emissionComplete:Boolean;
      
      public function LaserSalvo3D(param1:MapEntity, param2:MapEntity, param3:LaserPattern, param4:Boolean = false, param5:Boolean = false, param6:int = 0, param7:Boolean = false, param8:int = -1)
      {
         super();
         this._laserTypeID = param8;
         this.attackerShip = param1;
         this.targetShip = param2;
         this.attackerShip.entityDeactivated.add(this.stop);
         this.targetShip.entityDeactivated.add(this.stop);
         this._laserPattern = param3;
         this._skilledLaser = param4;
         this._skilledShield = param5;
         this._shieldVisualType = param6;
         var _loc9_:LaserCannon = AttackerTrait(this.attackerShip.getFirstTrait(AttackerTrait)).laser;
         this._spawnPointsProvider = _loc9_.positionsProvider || this;
         this._debug = param7;
         this._visualSize = 1;
         var _loc10_:UberDisplayTrait = this.targetShip.getFirstTrait(UberDisplayTrait) as UberDisplayTrait;
         if(Boolean(_loc10_) && _loc10_.descriptor.display3D.length() > 0)
         {
            this._visualSize = Number(_loc10_.descriptor.display3D[0].@visualSize) || 1;
         }
         this.startAttack();
      }
      
      public static function addSalvo(param1:LaserSalvo3D, param2:Boolean = false) : void
      {
         if(!param2)
         {
            stopSalvos(param1.attackerShip);
         }
         if(param1._stopped)
         {
            return;
         }
         var _loc3_:Array = ALL_SALVOS[param1.attackerShip.id];
         if(!_loc3_)
         {
            ALL_SALVOS[param1.attackerShip.id] = _loc3_ = [];
         }
         _loc3_.push(param1);
      }
      
      public static function stopSalvos(param1:MapEntity) : void
      {
         var _loc3_:LaserSalvo3D = null;
         var _loc2_:Array = ALL_SALVOS[param1.id];
         delete ALL_SALVOS[param1.id];
         if(_loc2_)
         {
            for each(_loc3_ in _loc2_)
            {
               _loc3_.stop();
            }
         }
      }
      
      private static function removeSalvo(param1:LaserSalvo3D) : void
      {
         var _loc2_:Array = ALL_SALVOS[param1.attackerShip.id];
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:int = _loc2_.indexOf(param1);
         if(_loc3_ >= 0)
         {
            _loc2_.splice(_loc3_,1);
         }
         if(!_loc2_.length)
         {
            delete ALL_SALVOS[param1.attackerShip.id];
         }
      }
      
      private function finishIfIdle() : void
      {
         if(this._emissionComplete && !this._emitting && this._activeBullets == 0)
         {
            this.stop();
         }
      }
      
      private function get shield() : int
      {
         var _loc2_:int = 0;
         var _loc1_:HPTrait = this.targetShip.getFirstTrait(HPTrait) as HPTrait;
         if(Boolean(_loc1_) && _loc1_.shield.value > 0)
         {
            _loc2_ = _loc1_.shield.value;
         }
         return _loc2_;
      }
      
      public function getSalvos() : Vector.<Vector.<String>>
      {
         return DEFAULT_SALVOS;
      }
      
      public function getLaserCannonLocalPosition(param1:String, param2:Vector3D, param3:Number = 0) : void
      {
         param2.setTo(0,0,0);
      }
      
      private function startAttack() : void
      {
         var _loc2_:Vector.<Vector.<String>> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = Number(NaN);
         this._resKey = this._laserPattern.getResKey();
         var _loc1_:String = this._laserPattern.muzzleFlashResKey;
         if(Settings3D.effects.high.value)
         {
            this._muzzleFlashLightColor = this._laserPattern.lightColor;
            if(_loc1_)
            {
               this._muzzlePromise = World3D.instance.particleLoader.loadParticleByUrl(_loc1_ + ".zip",World3D.LIFETIME_MAP);
               this._muzzlePromise.addOnce(this.muzzleFlashReady);
            }
         }
         if(this._skilledLaser && this._laserPattern.skillResKey != "-1")
         {
            this._resKey = this._laserPattern.skillResKey;
         }
         if(this._laserPattern.isAbsorber())
         {
            this._tmp.setTo(0,0,0);
            if(this._skilledLaser)
            {
               this.shoot(this._tmp,false);
               this._timeouts.push(setTimeout(this.shoot,60,this._tmp,false));
               this._timeouts.push(setTimeout(this.shoot,440,this._tmp,false));
               this._timeouts.push(setTimeout(this.shoot,500,this._tmp,true));
            }
            else
            {
               this.shoot(this._tmp,true);
            }
            if(this._laserPattern.getSoundID() != -1 && LaserEmissionSchedule.soundAllowed(this.attackerShip,this._laserTypeID,getTimer()))
            {
               AudioManager.playSoundEffect(this._laserPattern.getSoundID(),false,false,this.attackerShip.x,this.attackerShip.y,this.attackerShip.id == Hero.userID);
            }
         }
         else if(this._laserPattern.ignoreLaserPoints)
         {
            this._tmp.setTo(0,0,0);
            this.shoot(this._tmp,true);
         }
         else
         {
            _loc2_ = this._spawnPointsProvider.getSalvos() || DEFAULT_SALVOS;
            _loc3_ = LaserEmissionSchedule.emissionCount(this._laserTypeID,_loc2_.length);
            if(!_loc3_)
            {
               this._emissionComplete = true;
               this.finishIfIdle();
            }
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = LaserEmissionSchedule.cannonGroupIndex(this._laserTypeID,_loc4_,_loc2_.length);
               _loc6_ = LaserEmissionSchedule.delayMs(this._laserTypeID,_loc4_,_loc2_.length);
               if(_loc6_ == 0)
               {
                  this.shotSalvo(_loc2_[_loc5_],_loc4_ == _loc3_ - 1);
               }
               else
               {
                  this._timeouts.push(setTimeout(this.shotSalvo,_loc6_,_loc2_[_loc5_],_loc4_ == _loc3_ - 1));
               }
               _loc4_++;
            }
         }
         if(this._debug)
         {
         }
      }
      
      private function muzzleFlashReady(param1:ParticleGroup) : void
      {
         this._muzzlePromise = null;
         if(!this._stopped)
         {
            this._muzzleFlash = param1;
         }
      }
      
      private function shotSalvo(param1:Vector.<String>, param2:Boolean) : void
      {
         var _loc3_:String = null;
         var _loc4_:Lasers3D = null;
         var _loc5_:Vector3D = null;
         var _loc6_:ParticleGroup = null;
         var _loc7_:LightSettings = null;
         var _loc8_:int = 0;
         var _loc9_:ParticleGroupAnimator = null;
         if(this._stopped)
         {
            return;
         }
         this._emitting = true;
         if(param2)
         {
            this._emissionComplete = true;
         }
         if(this._laserPattern.getSoundID() != -1 && LaserEmissionSchedule.soundAllowed(this.attackerShip,this._laserTypeID,getTimer()))
         {
            AudioManager.playSoundEffect(this._laserPattern.getSoundID(),false,false,this.attackerShip.x,this.attackerShip.y,this.attackerShip.id == Hero.userID);
         }
         if(this._debug)
         {
         }
         for each(_loc3_ in param1)
         {
            this._spawnPointsProvider.getLaserCannonLocalPosition(_loc3_,this._tmp);
            this.shoot(this._tmp,param2);
            if(this._spawnPointsProvider is Lasers3D && Settings3D.effects.high.value)
            {
               _loc4_ = this._spawnPointsProvider as Lasers3D;
               _loc5_ = _loc4_.getLaserCannonSlot(_loc3_);
               if(Boolean(_loc5_) && Boolean(this._muzzleFlash))
               {
                  _loc6_ = ObjectsPool.retrieve("LaserSalvo3D_flash_" + this._laserPattern.muzzleFlashResKey) as ParticleGroup || this._muzzleFlash.clone() as ParticleGroup;
                  _loc6_.moveTo(_loc5_.x,_loc5_.y,_loc5_.z);
                  _loc6_.scaleX = _loc6_.scaleY = _loc6_.scaleZ = 1 / _loc4_.mesh3D.scaleX;
                  _loc4_.mesh3D.addChild(_loc6_);
                  _loc6_.animator.addEventListener(ParticleGroupEvent.OCCUR,this.handleMuzzleFlashOccur);
                  _loc6_.animator.resetTime(0);
                  if(!this._muzzlesToStart)
                  {
                     this._muzzlesToStart = new Vector.<ParticleGroupAnimator>();
                  }
                  this._muzzlesToStart.push(_loc6_.animator);
                  this._animator2mesh[_loc6_.animator] = _loc6_;
               }
               if(this._muzzleFlashLightColor != 0)
               {
                  _loc7_ = Settings3D.laserLight;
                  World3D.instance.lights.activateEffectLight(this.attackerShip.x3D + this._tmp.x,this.attackerShip.y3D + this._tmp.y,this.attackerShip.z3D + this._tmp.z,_loc7_.color.value || this._muzzleFlashLightColor,_loc7_.fallOff.value,_loc7_.diffuse.value,_loc7_.specular.value);
               }
            }
         }
         if(Boolean(this._muzzlesToStart) && Boolean(this._muzzlesToStart.length))
         {
            _loc8_ = getTimer();
            for each(_loc9_ in this._muzzlesToStart)
            {
               _loc9_.startAt(_loc8_);
            }
            this._muzzlesToStart.length = 0;
         }
         this._emitting = false;
         this.finishIfIdle();
      }
      
      private function shoot(param1:Vector3D, param2:Boolean) : void
      {
         var _loc11_:Vector3D = null;
         if(this._stopped)
         {
            return;
         }
         if(param2)
         {
            this._emissionComplete = true;
         }
         var _loc3_:LaserBullet3D = ObjectsPool.retrieve(LaserBullet3D.getPoolId(this._laserPattern,this._resKey)) as LaserBullet3D || new LaserBullet3D(this._laserPattern,this._resKey);
         var _loc4_:Vector3D = CALCULATION_VECTOR3D;
         _loc4_.x = this.attackerShip.x3D;
         _loc4_.y = this.attackerShip.y3D;
         _loc4_.z = this.attackerShip.z3D;
         _loc4_.incrementBy(param1);
         var _loc5_:Vector3D = CALCULATION_VECTOR3D_2;
         _loc5_.x = this.targetShip.x3D;
         _loc5_.y = this.targetShip.y3D;
         _loc5_.z = this.targetShip.z3D;
         var _loc6_:Number = this._laserPattern.isAbsorber() ? 0 : this._visualSize * 50;
         var _loc7_:Number = this._laserPattern.isAbsorber() ? 1 : this._laserPattern.scale;
         var _loc8_:Number = LaserImpactGeometry.stopDistance(_loc3_.bulletLength,_loc7_,_loc6_);
         if(!this.checkDistance(_loc5_,_loc4_,_loc8_))
         {
            ObjectsPool.free(_loc3_,LaserBullet3D.getPoolId(this._laserPattern,this._resKey));
            this.finishIfIdle();
            return;
         }
         var _loc9_:Vector3D = CALCULATION_VECTOR3D_3;
         _loc9_.setTo(_loc5_.x - _loc4_.x,_loc5_.y - _loc4_.y,_loc5_.z - _loc4_.z);
         _loc9_.normalize();
         if(this._laserPattern.isAbsorber())
         {
            _loc11_ = _loc5_;
            _loc5_ = _loc4_;
            _loc4_ = _loc11_;
         }
         _loc3_.scaleX = _loc3_.scaleY = _loc3_.scaleZ = _loc3_.pattern.scale;
         _loc3_.moveTo(_loc4_.x,_loc4_.y,_loc4_.z);
         _loc3_.orientTo(_loc5_);
         var _loc10_:Object = {
            "ease":Linear.easeNone,
            "x":_loc5_.x - _loc9_.x * _loc8_,
            "y":_loc5_.y - _loc9_.y * _loc8_,
            "z":_loc5_.z - _loc9_.z * _loc8_,
            "onComplete":this.handleBulletTargetReached,
            "onCompleteParams":[_loc3_,param2,_loc5_.x - _loc9_.x * _loc6_,_loc5_.y - _loc9_.y * _loc6_,_loc5_.z - _loc9_.z * _loc6_]
         };
         if(this._laserPattern.isAbsorber())
         {
            _loc10_.scaleX = _loc10_.scaleY = _loc10_.scaleZ = 0.4;
         }
         World3D.instance.mapView.gameWorld.addChild(_loc3_);
         ++this._activeBullets;
         TweenLite.to(_loc3_,this._laserPattern.getSpeed(),_loc10_);
      }
      
      private function checkDistance(param1:Vector3D, param2:Vector3D, param3:Number) : Boolean
      {
         var _loc4_:Number = param1.x - param2.x;
         var _loc5_:Number = param1.y - param2.y;
         var _loc6_:Number = param1.z - param2.z;
         return _loc4_ * _loc4_ + _loc5_ * _loc5_ + _loc6_ * _loc6_ > param3 * param3;
      }
      
      private function handleBulletTargetReached(param1:LaserBullet3D, param2:Boolean, param3:Number, param4:Number, param5:Number) : void
      {
         if(this.shield > 0 && Settings3D.effects.medium.value)
         {
            new ShieldImpactEffect(param3,param4,param5,this.targetShip,this._shieldVisualType,this._skilledShield);
         }
         ObjectsPool.free(param1,LaserBullet3D.getPoolId(this._laserPattern,this._resKey));
         --this._activeBullets;
         this.finishIfIdle();
      }
      
      private function stop() : void
      {
         if(!this._stopped)
         {
            this._stopped = true;
            if(this._muzzlePromise)
            {
               this._muzzlePromise.remove(this.muzzleFlashReady);
               this._muzzlePromise = null;
            }
            this._muzzleFlash = null;
            this.attackerShip.entityDeactivated.remove(this.stop);
            this.targetShip.entityDeactivated.remove(this.stop);
            while(this._timeouts.length)
            {
               clearTimeout(this._timeouts.pop());
            }
            removeSalvo(this);
         }
      }
      
      private function handleMuzzleFlashOccur(param1:ParticleGroupEvent) : void
      {
         param1.currentTarget.removeEventListener(ParticleGroupEvent.OCCUR,this.handleMuzzleFlashOccur);
         var _loc2_:ParticleGroup = this._animator2mesh[param1.currentTarget];
         _loc2_.animator.stop();
         _loc2_.parent.removeChild(_loc2_);
         ObjectsPool.free(_loc2_,"LaserSalvo3D_flash_" + this._laserPattern.muzzleFlashResKey);
         this._animator2mesh[param1.currentTarget] = null;
         delete this._animator2mesh[param1.currentTarget];
      }
   }
}

