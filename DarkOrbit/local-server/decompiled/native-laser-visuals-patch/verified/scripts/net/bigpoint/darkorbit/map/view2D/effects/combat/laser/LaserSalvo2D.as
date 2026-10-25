package net.bigpoint.darkorbit.map.view2D.effects.combat.laser
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.common.LaserEmissionSchedule;
   import net.bigpoint.darkorbit.map.common.LaserImpactGeometry;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.map.model.traits.MouseHitAreaTrait;
   import net.bigpoint.darkorbit.map.model.traits.ShipDisplayTrait;
   import net.bigpoint.darkorbit.map.model.traits.weapons.ILaserPositionProvider;
   import net.bigpoint.darkorbit.map.model.traits.weapons.LaserCannon;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.EffectRange2D;
   import net.bigpoint.darkorbit.pattern.LaserPattern;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   
   public class LaserSalvo2D extends Sprite implements ILaserPositionProvider
   {
      
      private static const ALL_SALVOS:Dictionary = new Dictionary(true);
      
      private static const DEFAULT_SALVOS:Vector.<Vector.<String>> = new Vector.<Vector.<String>>();
      
      private static const SHIELD_KEY:String = "shieldDamage";
      
      private static var shieldDamageLookUp:Dictionary = new Dictionary();
      
      DEFAULT_SALVOS.push(Vector.<String>(["mainCannon"]));
      
      private const DEGTORAD:Number = 0.017453292519943295;
      
      private const RADTODEG:Number = 57.29577951308232;
      
      private const _tmp:Vector3D = new Vector3D();
      
      private var _tmp2:PointLite = new PointLite();
      
      private var _mapView:MapView2D;
      
      private var _laserPattern:LaserPattern;
      
      private var _targetRadius:Number;
      
      private var attackerShip:MapEntity;
      
      private var targetShip:MapEntity;
      
      private var _showShieldDamage:Boolean;
      
      private var _skilledLaser:Boolean;
      
      private var _timeouts:Vector.<uint> = new Vector.<uint>();
      
      private var _stopped:Boolean;
      
      private var _disposed:Boolean;
      
      private var _activeShots:int;
      
      private var _pendingLoads:int;
      
      private var _finishRequested:Boolean;
      
      private var _spawning:Boolean;
      
      private var _spawnPointsProvider:ILaserPositionProvider;
      
      private var _laserTypeID:int;
      
      private var _idleClips:Array = [];
      
      public function LaserSalvo2D(param1:MapEntity, param2:MapEntity, param3:LaserPattern, param4:Boolean, param5:Boolean, param6:MapView2D, param7:int = -1, param8:Boolean = false)
      {
         super();
         this._mapView = param6;
         this._laserTypeID = param7;
         this.attackerShip = param1;
         this.targetShip = param2;
         var _loc9_:MouseHitAreaTrait = param2.getFirstTrait(MouseHitAreaTrait) as MouseHitAreaTrait;
         this._targetRadius = _loc9_ ? _loc9_.clickRadius : 0;
         this.attackerShip.entityDeactivated.add(this.stop);
         this.targetShip.entityDeactivated.add(this.stop);
         this._laserPattern = param3;
         this._showShieldDamage = param4;
         this._skilledLaser = param5;
         var _loc10_:LaserCannon = AttackerTrait(this.attackerShip.getFirstTrait(AttackerTrait)).laser;
         this._spawnPointsProvider = _loc10_.positionsProvider || this;
         addSalvo(this,param8);
         addEventListener(Event.ADDED,this.startWhenAdded);
      }
      
      public static function stopSalvos(param1:MapEntity) : void
      {
         var _loc3_:LaserSalvo2D = null;
         var _loc2_:Array = ALL_SALVOS[param1.id];
         if(_loc2_)
         {
            for each(_loc3_ in _loc2_.slice())
            {
               _loc3_.stop();
            }
         }
      }
      
      private static function addSalvo(param1:LaserSalvo2D, param2:Boolean) : void
      {
         if(!param2)
         {
            stopSalvos(param1.attackerShip);
         }
         var _loc3_:Array = ALL_SALVOS[param1.attackerShip.id];
         if(!_loc3_)
         {
            ALL_SALVOS[param1.attackerShip.id] = _loc3_ = [];
         }
         _loc3_.push(param1);
      }
      
      private function startWhenAdded(param1:Event) : void
      {
         if(param1.target != this)
         {
            return;
         }
         removeEventListener(Event.ADDED,this.startWhenAdded);
         if(this._disposed)
         {
            if(parent)
            {
               parent.removeChild(this);
            }
            return;
         }
         this.startAttack();
      }
      
      private function dispose() : void
      {
         var _loc1_:DisplayObject = null;
         if(this._disposed)
         {
            return;
         }
         this._disposed = true;
         this.detach();
         while(numChildren > 0)
         {
            _loc1_ = getChildAt(numChildren - 1);
            TweenLite.killTweensOf(_loc1_);
            if(_loc1_ is MovieClip)
            {
               MovieClip(_loc1_).gotoAndStop(1);
            }
            removeChild(_loc1_);
         }
         this._activeShots = 0;
         this._idleClips.length = 0;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function detach() : void
      {
         var _loc2_:int = 0;
         this.attackerShip.entityDeactivated.remove(this.stop);
         this.targetShip.entityDeactivated.remove(this.stop);
         while(this._timeouts.length)
         {
            clearTimeout(this._timeouts.pop());
         }
         var _loc1_:Array = ALL_SALVOS[this.attackerShip.id];
         if(_loc1_)
         {
            _loc2_ = _loc1_.indexOf(this);
            if(_loc2_ >= 0)
            {
               _loc1_.splice(_loc2_,1);
            }
            if(!_loc1_.length)
            {
               delete ALL_SALVOS[this.attackerShip.id];
            }
         }
      }
      
      private function stop() : void
      {
         if(this._disposed)
         {
            return;
         }
         this._stopped = true;
         this.detach();
         if(this._activeShots == 0)
         {
            this.dispose();
         }
      }
      
      private function startAttack() : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Vector.<Vector.<String>> = null;
         var _loc4_:Vector.<Vector.<String>> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Number = Number(NaN);
         var _loc9_:Boolean = false;
         var _loc1_:String = this._laserPattern.getResKey();
         if(this._skilledLaser && this._laserPattern.skillResKey != "-1")
         {
            _loc1_ = this._laserPattern.skillResKey;
         }
         if(this._laserPattern.isAbsorber())
         {
            this.shoot(this.targetShip.position,this.attackerShip.position,_loc1_,false,!this._skilledLaser);
            if(this._skilledLaser)
            {
               this._timeouts.push(setTimeout(this.shoot,60,this.targetShip.position,this.attackerShip.position,_loc1_));
               this._timeouts.push(setTimeout(this.shoot,440,this.targetShip.position,this.attackerShip.position,_loc1_));
               this._timeouts.push(setTimeout(this.shoot,500,this.targetShip.position,this.attackerShip.position,_loc1_,false,true));
            }
         }
         else if(this._laserPattern.ignoreLaserPoints)
         {
            this.shoot(this.attackerShip.position,this.targetShip.position,_loc1_,false,true);
         }
         else
         {
            _loc2_ = this._showShieldDamage;
            if(Settings.qualityShip.value <= Settings.QUALITY_LOW)
            {
               _loc2_ = false;
            }
            _loc3_ = this._spawnPointsProvider.getSalvos() || DEFAULT_SALVOS;
            _loc4_ = _loc3_;
            _loc5_ = LaserEmissionSchedule.emissionCount(this._laserTypeID,_loc4_.length);
            if(!_loc5_)
            {
               this._finishRequested = true;
               this.finishIfIdle();
               return;
            }
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = LaserEmissionSchedule.cannonGroupIndex(this._laserTypeID,_loc6_,_loc4_.length);
               _loc8_ = LaserEmissionSchedule.delayMs(this._laserTypeID,_loc6_,_loc4_.length);
               _loc9_ = _loc6_ == _loc5_ - 1;
               if(_loc8_ == 0)
               {
                  this.shotSalvo(_loc4_[_loc7_],_loc1_,_loc2_,_loc9_);
               }
               else
               {
                  this._timeouts.push(setTimeout(this.shotSalvo,_loc8_,_loc4_[_loc7_],_loc1_,_loc2_,_loc9_));
               }
               _loc6_++;
            }
         }
         if(this._laserPattern.getSoundID() != -1)
         {
            AudioManager.playSoundEffect(this._laserPattern.getSoundID(),false,false,this.attackerShip.position.x,this.attackerShip.position.y,this.attackerShip.id == Hero.userID);
         }
      }
      
      private function shotSalvo(param1:Vector.<String>, param2:String, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc5_:String = null;
         if(this._disposed || this._stopped)
         {
            return;
         }
         if(!this.attackerShip || !this.targetShip || !this.attackerShip.position || !this.targetShip.position || !this._spawnPointsProvider)
         {
            this.stop();
            return;
         }
         if(!param1 || !param1.length)
         {
            if(param4)
            {
               this._finishRequested = true;
            }
            this.finishIfIdle();
            return;
         }
         this._spawning = true;
         for each(_loc5_ in param1)
         {
            this._spawnPointsProvider.getLaserCannonLocalPosition(_loc5_,this._tmp);
            this._tmp2.x = this.attackerShip.x + this._tmp.x;
            this._tmp2.y = this.attackerShip.y + this._tmp.y;
            this.shoot(this._tmp2,this.targetShip.position,param2,param3,param4);
         }
         this._spawning = false;
         this.finishIfIdle();
      }
      
      private function finishIfIdle() : void
      {
         if(!this._spawning && this._activeShots == 0 && this._pendingLoads == 0 && (this._stopped || this._finishRequested))
         {
            this.dispose();
         }
      }
      
      private function shoot(param1:PointLite, param2:PointLite, param3:String, param4:Boolean = false, param5:Boolean = false) : void
      {
         var _loc10_:MovieClip = null;
         var _loc16_:PointLite = null;
         var _loc17_:PointLite = null;
         var _loc18_:int = 0;
         var _loc19_:Number = Number(NaN);
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         if(this._disposed)
         {
            return;
         }
         if(!EffectRange2D.link(this.attackerShip.position,this.targetShip.position))
         {
            this.stop();
            return;
         }
         if(!ResourceManager.isLoaded(param3))
         {
            _loc16_ = new PointLite();
            _loc16_.x = param1.x;
            _loc16_.y = param1.y;
            _loc17_ = new PointLite();
            _loc17_.x = param2.x;
            _loc17_.y = param2.y;
            this.loadShotResource(param3,this.shoot,[_loc16_,_loc17_,param3,param4,param5],param5);
            return;
         }
         var _loc6_:Number = param1.x;
         var _loc7_:Number = param1.y;
         var _loc8_:Number = param2.x;
         var _loc9_:Number = param2.y;
         if(this._idleClips.length)
         {
            _loc10_ = this._idleClips.pop();
         }
         else
         {
            _loc10_ = ResourceManager.getMovieClip(param3,"mc");
         }
         if(!this._laserPattern.isAbsorber())
         {
            _loc18_ = this._laserPattern.mcWidth != -1 ? int(this._laserPattern.mcWidth) : int(_loc10_.width);
            _loc19_ = LaserImpactGeometry.stopDistance(_loc18_,1,this._targetRadius);
            if(_loc19_ > 0)
            {
               _loc20_ = _loc6_ - _loc8_;
               _loc21_ = _loc7_ - _loc9_;
               _loc22_ = (_loc9_ - _loc7_) * (_loc9_ - _loc7_) + (_loc8_ - _loc6_) * (_loc8_ - _loc6_);
               if(_loc22_ < _loc19_ * _loc19_)
               {
                  if(param5)
                  {
                     this._finishRequested = true;
                  }
                  this.finishIfIdle();
                  return;
               }
               _loc23_ = FastMath.sqrt(_loc22_);
               _loc8_ = _loc20_ / _loc23_ * _loc19_ + _loc8_;
               _loc9_ = _loc21_ / _loc23_ * _loc19_ + _loc9_;
            }
         }
         _loc10_.play();
         var _loc11_:Number = 0;
         if(!this._laserPattern.playLoop || this._showShieldDamage)
         {
            _loc11_ = Math.atan2(_loc9_ - _loc7_,_loc8_ - _loc6_) * this.RADTODEG;
         }
         var _loc12_:int = Math.round(_loc11_ + 180);
         if(!this._laserPattern.playLoop)
         {
            _loc10_.rotation = _loc12_;
         }
         _loc10_.x = _loc6_;
         _loc10_.y = _loc7_;
         _loc10_.visible = true;
         if(_loc10_.parent == this)
         {
            if(getChildIndex(_loc10_) != numChildren - 1)
            {
               setChildIndex(_loc10_,numChildren - 1);
            }
         }
         else
         {
            addChild(_loc10_);
         }
         ++this._activeShots;
         var _loc13_:Number = this._laserPattern.isAbsorber() ? 0.1 : 1;
         var _loc14_:Number = this._laserPattern.isAbsorber() ? 0.1 : 1;
         var _loc15_:Object = {
            "ease":Linear.easeNone,
            "x":_loc8_,
            "y":_loc9_,
            "onComplete":this.handleLaserRemove,
            "onCompleteParams":[_loc10_,param4,_loc12_,param5]
         };
         if(_loc10_.scaleX != _loc13_)
         {
            _loc15_.scaleX = _loc13_;
         }
         if(_loc10_.scaleY != _loc14_)
         {
            _loc15_.scaleY = _loc14_;
         }
         TweenLite.to(_loc10_,this._laserPattern.getSpeed(),_loc15_);
      }
      
      private function loadShotResource(param1:String, param2:Function, param3:Array, param4:Boolean) : void
      {
         var settled:Boolean = false;
         var started:int = 0;
         var timer:uint = 0;
         var settle:Function = null;
         var resKey:String = param1;
         var callback:Function = param2;
         var args:Array = param3;
         var doDispose:Boolean = param4;
         settle = function(param1:Boolean = false):void
         {
            if(settled)
            {
               return;
            }
            settled = true;
            clearTimeout(timer);
            --_pendingLoads;
            if(_disposed)
            {
               return;
            }
            if(param1 && getTimer() - started < 100)
            {
               callback.apply(null,args);
            }
            else if(doDispose)
            {
               _finishRequested = true;
            }
            finishIfIdle();
         };
         ++this._pendingLoads;
         settled = false;
         started = getTimer();
         timer = setTimeout(settle,100);
         ResourceManager.loadAndCall(resKey,function():void
         {
            settle(true);
         },[],0);
      }
      
      private function handleLaserRemove(param1:MovieClip, param2:Boolean, param3:Number, param4:Boolean) : void
      {
         if(this._disposed)
         {
            return;
         }
         if(this._activeShots > 0)
         {
            --this._activeShots;
         }
         if(Boolean(param1) && Boolean(param1.parent))
         {
            param1.gotoAndStop(1);
            param1.visible = false;
            param1.rotation = 0;
            param1.scaleX = param1.scaleY = 1;
            this._idleClips.push(param1);
         }
         if(param2)
         {
            this.showShieldDamageClip(param4,param3);
         }
         else
         {
            if(param4)
            {
               this._finishRequested = true;
            }
            this.finishIfIdle();
         }
      }
      
      private function showShieldDamageClip(param1:Boolean, param2:Number) : void
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:MouseHitAreaTrait = null;
         var _loc5_:int = 0;
         var _loc6_:MovieClip = null;
         if(this._disposed)
         {
            return;
         }
         if(!ResourceManager.isLoaded(SHIELD_KEY))
         {
            this.loadShotResource(SHIELD_KEY,this.showShieldDamageClip,[param1,param2],param1);
            return;
         }
         if(Boolean(this.targetShip) && (shieldDamageLookUp[this.targetShip.id] == null || shieldDamageLookUp[this.targetShip.id] < 9))
         {
            _loc3_ = this._mapView.entitiesLayer.getViewByTrait(this.targetShip.getFirstTrait(ShipDisplayTrait)) as DisplayObjectContainer;
            _loc4_ = this.targetShip.getFirstTrait(MouseHitAreaTrait) as MouseHitAreaTrait;
            if(!_loc3_ || !_loc4_)
            {
               if(param1)
               {
                  this._finishRequested = true;
               }
               this.finishIfIdle();
               return;
            }
            _loc5_ = _loc4_.clickRadius;
            _loc6_ = ResourceManager.getMovieClip(SHIELD_KEY,"mc");
            _loc6_.scaleX = _loc6_.scaleY = _loc5_ / 100;
            _loc6_.x = int(_loc5_ * Math.cos(param2 * this.DEGTORAD));
            _loc6_.y = int(_loc5_ * Math.sin(param2 * this.DEGTORAD));
            _loc6_.rotation = param2;
            _loc3_.addChild(_loc6_);
            ++this._activeShots;
            TweenLite.to(_loc6_,_loc6_.framesLoaded / 30,{
               "ease":Linear.easeNone,
               "frame":_loc6_.framesLoaded,
               "onComplete":this.handleRemoveShieldDamage,
               "onCompleteParams":[_loc6_,param1,this.targetShip.id]
            });
            shieldDamageLookUp[this.targetShip.id] = int(shieldDamageLookUp[this.targetShip.id]) + 1;
         }
         else
         {
            if(param1)
            {
               this._finishRequested = true;
            }
            this.finishIfIdle();
         }
      }
      
      private function handleRemoveShieldDamage(param1:MovieClip, param2:Boolean, param3:int) : void
      {
         if(Boolean(param1) && Boolean(param1.parent))
         {
            param1.parent.removeChild(param1);
         }
         shieldDamageLookUp[param3] = Math.max(0,int(shieldDamageLookUp[param3]) - 1);
         if(this._activeShots > 0)
         {
            --this._activeShots;
         }
         if(param2)
         {
            this._finishRequested = true;
         }
         this.finishIfIdle();
      }
      
      public function getSalvos() : Vector.<Vector.<String>>
      {
         return DEFAULT_SALVOS;
      }
      
      public function getLaserCannonLocalPosition(param1:String, param2:Vector3D, param3:Number = 0) : void
      {
         param2.setTo(0,0,0);
      }
   }
}

