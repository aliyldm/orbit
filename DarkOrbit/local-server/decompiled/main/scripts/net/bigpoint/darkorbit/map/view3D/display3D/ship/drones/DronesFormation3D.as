package net.bigpoint.darkorbit.map.view3D.display3D.ship.drones
{
   import away3d.containers.ObjectContainer3D;
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.greensock.easing.Quad;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.common.animation.AnimationData;
   import net.bigpoint.darkorbit.map.common.animation.TweenPlayer;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.drones.Drone;
   import net.bigpoint.darkorbit.map.model.ship.drones.DroneFormation;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.MapUberAsset3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.decorators.IMapUberAssetDecorator3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class DronesFormation3D implements IMapUberAssetDecorator3D, IDisposable, IUpdatable
   {
      
      private static const mtx:Matrix3D = new Matrix3D();
      
      private static const _tmpVec:Vector.<Number> = new Vector.<Number>(3,true);
      
      private var _ship:Ship;
      
      private var _drones:Vector.<Drone3D> = new Vector.<Drone3D>();
      
      private var _floatingContainer:ObjectContainer3D;
      
      private var _viewOwner:MapUberAsset3D;
      
      private var _formationRotation:Number = 0;
      
      private var _labelTraits:Dictionary = new Dictionary();
      
      private var _dronesVisibleSettings:BindableBoolean;
      
      public var dronesListChanged:ISignal = new Signal();
      
      public var updateDrones:Boolean = true;
      
      private var _players:Vector.<TweenPlayer> = new Vector.<TweenPlayer>();
      
      private var _disposed:Boolean = false;
      
      public function DronesFormation3D()
      {
         super();
      }
      
      public function initialize(param1:UberDisplayTrait, param2:UberAsset3D, param3:Object) : void
      {
         this._ship = param1.owner as Ship;
         this._viewOwner = param2 as MapUberAsset3D;
         this._dronesVisibleSettings = this._ship.isHeroShip() ? Settings.showMyDrones : Settings.showDrones;
      }
      
      public function decorate() : void
      {
         this.addListeners();
         this._dronesVisibleSettings.changed.add(this.handleListChanged);
         this._ship.drones.droneFormationId.changed.add(this.handleListChanged);
         this._ship.drones.visible.changed.add(this.handleListChanged);
         Settings.show2DFormation.changed.add(this.handleListChanged);
         this.handleListChanged();
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         var _loc2_:Drone3D = null;
         if(this._disposed)
         {
            return;
         }
         this._disposed = true;
         this.clearDrones();
         this.removeListners();
         this._dronesVisibleSettings.changed.remove(this.handleListChanged);
         Settings.show2DFormation.changed.remove(this.handleListChanged);
         this._ship.drones.droneFormationId.changed.remove(this.handleListChanged);
         this._ship.drones.visible.changed.remove(this.handleListChanged);
         while(this._drones.length)
         {
            _loc2_ = this._drones.pop() as Drone3D;
            this._ship.removeTrait(this._labelTraits[_loc2_.drone]);
            _loc2_.disposeView();
         }
      }
      
      public function updateObj(param1:Number) : void
      {
         var _loc2_:DroneFormation = null;
         var _loc3_:Vector3D = null;
         var _loc4_:int = 0;
         var _loc5_:Drone3D = null;
         var _loc6_:int = 0;
         var _loc7_:PointLite = null;
         if(this._disposed || !this._dronesVisibleSettings.value || !this.updateDrones)
         {
            return;
         }
         if(this._drones.length > 0)
         {
            _loc2_ = DroneFormation.standardFormations3D[this._ship.drones.droneFormationId.value];
            if(_loc2_ == null || Settings.show2DFormation.value)
            {
               _loc2_ = DroneFormation.standardFormations[this._ship.drones.droneFormationId.value];
            }
            this._formationRotation = param1 > 0 ? Quad.easeOut(param1,this._formationRotation,this.getShortAngleDegrees(this._formationRotation,this._ship.rotation.degrees),0.3) : this._ship.rotation.degrees;
            mtx.identity();
            mtx.appendScale(this._ship.drones.userScale.value,this._ship.drones.userScale.value,this._ship.drones.userScale.value);
            mtx.appendRotation(this._formationRotation,Vector3D.Y_AXIS);
            _loc4_ = int(this._drones.length);
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               _loc5_ = this._drones[_loc6_];
               _loc3_ = _loc5_.groupRotation;
               _loc7_ = _loc2_.positionToRelativePoint(this._ship.drones.drones.length,_loc5_.drone.index);
               _tmpVec[0] = _loc7_.x;
               _tmpVec[1] = -_loc7_.z;
               _tmpVec[2] = -_loc7_.y;
               if(_loc5_.rotationParent)
               {
                  if(_loc3_)
                  {
                     mtx.appendRotation(_loc3_.z,Vector3D.Z_AXIS);
                     mtx.appendRotation(_loc3_.x,Vector3D.X_AXIS);
                     mtx.appendRotation(_loc3_.y,Vector3D.Y_AXIS);
                  }
                  _loc5_.rotationParent.transform.transformVectors(_tmpVec,_tmpVec);
               }
               mtx.transformVectors(_tmpVec,_tmpVec);
               _loc5_.targetPosition.setTo(_tmpVec[0],_tmpVec[1],_tmpVec[2]);
               _loc5_.updateObj(param1);
               _loc5_.rotationY = this._formationRotation - 90;
               if(_loc5_.rotationParent)
               {
                  if(_loc3_)
                  {
                     mtx.appendRotation(-_loc3_.z,Vector3D.Z_AXIS);
                     mtx.appendRotation(-_loc3_.x,Vector3D.X_AXIS);
                     mtx.appendRotation(-_loc3_.y,Vector3D.Y_AXIS);
                  }
               }
               _loc6_++;
            }
            if(this._viewOwner.positionFloating)
            {
               this._floatingContainer.moveTo(-this._viewOwner.positionFloating.z * this._viewOwner.floatingMoveSrength.z + this._ship.x3D,this._viewOwner.positionFloating.y * this._viewOwner.floatingMoveSrength.y + this._ship.y3D,this._viewOwner.positionFloating.x * this._viewOwner.floatingMoveSrength.x + this._ship.z3D);
            }
            else
            {
               this._floatingContainer.moveTo(this._ship.x3D,this._ship.y3D,this._ship.z3D);
            }
         }
      }
      
      private function addListeners() : void
      {
         this._ship.drones.dronesListChanged.add(this.handleListChanged);
         this._viewOwner.effectMethodsChanged.add(this.updateDronesMaterials);
      }
      
      private function removeListners() : void
      {
         this._ship.drones.dronesListChanged.remove(this.handleListChanged);
         this._viewOwner.effectMethodsChanged.remove(this.updateDronesMaterials);
      }
      
      private function updateDronesMaterials() : void
      {
         var _loc1_:Drone3D = null;
         for each(_loc1_ in this._drones)
         {
            _loc1_.view.removeAllMethods();
            _loc1_.view.addMethods(this._viewOwner.methods);
            _loc1_.view.shader = this._viewOwner.shader;
         }
      }
      
      private function clearDrones() : void
      {
         this._viewOwner.setDroneUpdates(this,false);
         while(this._players.length)
         {
            this._players.pop().dispose();
         }
         while(this._drones.length)
         {
            this._drones.pop().disposeView(true);
         }
         if(this._floatingContainer)
         {
            if(this._floatingContainer.parent)
            {
               this._floatingContainer.parent.removeChild(this._floatingContainer);
            }
            this._floatingContainer.dispose();
            this._floatingContainer = null;
         }
      }
      
      public function handleListChanged() : void
      {
         var _loc1_:Drone3D = null;
         var _loc2_:Drone = null;
         var _loc3_:DroneFormation = null;
         var _loc4_:DroneRotationGroup = null;
         var _loc5_:ObjectContainer3D = null;
         var _loc6_:Number = NaN;
         var _loc7_:AnimationData = null;
         var _loc8_:TweenPlayer = null;
         if(this._disposed)
         {
            return;
         }
         this.clearDrones();
         if(!this.updateDrones)
         {
            return;
         }
         while(this._drones.length)
         {
            _loc1_ = this._drones.pop() as Drone3D;
            _loc1_.disposeView();
         }
         if(this._dronesVisibleSettings.value)
         {
            if(this._ship.drones.visible.value)
            {
               this._floatingContainer = new ObjectContainer3D();
               World3D.instance.mapView.gameWorld.addChild(this._floatingContainer);
               for each(_loc2_ in this._ship.drones.drones)
               {
                  _loc1_ = new Drone3D(_loc2_,this._ship);
                  this._drones.push(_loc1_);
                  this._floatingContainer.addChild(_loc1_);
               }
               this.updateDronesMaterials();
               _loc3_ = DroneFormation.standardFormations3D[this._ship.drones.droneFormationId.value];
               if(_loc3_ == null || Settings.show2DFormation.value)
               {
                  _loc3_ = DroneFormation.standardFormations[this._ship.drones.droneFormationId.value];
               }
               for each(_loc4_ in _loc3_.rotationGroups)
               {
                  _loc5_ = new ObjectContainer3D();
                  for each(_loc6_ in _loc4_.droneIds)
                  {
                     if(_loc6_ - 1 < this._drones.length)
                     {
                        (this._drones[_loc6_ - 1] as Drone3D).rotationParent = _loc5_;
                        (this._drones[_loc6_ - 1] as Drone3D).groupRotation = _loc4_.rotation;
                        this._floatingContainer.addChild(this._drones[_loc6_ - 1]);
                     }
                  }
                  _loc7_ = AnimationData.parse(_loc4_.rotGroupXml);
                  _loc8_ = new TweenPlayer(_loc7_,_loc5_);
                  this._players.push(_loc8_);
                  _loc8_.start();
               }
               this.addListeners();
               this._viewOwner.setDroneUpdates(this,true);
               this.updateObj(0);
               this.dronesListChanged.dispatch();
            }
         }
         else
         {
            this.removeListners();
         }
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
      
      public function get drones() : Vector.<Drone3D>
      {
         return this._drones;
      }
   }
}

