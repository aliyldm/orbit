package net.bigpoint.darkorbit.map.view3D.display3D.ship.engine
{
   import away3d.entities.ParticleGroup;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.prefab.ShipView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.ship.*;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberMesh3D;
   import net.bigpoint.darkorbit.map.view3D.settings.Settings3D;
   import net.bigpoint.darkorbit.pattern.AudibleResourcePattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.BindableSettings;
   import net.bigpoint.darkorbit.settings.CrowdedCombatPreset;
   
   public class Engines3D implements IUpdatable, IDisposable
   {
      
      private static const QUALITY_SETTING:BindableSettings = Settings3D.effects;
      
      public static var ENABLED:Boolean = true;
      
      public static const STANDARD_PARTICLE:String = "thruster.zip";
      
      private static const SPEED_BUFF_PARTICLE:String = "speed_buff.zip";
      
      public var tilt:Number = 0;
      
      private var _engineViews:Vector.<ParticleGroup> = new Vector.<ParticleGroup>();
      
      private var _trail:EngineTrails;
      
      private var _viewOwner:Ship3D;
      
      private var _ship:Ship;
      
      private var _ship3DLoader:ShipView3D;
      
      private var _path:String = "thruster.zip";
      
      private var _speedBuffViews:Vector.<ParticleGroup> = new Vector.<ParticleGroup>();
      
      private var _attackerTrait:AttackerTrait;
      
      private var _engineScale:Number = 1;
      
      private var _enginePosition:Vector.<Slot3D>;
      
      public function Engines3D(param1:Ship3D)
      {
         var _loc2_:UberMesh3D = null;
         super();
         this._viewOwner = param1;
         this._ship = this._viewOwner.ship;
         if(this._ship.shipPattern.engine3DRes.length > 0)
         {
            this._path = this._ship.shipPattern.engine3DRes;
         }
         this._attackerTrait = this._ship.getFirstTrait(AttackerTrait) as AttackerTrait;
         if(Boolean(this._viewOwner.view) && this._viewOwner.view.uberMeshes.length > 0)
         {
            _loc2_ = this._viewOwner.view.uberMeshes[0];
            this._ship3DLoader = ShipView3D(_loc2_.mesh);
            this._enginePosition = this._ship3DLoader.enginesSlots;
            QUALITY_SETTING.changed.add(this.reload);
            this._ship.hasSpeedBuff.changed.add(this.setSpeedBuff);
            this._attackerTrait.targetChanged.add(this.onTargetChanged);
            this._ship.changeEnginePositions.add(this.changeEnginePositions);
            this.reload();
         }
      }
      
      private function changeEnginePositions(param1:Vector.<Slot3D>) : void
      {
         this._enginePosition = param1;
         this.reload();
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this._ship3DLoader = null;
         QUALITY_SETTING.changed.remove(this.reload);
         this._ship.hasSpeedBuff.changed.remove(this.setSpeedBuff);
         this._ship.changeEnginePositions.remove(this.changeEnginePositions);
         this._attackerTrait.targetChanged.remove(this.onTargetChanged);
         this.disposeEffects(0);
         AudioManager.removeUniqueChannelById(this.enginePattern.getSoundID(),true);
      }
      
      public function onTargetChanged() : void
      {
         var _loc1_:ParticleGroup = null;
         for each(_loc1_ in this._speedBuffViews)
         {
            _loc1_.visible = this._attackerTrait.target == null;
         }
      }
      
      public function updateObj(param1:Number) : void
      {
         var _loc2_:ParticleGroup = null;
         var _loc4_:* = 0;
         var _loc3_:Boolean = this._viewOwner.ship.moveTrait.isMoving;
         var _loc5_:Number = _loc3_ ? 1 : (this._ship.isNPC ? 0 : 0.7);
         _loc5_ = _loc5_ * (this._ship.hasSpeedBuff.value ? 3 : 1.5);
         _loc4_ = int(this._engineViews.length - 1);
         while(_loc4_ >= 0)
         {
            _loc2_ = this._engineViews[_loc4_];
            if(this._engineScale == 1)
            {
               _loc2_.scaleX = _loc2_.scaleY = _loc2_.scaleZ = Linear.easeNone(0.1,_loc2_.scaleX,_loc5_ / (_loc2_.parent.scaleX * _loc2_.parent.parent.scaleX) - _loc2_.scaleX,0.5);
            }
            else
            {
               _loc2_.scaleX = _loc2_.scaleY = _loc2_.scaleZ = this._engineScale;
            }
            _loc2_.rotationY = this.tilt / 4;
            if(_loc2_.scaleX > 0.01)
            {
               _loc2_.visible = true;
               _loc2_.animator.time += int(param1 * 1000);
            }
            else
            {
               _loc2_.visible = false;
            }
            _loc4_--;
         }
         if(this._trail)
         {
            this._trail.updateObj(param1);
         }
         if(this._ship.isHeroShip() && this.enginePattern.getSoundID() != -1)
         {
            if(this._ship.moveTrait.isMoving)
            {
               AudioManager.playSoundEffect(this.enginePattern.getSoundID(),true,true,-1,-1,true,true);
            }
            else
            {
               AudioManager.removeUniqueChannelById(this.enginePattern.getSoundID(),true);
            }
         }
      }
      
      private function reload(param1:Number = 0.3) : void
      {
         var _loc2_:UberDisplayTrait = null;
         var _loc3_:uint = 0;
         this.disposeEffects(param1);
         if(this._ship3DLoader)
         {
            if(this.checkTrailQualitySettings())
            {
               _loc2_ = this._ship.getFirstTrait(UberDisplayTrait) as UberDisplayTrait;
               _loc3_ = 5948376;
               if(Boolean(_loc2_) && Boolean(_loc2_.descriptor.display3D) && Boolean(String(_loc2_.descriptor.display3D[0].@engineTrailColor)))
               {
                  _loc3_ = uint(uint(String(_loc2_.descriptor.display3D[0].@engineTrailColor)) || 5948376);
               }
               if(Boolean(_loc2_) && Boolean(_loc2_.descriptor.display3D) && Boolean(String(_loc2_.descriptor.display3D[0].@engineScale)))
               {
                  this._engineScale = Number(String(_loc2_.descriptor.display3D[0].@engineScale)) || 1;
               }
               this._trail = new EngineTrails(this._viewOwner.view.uberMeshes[0],this._enginePosition,this._ship.rotation,_loc3_);
               World3D.instance.mapView.gameWorld.addChild(this._trail);
            }
            if(this.checkAuraQualitySettings())
            {
               World3D.instance.particleLoader.loadParticleByUrl(this._path,World3D.LIFETIME_GLOBAL).addOnce(this.handleNormalEffectReady);
            }
         }
      }
      
      private function handleNormalEffectReady(param1:ParticleGroup) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Slot3D = null;
         var _loc4_:ParticleGroup = null;
         if(!this.checkAuraQualitySettings())
         {
            return;
         }
         if(this._ship3DLoader)
         {
            _loc2_ = Math.random() * 1000;
            for each(_loc3_ in this._enginePosition)
            {
               if(this._engineViews.length > 0)
               {
                  _loc2_ = this._engineViews[0].animator.time;
               }
               _loc4_ = param1.clone() as ParticleGroup;
               _loc4_.animator.time = _loc2_;
               _loc4_.position = _loc3_;
               _loc4_.scale(this._engineScale);
               _loc4_.rotationX = 180;
               _loc4_.customParamters.slot = _loc3_;
               this._engineViews.push(_loc4_);
               this._viewOwner.view.uberMeshes[0].addChild(_loc4_);
            }
         }
      }
      
      private function checkAuraQualitySettings() : Boolean
      {
         if(!ENABLED)
         {
            return false;
         }
         if(CrowdedCombatPreset.enabled && !this._ship.isHeroShip())
         {
            return false;
         }
         if(Settings3D.effects.high.value)
         {
            return true;
         }
         if(Settings3D.effects.medium.value)
         {
            return !this._ship.isNPC;
         }
         return false;
      }
      
      private function checkTrailQualitySettings() : Boolean
      {
         if(!ENABLED)
         {
            return false;
         }
         if(CrowdedCombatPreset.enabled && !this._ship.isHeroShip())
         {
            return false;
         }
         if(Settings3D.effects.high.value)
         {
            return true;
         }
         if(Settings3D.effects.medium.value)
         {
            return !this._ship.isNPC;
         }
         return false;
      }
      
      private function disposeEffects(param1:Number) : void
      {
         var _loc2_:ParticleGroup = null;
         var _loc3_:ParticleGroup = null;
         while(this._engineViews.length)
         {
            _loc2_ = this._engineViews.pop() as ParticleGroup;
            if(param1)
            {
               TweenLite.to(_loc2_,param1,{
                  "scaleX":0,
                  "scaleY":0,
                  "scaleZ":0,
                  "onComplete":_loc2_.parent.removeChild,
                  "onCompleteParams":[_loc2_]
               });
            }
            else
            {
               _loc2_.parent.removeChild(_loc2_);
            }
         }
         if(this._trail)
         {
            this._trail.parent.removeChild(this._trail);
            this._trail.dispose();
            this._trail = null;
         }
         while(this._speedBuffViews.length)
         {
            _loc3_ = this._speedBuffViews.pop();
            _loc3_.animator.stop();
            if(_loc3_.parent)
            {
               _loc3_.parent.removeChild(_loc3_);
            }
         }
      }
      
      private function setSpeedBuff() : void
      {
         var _loc1_:ParticleGroup = null;
         var _loc2_:ParticleGroup = null;
         if(CrowdedCombatPreset.enabled && !this._ship.isHeroShip())
         {
            return;
         }
         if(this._ship.hasSpeedBuff.value)
         {
            if(this._speedBuffViews.length <= 0)
            {
               World3D.instance.particleLoader.loadParticleByUrl(SPEED_BUFF_PARTICLE,World3D.LIFETIME_GLOBAL).addOnce(this.handleSpeedBuffLoaded);
            }
            else
            {
               for each(_loc1_ in this._speedBuffViews)
               {
                  _loc1_.animator.start();
                  this._viewOwner.view.uberMeshes[0].addChild(_loc1_);
               }
            }
         }
         else
         {
            for each(_loc2_ in this._speedBuffViews)
            {
               _loc2_.animator.stop();
               if(_loc2_.parent)
               {
                  _loc2_.parent.removeChild(_loc2_);
               }
            }
         }
      }
      
      private function handleSpeedBuffLoaded(param1:ParticleGroup) : void
      {
         var _loc2_:ParticleGroup = null;
         var _loc3_:Slot3D = null;
         var _loc4_:ParticleGroup = null;
         for each(_loc2_ in this._speedBuffViews)
         {
            _loc2_.animator.start();
            this._viewOwner.view.uberMeshes[0].addChild(_loc2_);
         }
         if(this._ship3DLoader)
         {
            for each(_loc3_ in this._enginePosition)
            {
               _loc4_ = param1.clone() as ParticleGroup;
               _loc4_.position = _loc3_;
               _loc4_.rotationX = 180;
               _loc4_.animator.start();
               this._viewOwner.view.uberMeshes[0].addChild(_loc4_);
               this._speedBuffViews.push(_loc4_);
            }
         }
      }
      
      private function get enginePattern() : AudibleResourcePattern
      {
         return PatternManager.enginePatterns[this._ship.shipPattern.getEngineTypeID()];
      }
   }
}

