package net.bigpoint.darkorbit.map.view2D.display.ship.drones
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.bindables.BindableBoolean;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.common.DroneDisplayBudget;
   import net.bigpoint.darkorbit.map.common.DroneDisplayEntry;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.ship.drones.Drone;
   import net.bigpoint.darkorbit.map.model.ship.drones.DroneFormation;
   import net.bigpoint.darkorbit.map.model.ship.drones.Drones;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.map.view2D.display.ship.Ship2D;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class DronesFormation2D extends Sprite implements IDisposable
   {
      
      private static var registry:Vector.<DronesFormation2D> = new Vector.<DronesFormation2D>();
      
      private static var policy:DroneMotionPolicy2D = new DroneMotionPolicy2D();
      
      private static var policyRevision:uint = uint.MAX_VALUE;
      
      private var _drones:Drones;
      
      private var _viewOwner:Ship2D;
      
      private var _setting:BindableBoolean;
      
      private var _views:Vector.<Drone2D> = new Vector.<Drone2D>();
      
      private var _points:Vector.<PointLite> = new Vector.<PointLite>();
      
      private var _slots:Vector.<DroneMotionSlot2D> = new Vector.<DroneMotionSlot2D>();
      
      private var _heading:Number = 0;
      
      private var _angleStart:Number = 0;
      
      private var _angleDelta:Number = 0;
      
      private var _angleTime:Number = 0.1;
      
      private var _lastTarget:Number = NaN;
      
      private var _dirty:Boolean = true;
      
      private var _settled:Boolean = false;
      
      private var _disposed:Boolean = false;
      
      private var _lastFrame:int = -1;
      
      private var _dense:Boolean = false;
      
      private var _stepTime:Number = 0;
      
      private var _eligible:Boolean;
      
      private var _budget:DroneDisplayEntry;
      
      private var _listening:Boolean = false;
      
      private var _allowed:Boolean = false;
      
      private var _budgetAllowed:Boolean = false;
      
      private var _presentationEnabled:Boolean = true;
      
      private var _trails:Boolean = false;
      
      public function DronesFormation2D(param1:Drones, param2:Ship2D)
      {
         super();
         this._drones = param1;
         this._viewOwner = param2;
         this._heading = param2.ship.rotation.degrees;
         this._eligible = !param2.ship.isNPC && !(param2.ship is Pet);
         this._setting = param2.ship.isHeroShip() ? Settings.showMyDrones : Settings.showDrones;
         if(this._eligible)
         {
            registry.push(this);
         }
         this._budget = DroneDisplayBudget.add(param2.ship,this.budgetChanged);
      }
      
      private function invalidate() : void
      {
         this._dirty = true;
         this._settled = false;
      }
      
      private function clear() : void
      {
         var _loc1_:Drone2D = null;
         for each(_loc1_ in this._views)
         {
            _loc1_.loaded.remove(this.invalidate);
            _loc1_.disposeView(true);
            removeChild(_loc1_);
         }
         this._views.length = 0;
         this._points.length = 0;
         this._slots.length = 0;
      }
      
      private function rebuild() : void
      {
         var _loc1_:Drone = null;
         var _loc2_:Drone2D = null;
         if(this._disposed)
         {
            return;
         }
         this.clear();
         if(this._allowed && this._setting.value && this._drones.visible.value)
         {
            for each(_loc1_ in this._drones.drones)
            {
               _loc2_ = new Drone2D(_loc1_,this._viewOwner.ship,this._trails);
               _loc2_.loaded.add(this.invalidate);
               this._views.push(_loc2_);
               this._slots.push(new DroneMotionSlot2D());
               addChild(_loc2_);
            }
         }
         this._lastFrame = -1;
         this._lastTarget = NaN;
         this.invalidate();
         this.updateObj(0);
      }
      
      public function updateObj(param1:Number) : void
      {
         var _loc15_:DroneFormation = null;
         var _loc16_:Drone = null;
         var _loc17_:PointLite = null;
         var _loc18_:DroneMotionSlot2D = null;
         var _loc19_:Drone2D = null;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         if(this._disposed)
         {
            return;
         }
         if(!this._allowed || !this._views.length)
         {
            return;
         }
         if(Settings.showDrones.value && policyRevision != DroneDisplayBudget.revision)
         {
            policyRevision = DroneDisplayBudget.revision;
            policy.update(DroneDisplayBudget.nearby,ScreenManager.getInstance().frameTime);
         }
         var _loc2_:Boolean = Settings.showDrones.value && this._eligible && policy.dense;
         var _loc3_:Boolean = _loc2_ != this._dense;
         if(_loc3_)
         {
            this._dense = _loc2_;
            this._settled = false;
            this._lastTarget = NaN;
            this._stepTime = 0;
         }
         if(this._dense && param1 > 0 && !this._dirty && !_loc3_)
         {
            this._stepTime += param1;
            if(this._stepTime < 0.05)
            {
               return;
            }
            param1 = this._stepTime;
            this._stepTime = 0;
         }
         else
         {
            this._stepTime = 0;
         }
         var _loc4_:Number = (this._viewOwner.ship.rotation.degrees % 360 + 360) % 360;
         var _loc5_:Boolean = _loc4_ != this._lastTarget;
         if(!this._dirty && !_loc3_ && !_loc5_ && this._settled)
         {
            return;
         }
         if(this._dirty)
         {
            this._points.length = 0;
            _loc15_ = DroneFormation.standardFormations[this._drones.droneFormationId.value];
            for each(_loc16_ in this._drones.drones)
            {
               this._points.push(_loc15_.positionToRelativePoint(this._drones.drones.length,_loc16_.index));
            }
         }
         var _loc6_:Number = (_loc4_ - this._heading + 540) % 360 - 180;
         if(this._dense)
         {
            this._heading = (this._heading + _loc6_ * (param1 > 0 ? Math.min(1,param1 / 0.1) : 1) + 360) % 360;
         }
         else
         {
            if(_loc5_)
            {
               this._angleStart = this._heading;
               this._angleDelta = _loc6_;
               this._angleTime = 0;
            }
            this._angleTime = param1 > 0 ? Math.min(0.1,this._angleTime + param1) : 0.1;
            this._heading = (this._angleStart + this._angleDelta * this._angleTime / 0.1 + 360) % 360;
         }
         var _loc7_:Boolean = this._dense || _loc5_ || this._dirty;
         var _loc8_:Number = (this._dense ? this._heading : _loc4_) * Math.PI / 180;
         var _loc9_:Number = Math.cos(_loc8_) * this._drones.userScale.value;
         var _loc10_:Number = Math.sin(_loc8_) * this._drones.userScale.value;
         var _loc11_:int = int(this._heading / 11.25 + 0.5) % 32;
         var _loc12_:Boolean = this._dirty || _loc11_ != this._lastFrame;
         var _loc13_:Number = param1 > 0 ? Math.min(1,param1 / 0.15) : 1;
         this._settled = Math.abs((_loc4_ - this._heading + 540) % 360 - 180) < 0.01;
         var _loc14_:int = 0;
         while(_loc14_ < this._views.length)
         {
            _loc17_ = this._points[_loc14_];
            if(_loc17_)
            {
               _loc18_ = this._slots[_loc14_];
               _loc19_ = this._views[_loc14_];
               if(_loc7_)
               {
                  _loc22_ = _loc17_.x * _loc9_ - _loc17_.y * _loc10_;
                  _loc23_ = _loc17_.x * _loc10_ + _loc17_.y * _loc9_;
                  if(_loc22_ != _loc18_.tx || _loc23_ != _loc18_.ty || _loc3_)
                  {
                     _loc18_.sx = _loc18_.x;
                     _loc18_.sy = _loc18_.y;
                     _loc18_.tx = _loc22_;
                     _loc18_.ty = _loc23_;
                     _loc18_.time = 0;
                  }
               }
               if(this._dense)
               {
                  _loc20_ = _loc18_.x + (_loc18_.tx - _loc18_.x) * _loc13_;
                  _loc21_ = _loc18_.y + (_loc18_.ty - _loc18_.y) * _loc13_;
               }
               else
               {
                  _loc18_.time = param1 > 0 ? Math.min(0.5,_loc18_.time + param1) : 0.5;
                  _loc24_ = _loc18_.time / 0.5;
                  _loc25_ = _loc24_ * (2 - _loc24_);
                  _loc20_ = _loc18_.sx + (_loc18_.tx - _loc18_.sx) * _loc25_;
                  _loc21_ = _loc18_.sy + (_loc18_.ty - _loc18_.sy) * _loc25_;
               }
               if(Math.abs(_loc18_.tx - _loc20_) + Math.abs(_loc18_.ty - _loc21_) < 0.05)
               {
                  _loc20_ = _loc18_.tx;
                  _loc21_ = _loc18_.ty;
               }
               else
               {
                  this._settled = false;
               }
               if(_loc20_ != _loc18_.x)
               {
                  _loc18_.x = _loc20_;
                  _loc19_.x = _loc20_;
               }
               if(_loc21_ != _loc18_.y)
               {
                  _loc18_.y = _loc21_;
                  _loc19_.y = _loc21_;
               }
               if(_loc12_)
               {
                  _loc19_.clipRotation = this._heading;
               }
            }
            _loc14_++;
         }
         this._lastFrame = _loc11_;
         this._lastTarget = _loc4_;
         this._dirty = false;
      }
      
      private function budgetChanged(param1:Boolean, param2:Boolean) : void
      {
         this._budgetAllowed = param1;
         this._trails = param2;
         this.applyAllowed();
      }
      
      public function setPresentationEnabled(param1:Boolean) : void
      {
         if(this._presentationEnabled == param1)
         {
            return;
         }
         this._presentationEnabled = param1;
         visible = param1;
         this.applyAllowed();
      }
      
      private function applyAllowed() : void
      {
         var _loc3_:Drone2D = null;
         var _loc1_:Boolean = this._budgetAllowed && this._presentationEnabled;
         var _loc2_:Boolean = this._allowed != _loc1_;
         this._allowed = _loc1_;
         if(_loc2_)
         {
            this.listen(_loc1_);
            this.rebuild();
         }
         else
         {
            for each(_loc3_ in this._views)
            {
               _loc3_.setTrailsAllowed(this._trails);
            }
         }
      }
      
      private function listen(param1:Boolean) : void
      {
         if(this._listening == param1)
         {
            return;
         }
         this._listening = param1;
         if(param1)
         {
            Settings.qualityShip.changed.add(this.rebuild);
            this._drones.dronesListChanged.add(this.rebuild);
            this._drones.visible.changed.add(this.rebuild);
            this._drones.droneFormationId.changed.add(this.invalidate);
            this._drones.userScale.changed.add(this.invalidate);
         }
         else
         {
            Settings.qualityShip.changed.remove(this.rebuild);
            this._drones.dronesListChanged.remove(this.rebuild);
            this._drones.visible.changed.remove(this.rebuild);
            this._drones.droneFormationId.changed.remove(this.invalidate);
            this._drones.userScale.changed.remove(this.invalidate);
         }
      }
      
      public function get active() : Boolean
      {
         return this._allowed && this._views.length > 0;
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._disposed)
         {
            return;
         }
         this._disposed = true;
         var _loc2_:int = registry.indexOf(this);
         if(_loc2_ >= 0)
         {
            registry.splice(_loc2_,1);
         }
         DroneDisplayBudget.remove(this._budget);
         this._budget = null;
         if(!registry.length)
         {
            policy = new DroneMotionPolicy2D();
            policyRevision = uint.MAX_VALUE;
         }
         Settings.qualityShip.changed.remove(this.rebuild);
         this._drones.dronesListChanged.remove(this.rebuild);
         this._drones.visible.changed.remove(this.rebuild);
         this._drones.droneFormationId.changed.remove(this.invalidate);
         this._drones.userScale.changed.remove(this.invalidate);
         this.clear();
      }
   }
}

class DroneMotionSlot2D
{
   
   public var x:Number = 0;
   
   public var y:Number = 0;
   
   public var sx:Number = 0;
   
   public var sy:Number = 0;
   
   public var tx:Number = 0;
   
   public var ty:Number = 0;
   
   public var time:Number = 0.5;
   
   public function DroneMotionSlot2D()
   {
      super();
   }
}
