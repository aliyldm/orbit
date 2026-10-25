package net.bigpoint.darkorbit.map.view3D.effects.combat.rocket
{
   import away3d.containers.ObjectContainer3D;
   import away3d.core.base.Geometry;
   import away3d.entities.Mesh;
   import away3d.entities.ParticleGroup;
   import away3d.lights.PointLight;
   import away3d.materials.ColorMaterial;
   import away3d.primitives.PlaneGeometry;
   import away3d.primitives.SphereGeometry;
   import away3d.tools.commands.Merge;
   import away3d.tools.helpers.MeshHelper;
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.bindables.BindablePointLite;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import flash.geom.Vector3D;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.effects.impl.DamageReceivedEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.PyroEffect;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.map.model.traits.HPTrait;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.effects.combat.ShieldImpactEffect;
   import net.bigpoint.darkorbit.map.view3D.settings.Settings3D;
   import net.bigpoint.darkorbit.map.view3D.utils.Helper;
   import net.bigpoint.darkorbit.map.view3D.utils.ObjectsPool;
   import net.bigpoint.darkorbit.mvc.battleStation.BattleStationModule;
   import net.bigpoint.darkorbit.pattern.ExplosionPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.RocketPattern;
   import net.bigpoint.darkorbit.pattern.RocketSmokePattern;
   import org.osflash.signals.Promise;
   
   public class TripleBezierRocket3D extends ObjectContainer3D implements IUpdatable
   {
      
      protected static var _geo:Geometry;
      
      protected static var _geo2:Geometry;
      
      public static var PARTICLES:ParticleGroup = null;
      
      public static const UP:Vector3D = Vector3D.Z_AXIS.clone();
      
      private static const _heatSeekingMaterial:ColorMaterial = new ColorMaterial(16711680,0.5);
      
      private static var EXPLOSION_PATTERN:ExplosionPattern = PatternManager.getPyroPattern(3,2);
      
      private var _disposeDelay:int;
      
      private var _showPyro:Boolean;
      
      private var destination:BindablePointLite;
      
      private var _index:int;
      
      private var _shakeScreen:Boolean;
      
      protected const _prevRocketPosition:Vector3D = new Vector3D();
      
      private const _tmpVector3D_1:Vector3D = new Vector3D();
      
      private var _rocketSmokePattern:RocketSmokePattern;
      
      protected var _attackerShip:AttackerTrait;
      
      protected var _targetShip:AttackTargetTrait;
      
      private var _rocketPattern:RocketPattern;
      
      protected var _airstrikeMode:Boolean;
      
      private var _heatSeeking:Boolean;
      
      private var _showExplosion:Boolean;
      
      protected var _hit:Boolean;
      
      private var _gaps:Vector3D = new Vector3D();
      
      private var _mesh:Mesh;
      
      protected var _light:PointLight;
      
      private var _trail:ParticleGroup;
      
      private var _promise:Promise;
      
      protected var dmgDone:Boolean;
      
      private var _attackerIsBattleStationModule:Boolean = false;
      
      private var _shieldRadiusSquared:Number = 0;
      
      private var _heatSeekingMesh:Mesh;
      
      protected var _explosionPattern:ExplosionPattern;
      
      protected var _duration:Number;
      
      public function TripleBezierRocket3D(param1:AttackerTrait, param2:AttackTargetTrait, param3:Boolean, param4:RocketPattern, param5:RocketSmokePattern, param6:Boolean, param7:Boolean = false, param8:Number = 0, param9:Boolean = true, param10:Boolean = false, param11:int = 0, param12:int = 1, param13:Boolean = false)
      {
         var _loc19_:Mesh = null;
         var _loc20_:Mesh = null;
         var _loc21_:Merge = null;
         super();
         this._attackerShip = param1;
         this._targetShip = param2;
         this._hit = param3;
         this._duration = Math.max(1,PointLite.distanceTwoPoints(param1.owner.position,param2.owner.position) / 500);
         this._explosionPattern = null;
         this._showExplosion = param9;
         this._attackerIsBattleStationModule = this._attackerShip.owner is BattleStationModule;
         if(param7)
         {
            this._duration += 0.3;
         }
         this._rocketSmokePattern = param5;
         this._heatSeeking = param6;
         this._airstrikeMode = param7;
         this._rocketPattern = param4;
         if(_geo == null || _geo.subGeometries.length == 0)
         {
            _loc19_ = new Mesh(new PlaneGeometry(param12,param12,param12,param12,true,true));
            _loc20_ = new Mesh(new PlaneGeometry(param12,param12,param12,param12,true,true));
            _loc20_.rotationX = 90;
            _loc21_ = new Merge(false,true,false);
            _loc21_.apply(_loc19_,_loc20_);
            MeshHelper.applyPosition(_loc19_,-0.5,0,0);
            _loc19_.x = _loc19_.y = _loc19_.z = 0;
            _loc19_.rotationY = 90;
            MeshHelper.applyRotations(_loc19_);
            _geo = _loc19_.geometry;
         }
         if(_geo2 == null)
         {
            _geo2 = new SphereGeometry(5);
         }
         this._mesh = ObjectsPool.retrieve("TripleBezierRocket3D_" + this._rocketPattern.resKey) as Mesh;
         var _loc14_:MovieClip = null;
         if(this._mesh == null)
         {
            _loc14_ = ResourceManager.getMovieClip(this._rocketPattern.resKey,"mc");
            this._mesh = Helper.movieclip2mesh("TripleBezierRocket3D_" + this._rocketPattern.resKey,_loc14_,_geo);
         }
         Helper.applyMovieClipScale("TripleBezierRocket3D_" + this._rocketPattern.resKey,this._mesh,_loc14_);
         addChild(this._mesh);
         x = this._attackerShip.owner.x3D;
         y = this._attackerShip.owner.y3D + (this._attackerIsBattleStationModule ? 70 : 0);
         z = this._attackerShip.owner.z3D;
         this._prevRocketPosition.setTo(x,y,z);
         this._light = World3D.instance.lights.getFreeEffectLight(true);
         Settings3D.laserLight.apply(this._light);
         var _loc15_:Object = {
            "dynamicProps":{
               "x":this.getTargetShipXPos,
               "y":this.getTargetShipYPos,
               "z":this.getTargetShipZPos
            },
            "delay":param8,
            "onUpdate":this.onUpdate,
            "onComplete":this.onFinishRocketTween
         };
         if(this._airstrikeMode || this._heatSeeking || this._attackerIsBattleStationModule)
         {
            this._gaps.x = this._attackerShip.rocketLauncher.direction.x;
            this._gaps.y = this._attackerShip.rocketLauncher.direction.y;
            this._gaps.z = this._attackerShip.rocketLauncher.direction.z;
            TweenLite.to(this._gaps,this._duration * 0.7,{
               "x":0,
               "y":0,
               "z":0,
               "delay":_loc15_.delay
            });
         }
         else
         {
            _loc15_.ease = this.getEase();
         }
         var _loc16_:Number = 1;
         var _loc17_:UberDisplayTrait = param2.owner.getFirstTrait(UberDisplayTrait) as UberDisplayTrait;
         if((Boolean(_loc17_)) && _loc17_.descriptor.display3D.length() > 0)
         {
            _loc16_ = Number(Number(_loc17_.descriptor.display3D[0].@visualSize) || 1);
         }
         this._shieldRadiusSquared = _loc16_ * (this._attackerIsBattleStationModule ? 30 : 60);
         this._shieldRadiusSquared *= this._shieldRadiusSquared;
         var _loc18_:Array = this.getBezierPoints(param1,param2);
         if(_loc18_ != null && _loc18_.length > 0)
         {
            _loc15_.bezier = _loc18_;
         }
         TweenLite.to(this,this._duration,_loc15_);
         if(Settings3D.effects.medium.value)
         {
            if(PARTICLES)
            {
               this.fumesEffectReady(PARTICLES);
            }
            else
            {
               this._promise = World3D.instance.particleLoader.loadParticleByUrl(this._rocketSmokePattern.fx3D,World3D.LIFETIME_MAP);
               this._promise.addOnce(this.fumesEffectReady);
            }
         }
         if(this._heatSeeking)
         {
            this._heatSeekingMesh = new Mesh(_geo2,_heatSeekingMaterial);
            addChild(this._heatSeekingMesh);
            this._heatSeekingMesh.z = 25;
         }
         this._duration += 0.3;
         this._airstrikeMode = true;
         this._disposeDelay = param8 * 1000;
         this._showPyro = param10;
         this.destination = param2.owner.position;
         this._index = param11;
         this._shakeScreen = param13;
      }
      
      protected function getBezierPoints(param1:AttackerTrait, param2:AttackTargetTrait) : Array
      {
         var _loc3_:* = {
            "x":param1.owner.x3D,
            "y":param1.owner.y3D,
            "z":param1.owner.z3D
         };
         var _loc4_:* = {
            "x":this.bPoint(param1.owner.x3D,param2.owner.x3D,500),
            "y":this.bPoint(param1.owner.y3D,param2.owner.y3D,500),
            "z":this.bPoint(param1.owner.z3D,param2.owner.z3D,500)
         };
         var _loc5_:* = {
            "x":param2.owner.x3D,
            "y":param2.owner.y3D,
            "z":param2.owner.z3D
         };
         return [_loc3_,_loc4_,_loc5_];
      }
      
      private function bPoint(param1:int, param2:int, param3:int = 300, param4:int = 100) : Number
      {
         var _loc5_:Number = param2 - param1;
         var _loc6_:* = Math.abs(_loc5_);
         _loc5_ = _loc6_ > param3 ? (_loc5_ > 0 ? param3 : -param3) : _loc5_;
         _loc5_ = _loc6_ < param4 ? (_loc5_ > 0 ? param4 : -param4) : _loc5_;
         _loc5_ = _loc5_ + Math.random() * 100 - 50;
         return param1 - _loc5_;
      }
      
      protected function getEase() : Function
      {
         return Linear.easeOut;
      }
      
      protected function onFinishRocketTween() : void
      {
         if(this._showPyro)
         {
            this.playPyroEffect();
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
            if(this._explosionPattern)
            {
               this.showExplosion(this._explosionPattern);
            }
            else
            {
               this.showExplosion(PatternManager.getPyroPattern(ExplosionPattern.TYPE_ROCKET_DAMAGE,1));
            }
            this.shakeShip(2,1);
         }
         if(this._light)
         {
            World3D.instance.lights.freeEffectLight(this._light);
            this._light = null;
         }
         z += 100000;
         setTimeout(this.disposeThis,1500);
      }
      
      private function playPyroEffect() : void
      {
         if(this._attackerShip.owner.container == null)
         {
            return;
         }
         var _loc1_:ExplosionPattern = this._index % 2 == 0 ? PatternManager.getPyroPattern(ExplosionPattern.TYPE_SHIP_EXPLOSION,InGameCatalog.SHIP_ABILITY_SPECTRUM_PRISMATIC_SHIELDING) : PatternManager.getPyroPattern(ExplosionPattern.TYPE_SHIP_EXPLOSION,InGameCatalog.SHIP_ABILITY_SENTINEL_FORTRESS);
         (this._attackerShip.owner.container as Map).effects.addEffectOnce(new PyroEffect(this.destination.x,this.destination.y,this.destination.z,_loc1_));
      }
      
      protected function showExplosion(param1:ExplosionPattern) : void
      {
         if(Settings3D.effects.medium.value && this._showExplosion)
         {
            ScreenManager.getInstance().map.effects.playEffect(new PyroEffect(x,-z,y,param1));
         }
         if(this._shakeScreen)
         {
            ScreenManager.getInstance().shakeScreen();
         }
      }
      
      public function get duration() : Number
      {
         return this._duration;
      }
      
      public function updateObj(param1:Number) : void
      {
         if(this._trail)
         {
            this._trail.animator.time += param1 * 1000 * this._trail.animator.playbackSpeed;
         }
      }
      
      protected function checkForImpact() : void
      {
         var _loc2_:Vector3D = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc1_:HPTrait = Boolean(this._targetShip) && Boolean(this._targetShip.owner) ? this._targetShip.owner.getFirstTrait(HPTrait) as HPTrait : null;
         if(_loc1_)
         {
            _loc2_ = World3D.CALCULATION_VECTOR3D;
            _loc2_.setTo(x - this._targetShip.owner.x3D,y - this._targetShip.owner.y3D,z - this._targetShip.owner.z3D);
            _loc3_ = _loc1_.shield.value > 0 ? this._shieldRadiusSquared : 0.5 * this._shieldRadiusSquared;
            _loc4_ = _loc2_.x * _loc2_.x + _loc2_.y * _loc2_.y + _loc2_.z * _loc2_.z;
            if(_loc4_ < _loc3_)
            {
               this.dmgDone = true;
               if(_loc1_.shield.value > 0 && Settings3D.effects.medium.value)
               {
                  new ShieldImpactEffect(_loc2_.x + x,_loc2_.y + y,_loc2_.z + z,this._targetShip.owner,ShieldImpactEffect.NORMAL_LASER_AND_ROCKET);
               }
               TweenLite.killTweensOf(this);
               TweenLite.killTweensOf(this._gaps);
               this.onFinishRocketTween();
            }
         }
         else
         {
            this.dmgDone = true;
         }
      }
      
      protected function fumesEffectReady(param1:ParticleGroup) : void
      {
         this._trail = ObjectsPool.retrieve("TripleBezierRocket3D_trail_" + this._rocketSmokePattern.fx3D) as ParticleGroup || param1.clone() as ParticleGroup;
         this._trail.animator.resetTime(0);
         addChild(this._trail);
         World3D.instance.mapView.addUpdatable(this);
      }
      
      protected function disposeThis() : void
      {
         World3D.instance.mapView.removeUpdatable(this);
         if(parent)
         {
            parent.removeChild(this);
         }
         if(this._trail)
         {
            this._trail.parent.removeChild(this._trail);
            ObjectsPool.free(this._trail,"TripleBezierRocket3D_trail_" + this._rocketSmokePattern.fx3D);
            this._trail = null;
         }
         if(this._promise)
         {
            this._promise.remove(this.fumesEffectReady);
            this._promise = null;
         }
         if(this._light)
         {
            World3D.instance.lights.freeEffectLight(this._light);
            this._light = null;
         }
         if(this._mesh)
         {
            this._mesh.parent.removeChild(this._mesh);
            ObjectsPool.free(this._mesh,"TripleBezierRocket3D_" + this._rocketPattern.resKey);
            this._mesh = null;
         }
         if(this._heatSeekingMesh)
         {
            if(this._heatSeekingMesh.parent)
            {
               this._heatSeekingMesh.parent.removeChild(this._heatSeekingMesh);
            }
            this._heatSeekingMesh = null;
         }
      }
      
      protected function shakeShip(param1:int, param2:int = 1) : void
      {
      }
      
      protected function onUpdate() : void
      {
         var _loc1_:Vector3D = this._tmpVector3D_1;
         _loc1_.setTo(x - this._prevRocketPosition.x,y - this._prevRocketPosition.y,z - this._prevRocketPosition.z);
         if(_loc1_.lengthSquared > 1)
         {
            _loc1_.incrementBy(position);
            lookAt(_loc1_,Vector3D.Y_AXIS);
            this._prevRocketPosition.copyFrom(position);
         }
         this._light.specular = 1.9 + Math.random() * 0.3;
         this._light.moveTo(x,y,z);
         if(!this.dmgDone && this._hit)
         {
            this.checkForImpact();
         }
      }
      
      protected function getTargetShipXPos() : Number
      {
         return this._targetShip.owner.x3D + this._gaps.x;
      }
      
      protected function getTargetShipYPos() : Number
      {
         return this._targetShip.owner.y3D + this._gaps.y;
      }
      
      protected function getTargetShipZPos() : Number
      {
         return this._targetShip.owner.z3D + this._gaps.z;
      }
   }
}

