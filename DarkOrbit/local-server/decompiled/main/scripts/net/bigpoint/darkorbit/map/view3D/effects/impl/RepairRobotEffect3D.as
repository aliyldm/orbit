package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import away3d.containers.ObjectContainer3D;
   import away3d.entities.ParticleGroup;
   import away3d.lights.PointLight;
   import com.greensock.TweenNano;
   import com.greensock.easing.Quad;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.effects.impl.RepairRobotEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.RepairRobotPattern;
   import org.osflash.signals.Promise;
   
   public class RepairRobotEffect3D extends ObjectContainer3D implements IDisposable, IUpdatable
   {
      
      private var _effect:RepairRobotEffect;
      
      private var _robotPattern:RepairRobotPattern;
      
      private var _robots:Vector.<RobotBehavior3D> = new Vector.<RobotBehavior3D>();
      
      private var _sparks:ParticleGroup;
      
      private var _pointLight:PointLight;
      
      private var _sparksPattern:RepairRobotPattern;
      
      private var _sparksAssetPromise:Promise;
      
      public function RepairRobotEffect3D(param1:MapView3D, param2:RepairRobotEffect)
      {
         super();
         this._effect = param2;
         this._effect.repairBotId.changed.add(this.reload);
         this._effect.repairSkillLevel.changed.add(this.reload);
         this.reload();
      }
      
      private function reload() : void
      {
         this.cleanup();
         this.init();
      }
      
      private function init() : void
      {
         this._robotPattern = PatternManager.getRepairRobotPattern(this._effect.repairBotId.value);
         if(this._robotPattern == null)
         {
            this._robotPattern = PatternManager.getRepairRobotPattern("_default");
         }
         this._sparksPattern = PatternManager.getRepairSparksPattern(this._effect.repairSkillLevel.value);
         if(this._sparksPattern == null)
         {
            this._sparksPattern = PatternManager.getRepairSparksPattern(0);
         }
         this._sparksAssetPromise = World3D.instance.particleLoader.loadParticleByUrl(this._sparksPattern.asset3D,World3D.LIFETIME_MAP);
         this._sparksAssetPromise.addOnce(this.particlesReady);
      }
      
      private function particlesReady(param1:ParticleGroup) : void
      {
         var _loc3_:RobotBehavior3D = null;
         this._sparks = param1.clone() as ParticleGroup;
         this._sparks.scaleX = this._sparks.scaleY = this._sparks.scaleZ = 0.6;
         var _loc2_:int = 0;
         while(_loc2_ < this._robotPattern.robotsNum)
         {
            _loc3_ = new RobotBehavior3D(this._robotPattern.asset3D,this._sparks,Ship(this._effect.source).hitArea.clickRadius + 10);
            addChild(_loc3_);
            this._robots.push(_loc3_);
            _loc2_++;
         }
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_REPAIR_START);
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_REPAIR_BOT,true,true,this._effect.source.position.x,this._effect.source.position.y,true,true);
         this._pointLight = World3D.instance.lights.getFreeEffectLight(true);
         this._pointLight.color = this._effect.repairSkillLevel.value == 0 ? 16777088 : 7182048;
         this._pointLight.specular = 12;
         this._pointLight.fallOff = 60;
         this._pointLight.diffuse = 10;
         this.showLight();
         World3D.instance.mapView.gameWorld.addChild(this);
         World3D.instance.mapView.addUpdatable(this);
      }
      
      private function showLight() : void
      {
         this._pointLight.fallOff = Math.random() * 70;
         TweenNano.delayedCall(0.07,this.showLight);
      }
      
      private function cleanup() : void
      {
         while(this._robots.length)
         {
            this._robots.pop().disposeView(true);
         }
         if(this.parent != null)
         {
            this.parent.removeChild(this);
         }
         if(this._sparksAssetPromise)
         {
            this._sparksAssetPromise.remove(this.particlesReady);
            this._sparksAssetPromise = null;
         }
         World3D.instance.mapView.removeUpdatable(this);
         AudioManager.removeUniqueChannelById(InGameCatalog.SOUND_ID_REPAIR_START,false);
         AudioManager.removeUniqueChannelById(InGameCatalog.SOUND_ID_REPAIR_BOT,false);
         if(this._pointLight)
         {
            World3D.instance.lights.freeEffectLight(this._pointLight);
            TweenNano.killTweensOf(this.showLight);
            this._pointLight = null;
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this.cleanup();
      }
      
      public function updateObj(param1:Number) : void
      {
         var _loc2_:RobotBehavior3D = null;
         moveTo(this._effect.source.x3D,this._effect.source.y3D,this._effect.source.z3D);
         rotationY = param1 > 0 ? Quad.easeOut(param1,rotationY,this.getShortAngleDegrees(rotationY,this.shipRotation),1) : this.shipRotation;
         for each(_loc2_ in this._robots)
         {
            _loc2_.update(param1);
         }
         if(this._pointLight)
         {
            this._pointLight.moveTo(this.x,this.y + 10,this.z);
         }
      }
      
      private function get shipRotation() : Number
      {
         return (this._effect.source as Ship).rotation.degrees;
      }
      
      private function getShortAngleDegrees(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = (param2 - param1) % 360;
         if(_loc3_ != _loc3_ % 180)
         {
            _loc3_ = _loc3_ < 0 ? _loc3_ + 360 : _loc3_ - 360;
         }
         return _loc3_;
      }
   }
}

import away3d.containers.ObjectContainer3D;
import away3d.core.math.Quaternion;
import away3d.entities.ParticleGroup;
import com.greensock.TweenNano;
import flash.geom.Vector3D;
import net.bigpoint.darkorbit.map.common.IDisposable;
import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
import net.bigpoint.darkorbit.utils.math.FastMath;

class RobotBehavior3D extends ObjectContainer3D implements IDisposable
{
   
   private static const MOVE_TIME:Number = 3;
   
   private var _sparks:ParticleGroup;
   
   private var _waitingTime:Number;
   
   private var _currentWaitTime:Number = 0;
   
   private var _currentMoveTime:Number = 0;
   
   private var _desireQuaternion:Quaternion;
   
   private var _currQuaternion:Quaternion;
   
   private var _rotTmp:Vector3D;
   
   private var _uberAsset:UberAsset3D;
   
   private var b:Boolean = true;
   
   public function RobotBehavior3D(param1:String, param2:ParticleGroup, param3:Number)
   {
      super();
      this._sparks = param2.clone() as ParticleGroup;
      this._sparks.y = param3 * 0.45;
      addChild(this._sparks);
      this._uberAsset = new UberAsset3D(UberAssetsLib.instance.getDescriptor(param1,UberAssetsLib.LIB_DEFAULT).display3D[0]);
      this._uberAsset.y = param3;
      addChild(this._uberAsset);
      this._desireQuaternion = new Quaternion();
      this._currQuaternion = new Quaternion();
      this.reset();
   }
   
   public function update(param1:Number) : void
   {
      if(this._currentMoveTime < 1)
      {
         this._currQuaternion.slerp(this._currQuaternion,this._desireQuaternion,this._currentMoveTime);
         this._rotTmp = this._currQuaternion.toEulerAngles(this._rotTmp);
         this._rotTmp.scaleBy(FastMath.RADTODEG);
         rotationX = this._rotTmp.x;
         rotationY = this._rotTmp.y;
         rotationZ = this._rotTmp.z;
         this.switchSparksOnOff();
         this._currentMoveTime += param1 / MOVE_TIME;
      }
      else if(this._currentWaitTime < 1)
      {
         this._currentWaitTime += param1 / this._waitingTime;
      }
      else
      {
         this.reset();
      }
      this._sparks.animator.time += param1 * 1000 * this._sparks.animator.playbackSpeed;
   }
   
   private function switchSparksOnOff() : void
   {
      if(this.b)
      {
         this._sparks.visible = false;
         TweenNano.delayedCall(this._waitingTime - 0.1,this.sparksOff);
         this.b = false;
      }
   }
   
   private function sparksOff() : void
   {
      this._sparks.visible = true;
   }
   
   private function reset() : void
   {
      this._desireQuaternion.fromEulerAngles(this.randomBetween(0,Math.PI) + Math.PI / 2,0,this.randomBetween(0,Math.PI) + Math.PI / 2);
      this._currentWaitTime = 0;
      this._currentMoveTime = 0;
      this._waitingTime = this.randomBetween(0,3.5);
      this.b = true;
   }
   
   public function disposeView(param1:Boolean = false) : void
   {
      if(this._uberAsset != null)
      {
         this._uberAsset.disposeView();
         this._uberAsset = null;
      }
      if(parent)
      {
         parent.removeChild(this);
      }
   }
   
   private function randomBetween(param1:Number, param2:Number) : Number
   {
      return param1 + Math.random() * (param2 - param1);
   }
}
