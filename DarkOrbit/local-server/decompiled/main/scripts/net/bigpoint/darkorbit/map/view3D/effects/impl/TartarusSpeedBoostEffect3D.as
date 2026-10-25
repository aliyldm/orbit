package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Cubic;
   import flash.geom.Vector3D;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.effects.impl.TartarusSpeedBoostEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.MapUberAsset3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.prefab.ShipView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.ship.Slot3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.ship.drones.Drone3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberMesh3D;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class TartarusSpeedBoostEffect3D implements IDisposable
   {
      
      private var _mapView:MapView3D;
      
      private var _ship3D:MapUberAsset3D;
      
      private var _ship:Ship;
      
      private var _ship3DLoader:ShipView3D;
      
      private var _effect:TartarusSpeedBoostEffect;
      
      public function TartarusSpeedBoostEffect3D(param1:MapView3D, param2:TartarusSpeedBoostEffect)
      {
         super();
         this._mapView = param1;
         this._effect = param2;
         this._ship = param2.source as Ship;
         this._effect.designChanged.add(this.designSetChanged);
         this._ship3D = param1.mainContainer.getViewByTrait(this._ship.getFirstTrait(UberDisplayTrait)) as MapUberAsset3D;
         this.startEffect();
      }
      
      private function startEffect() : void
      {
         if(this._ship3D == null || this._ship3D.drones == null)
         {
            return;
         }
         this._ship3D.drones.dronesListChanged.addOnce(this.droneAnimation);
         if(this._ship3D.drones.drones.length > 0)
         {
            this.droneAnimation();
         }
      }
      
      private function designSetChanged() : void
      {
         this.removeEngines();
         this.startEffect();
      }
      
      private function droneAnimation() : void
      {
         var _loc4_:UberMesh3D = null;
         var _loc5_:Drone3D = null;
         var _loc6_:Vector3D = null;
         if(this._effect.hasSet == false)
         {
            return;
         }
         if(this._ship3D == null || this._ship3D.drones == null)
         {
            return;
         }
         if(this._ship3D.uberMeshes.length > 0)
         {
            _loc4_ = this._ship3D.uberMeshes[0];
            this._ship3DLoader = ShipView3D(_loc4_.mesh);
         }
         if(this._ship3DLoader == null)
         {
            return;
         }
         this._ship.hasSpeedBuff.value = true;
         this._ship3D.drones.updateDrones = false;
         var _loc1_:Vector.<Drone3D> = this._ship3D.drones.drones;
         var _loc2_:int = int(this._ship3DLoader.dockingPoints.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc1_.length <= _loc3_)
            {
               break;
            }
            _loc5_ = _loc1_[_loc3_];
            _loc5_.position = this._ship3D.inverseSceneTransform.transformVector(_loc5_.scenePosition);
            _loc5_.rotationY = 0;
            if(this._ship3D.floatingTarget)
            {
               this._ship3D.floatingTarget.addChild(_loc5_);
            }
            else
            {
               this._ship3D.addChild(_loc5_);
            }
            _loc6_ = this._ship3DLoader.dockingPoints[_loc3_];
            if(_loc3_ == 1 || _loc3_ == 3 || _loc3_ == 6 || _loc3_ == 8)
            {
               _loc5_.rotationZ = 180;
            }
            TweenMax.to(_loc5_,0.5 + _loc3_ * 0.1,{
               "scaleX":0.5,
               "scaleY":0.5,
               "scaleZ":0.5,
               "rotationY":0,
               "bezier":[{
                  "x":_loc6_.x,
                  "y":250,
                  "z":-300
               },{
                  "x":_loc6_.x,
                  "y":25,
                  "z":-300
               },{
                  "x":_loc6_.x,
                  "y":_loc6_.y,
                  "z":_loc6_.z
               }],
               "delay":0,
               "ease":Cubic.easeIn,
               "onComplete":(_loc3_ == _loc2_ - 1 ? this.attachShip : null)
            });
            _loc3_++;
         }
         this.createNewEnginePositions();
      }
      
      private function createNewEnginePositions() : void
      {
         var _loc1_:Vector.<Slot3D> = new Vector.<Slot3D>();
         if(this._ship3DLoader.dockingPoints.length >= 9)
         {
            _loc1_.push(this._ship3DLoader.dockingPoints[1]);
            _loc1_.push(this._ship3DLoader.dockingPoints[3]);
            _loc1_.push(this._ship3DLoader.dockingPoints[6]);
            _loc1_.push(this._ship3DLoader.dockingPoints[8]);
         }
         if(Settings.displaySetting3DqualityEffects.high.value)
         {
            this._ship.changeEnginePositions.dispatch(_loc1_);
         }
      }
      
      private function attachShip() : void
      {
         ScreenManager.getInstance().eventManager.unlockMovement();
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._ship3D != null && this._ship3D.drones != null)
         {
            this._ship3D.drones.dronesListChanged.remove(this.droneAnimation);
         }
         this._effect.designChanged.remove(this.designSetChanged);
         this.removeEngines();
      }
      
      private function removeEngines() : void
      {
         this._ship.hasSpeedBuff.value = false;
         if(Boolean(this._ship3D) && Boolean(this._ship3D.drones) && Boolean(this._ship3DLoader))
         {
            this._ship3D.drones.updateDrones = true;
            this._ship3D.drones.handleListChanged();
            this._ship.changeEnginePositions.dispatch(this._ship3DLoader.enginesSlots);
         }
      }
   }
}

