package away3d.core.base
{
   import away3d.*;
   import away3d.controllers.*;
   import away3d.core.math.*;
   import away3d.events.*;
   import away3d.library.assets.*;
   import flash.geom.*;
   
   use namespace arcane;
   
   public class Object3D extends NamedAssetBase
   {
      
      private static var tempAxeX:Vector3D;
      
      private static var tempAxeY:Vector3D;
      
      private static var tempAxeZ:Vector3D;
      
      arcane var _controller:ControllerBase;
      
      private var _smallestNumber:Number = 1e-22;
      
      private var _transformDirty:Boolean = true;
      
      private var _positionDirty:Boolean;
      
      private var _rotationDirty:Boolean;
      
      private var _scaleDirty:Boolean;
      
      private var _positionChanged:Object3DEvent;
      
      private var _rotationChanged:Object3DEvent;
      
      private var _scaleChanged:Object3DEvent;
      
      private var _rotationX:Number = 0;
      
      private var _rotationY:Number = 0;
      
      private var _rotationZ:Number = 0;
      
      private var _eulers:Vector3D = new Vector3D();
      
      private var _flipY:Matrix3D = new Matrix3D();
      
      private var _listenToPositionChanged:Boolean;
      
      private var _listenToRotationChanged:Boolean;
      
      private var _listenToScaleChanged:Boolean;
      
      protected var _zOffset:int = 0;
      
      protected var _transform:Matrix3D = new Matrix3D();
      
      protected var _scaleX:Number = 1;
      
      protected var _scaleY:Number = 1;
      
      protected var _scaleZ:Number = 1;
      
      protected var _x:Number = 0;
      
      protected var _y:Number = 0;
      
      protected var _z:Number = 0;
      
      protected var _pivotPoint:Vector3D = new Vector3D();
      
      protected var _pivotZero:Boolean = true;
      
      protected var _pos:Vector3D = new Vector3D();
      
      protected var _rot:Vector3D = new Vector3D();
      
      protected var _sca:Vector3D = new Vector3D();
      
      protected var _transformComponents:Vector.<Vector3D>;
      
      public var extra:Object;
      
      public function Object3D()
      {
         super();
         this._transformComponents = new Vector.<Vector3D>(3,true);
         this._transformComponents[0] = this._pos;
         this._transformComponents[1] = this._rot;
         this._transformComponents[2] = this._sca;
         this._transform.identity();
         this._flipY.appendScale(1,-1,1);
      }
      
      private function invalidatePivot() : void
      {
         this._pivotZero = this._pivotPoint.x == 0 && this._pivotPoint.y == 0 && this._pivotPoint.z == 0;
         this.invalidateTransform();
      }
      
      private function invalidatePosition() : void
      {
         if(this._positionDirty)
         {
            return;
         }
         this._positionDirty = true;
         this.invalidateTransform();
         if(this._listenToPositionChanged)
         {
            this.notifyPositionChanged();
         }
      }
      
      private function notifyPositionChanged() : void
      {
         if(!this._positionChanged)
         {
            this._positionChanged = new Object3DEvent(Object3DEvent.POSITION_CHANGED,this);
         }
         dispatchEvent(this._positionChanged);
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
         switch(param1)
         {
            case Object3DEvent.POSITION_CHANGED:
               this._listenToPositionChanged = true;
               break;
            case Object3DEvent.ROTATION_CHANGED:
               this._listenToRotationChanged = true;
               break;
            case Object3DEvent.SCALE_CHANGED:
               this._listenToRotationChanged = true;
         }
      }
      
      override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         super.removeEventListener(param1,param2,param3);
         if(hasEventListener(param1))
         {
            return;
         }
         switch(param1)
         {
            case Object3DEvent.POSITION_CHANGED:
               this._listenToPositionChanged = false;
               break;
            case Object3DEvent.ROTATION_CHANGED:
               this._listenToRotationChanged = false;
               break;
            case Object3DEvent.SCALE_CHANGED:
               this._listenToScaleChanged = false;
         }
      }
      
      private function invalidateRotation() : void
      {
         if(this._rotationDirty)
         {
            return;
         }
         this._rotationDirty = true;
         this.invalidateTransform();
         if(this._listenToRotationChanged)
         {
            this.notifyRotationChanged();
         }
      }
      
      private function notifyRotationChanged() : void
      {
         if(!this._rotationChanged)
         {
            this._rotationChanged = new Object3DEvent(Object3DEvent.ROTATION_CHANGED,this);
         }
         dispatchEvent(this._rotationChanged);
      }
      
      private function invalidateScale() : void
      {
         if(this._scaleDirty)
         {
            return;
         }
         this._scaleDirty = true;
         this.invalidateTransform();
         if(this._listenToScaleChanged)
         {
            this.notifyScaleChanged();
         }
      }
      
      private function notifyScaleChanged() : void
      {
         if(!this._scaleChanged)
         {
            this._scaleChanged = new Object3DEvent(Object3DEvent.SCALE_CHANGED,this);
         }
         dispatchEvent(this._scaleChanged);
      }
      
      public function get x() : Number
      {
         return this._x;
      }
      
      public function set x(param1:Number) : void
      {
         if(this._x == param1)
         {
            return;
         }
         this._x = param1;
         this.invalidatePosition();
      }
      
      public function get y() : Number
      {
         return this._y;
      }
      
      public function set y(param1:Number) : void
      {
         if(this._y == param1)
         {
            return;
         }
         this._y = param1;
         this.invalidatePosition();
      }
      
      public function get z() : Number
      {
         return this._z;
      }
      
      public function set z(param1:Number) : void
      {
         if(this._z == param1)
         {
            return;
         }
         this._z = param1;
         this.invalidatePosition();
      }
      
      public function get rotationX() : Number
      {
         return this._rotationX * MathConsts.RADIANS_TO_DEGREES;
      }
      
      public function set rotationX(param1:Number) : void
      {
         if(this.rotationX == param1)
         {
            return;
         }
         this._rotationX = param1 * MathConsts.DEGREES_TO_RADIANS;
         this.invalidateRotation();
      }
      
      public function get rotationY() : Number
      {
         return this._rotationY * MathConsts.RADIANS_TO_DEGREES;
      }
      
      public function set rotationY(param1:Number) : void
      {
         if(this.rotationY == param1)
         {
            return;
         }
         this._rotationY = param1 * MathConsts.DEGREES_TO_RADIANS;
         this.invalidateRotation();
      }
      
      public function get rotationZ() : Number
      {
         return this._rotationZ * MathConsts.RADIANS_TO_DEGREES;
      }
      
      public function set rotationZ(param1:Number) : void
      {
         if(this.rotationZ == param1)
         {
            return;
         }
         this._rotationZ = param1 * MathConsts.DEGREES_TO_RADIANS;
         this.invalidateRotation();
      }
      
      public function get scaleX() : Number
      {
         return this._scaleX;
      }
      
      public function set scaleX(param1:Number) : void
      {
         if(this._scaleX == param1)
         {
            return;
         }
         this._scaleX = param1;
         this.invalidateScale();
      }
      
      public function get scaleY() : Number
      {
         return this._scaleY;
      }
      
      public function set scaleY(param1:Number) : void
      {
         if(this._scaleY == param1)
         {
            return;
         }
         this._scaleY = param1;
         this.invalidateScale();
      }
      
      public function get scaleZ() : Number
      {
         return this._scaleZ;
      }
      
      public function set scaleZ(param1:Number) : void
      {
         if(this._scaleZ == param1)
         {
            return;
         }
         this._scaleZ = param1;
         this.invalidateScale();
      }
      
      public function get eulers() : Vector3D
      {
         this._eulers.x = this._rotationX * MathConsts.RADIANS_TO_DEGREES;
         this._eulers.y = this._rotationY * MathConsts.RADIANS_TO_DEGREES;
         this._eulers.z = this._rotationZ * MathConsts.RADIANS_TO_DEGREES;
         return this._eulers;
      }
      
      public function set eulers(param1:Vector3D) : void
      {
         this._rotationX = param1.x * MathConsts.DEGREES_TO_RADIANS;
         this._rotationY = param1.y * MathConsts.DEGREES_TO_RADIANS;
         this._rotationZ = param1.z * MathConsts.DEGREES_TO_RADIANS;
         this.invalidateRotation();
      }
      
      public function get transform() : Matrix3D
      {
         if(this._transformDirty)
         {
            this.updateTransform();
         }
         return this._transform;
      }
      
      public function set transform(param1:Matrix3D) : void
      {
         var _loc4_:Vector3D = null;
         var _loc2_:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
         param1.copyRawDataTo(_loc2_);
         if(!_loc2_[uint(0)])
         {
            _loc2_[uint(0)] = this._smallestNumber;
            param1.copyRawDataFrom(_loc2_);
         }
         var _loc3_:Vector.<Vector3D> = Matrix3DUtils.decompose(param1);
         _loc4_ = _loc3_[0];
         if(this._x != _loc4_.x || this._y != _loc4_.y || this._z != _loc4_.z)
         {
            this._x = _loc4_.x;
            this._y = _loc4_.y;
            this._z = _loc4_.z;
            this.invalidatePosition();
         }
         _loc4_ = _loc3_[1];
         if(this._rotationX != _loc4_.x || this._rotationY != _loc4_.y || this._rotationZ != _loc4_.z)
         {
            this._rotationX = _loc4_.x;
            this._rotationY = _loc4_.y;
            this._rotationZ = _loc4_.z;
            this.invalidateRotation();
         }
         _loc4_ = _loc3_[2];
         if(this._scaleX != _loc4_.x || this._scaleY != _loc4_.y || this._scaleZ != _loc4_.z)
         {
            this._scaleX = _loc4_.x;
            this._scaleY = _loc4_.y;
            this._scaleZ = _loc4_.z;
            this.invalidateScale();
         }
      }
      
      public function get pivotPoint() : Vector3D
      {
         return this._pivotPoint;
      }
      
      public function set pivotPoint(param1:Vector3D) : void
      {
         if(!this._pivotPoint)
         {
            this._pivotPoint = new Vector3D();
         }
         this._pivotPoint.x = param1.x;
         this._pivotPoint.y = param1.y;
         this._pivotPoint.z = param1.z;
         this.invalidatePivot();
      }
      
      public function get position() : Vector3D
      {
         this.transform.copyColumnTo(3,this._pos);
         return this._pos.clone();
      }
      
      public function set position(param1:Vector3D) : void
      {
         this._x = param1.x;
         this._y = param1.y;
         this._z = param1.z;
         this.invalidatePosition();
      }
      
      public function getPosition(param1:Vector3D = null) : Vector3D
      {
         if(!param1)
         {
            param1 = new Vector3D();
         }
         this.transform.copyColumnTo(3,param1);
         return param1;
      }
      
      public function get forwardVector() : Vector3D
      {
         return Matrix3DUtils.getForward(this.transform);
      }
      
      public function get rightVector() : Vector3D
      {
         return Matrix3DUtils.getRight(this.transform);
      }
      
      public function get upVector() : Vector3D
      {
         return Matrix3DUtils.getUp(this.transform);
      }
      
      public function get backVector() : Vector3D
      {
         var _loc1_:Vector3D = Matrix3DUtils.getForward(this.transform);
         _loc1_.negate();
         return _loc1_;
      }
      
      public function get leftVector() : Vector3D
      {
         var _loc1_:Vector3D = Matrix3DUtils.getRight(this.transform);
         _loc1_.negate();
         return _loc1_;
      }
      
      public function get downVector() : Vector3D
      {
         var _loc1_:Vector3D = Matrix3DUtils.getUp(this.transform);
         _loc1_.negate();
         return _loc1_;
      }
      
      public function scale(param1:Number) : void
      {
         this._scaleX *= param1;
         this._scaleY *= param1;
         this._scaleZ *= param1;
         this.invalidateScale();
      }
      
      public function moveForward(param1:Number) : void
      {
         this.translateLocal(Vector3D.Z_AXIS,param1);
      }
      
      public function moveBackward(param1:Number) : void
      {
         this.translateLocal(Vector3D.Z_AXIS,-param1);
      }
      
      public function moveLeft(param1:Number) : void
      {
         this.translateLocal(Vector3D.X_AXIS,-param1);
      }
      
      public function moveRight(param1:Number) : void
      {
         this.translateLocal(Vector3D.X_AXIS,param1);
      }
      
      public function moveUp(param1:Number) : void
      {
         this.translateLocal(Vector3D.Y_AXIS,param1);
      }
      
      public function moveDown(param1:Number) : void
      {
         this.translateLocal(Vector3D.Y_AXIS,-param1);
      }
      
      public function moveTo(param1:Number, param2:Number, param3:Number) : void
      {
         if(this._x == param1 && this._y == param2 && this._z == param3)
         {
            return;
         }
         this._x = param1;
         this._y = param2;
         this._z = param3;
         this.invalidatePosition();
      }
      
      public function movePivot(param1:Number, param2:Number, param3:Number) : void
      {
         if(!this._pivotPoint)
         {
            this._pivotPoint = new Vector3D();
         }
         this._pivotPoint.x += param1;
         this._pivotPoint.y += param2;
         this._pivotPoint.z += param3;
         this.invalidatePivot();
      }
      
      public function translate(param1:Vector3D, param2:Number) : void
      {
         var _loc3_:Number = param1.x;
         var _loc4_:Number = param1.y;
         var _loc5_:Number = param1.z;
         var _loc6_:Number = param2 / Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_ + _loc5_ * _loc5_);
         this._x += _loc3_ * _loc6_;
         this._y += _loc4_ * _loc6_;
         this._z += _loc5_ * _loc6_;
         this.invalidatePosition();
      }
      
      public function translateLocal(param1:Vector3D, param2:Number) : void
      {
         var _loc3_:Number = param1.x;
         var _loc4_:Number = param1.y;
         var _loc5_:Number = param1.z;
         var _loc6_:Number = param2 / Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_ + _loc5_ * _loc5_);
         this.transform.prependTranslation(_loc3_ * _loc6_,_loc4_ * _loc6_,_loc5_ * _loc6_);
         this._transform.copyColumnTo(3,this._pos);
         this._x = this._pos.x;
         this._y = this._pos.y;
         this._z = this._pos.z;
         this.invalidatePosition();
      }
      
      public function pitch(param1:Number) : void
      {
         this.rotate(Vector3D.X_AXIS,param1);
      }
      
      public function yaw(param1:Number) : void
      {
         this.rotate(Vector3D.Y_AXIS,param1);
      }
      
      public function roll(param1:Number) : void
      {
         this.rotate(Vector3D.Z_AXIS,param1);
      }
      
      public function clone() : Object3D
      {
         var _loc1_:Object3D = new Object3D();
         _loc1_.pivotPoint = this.pivotPoint;
         _loc1_.transform = this.transform;
         _loc1_.name = name;
         return _loc1_;
      }
      
      public function rotateTo(param1:Number, param2:Number, param3:Number) : void
      {
         this._rotationX = param1 * MathConsts.DEGREES_TO_RADIANS;
         this._rotationY = param2 * MathConsts.DEGREES_TO_RADIANS;
         this._rotationZ = param3 * MathConsts.DEGREES_TO_RADIANS;
         this.invalidateRotation();
      }
      
      public function rotate(param1:Vector3D, param2:Number) : void
      {
         var _loc3_:Matrix3D = new Matrix3D();
         _loc3_.prependRotation(param2,param1);
         var _loc4_:Vector3D = _loc3_.decompose()[1];
         this._rotationX += _loc4_.x;
         this._rotationY += _loc4_.y;
         this._rotationZ += _loc4_.z;
         this.invalidateRotation();
      }
      
      public function lookAt(param1:Vector3D, param2:Vector3D = null) : void
      {
         var _loc6_:Vector.<Number> = null;
         if(!tempAxeX)
         {
            tempAxeX = new Vector3D();
         }
         if(!tempAxeY)
         {
            tempAxeY = new Vector3D();
         }
         if(!tempAxeZ)
         {
            tempAxeZ = new Vector3D();
         }
         var _loc3_:Vector3D = tempAxeX;
         var _loc4_:Vector3D = tempAxeY;
         var _loc5_:Vector3D = tempAxeZ;
         param2 ||= Vector3D.Y_AXIS;
         if(this._transformDirty)
         {
            this.updateTransform();
         }
         _loc5_.x = param1.x - this._x;
         _loc5_.y = param1.y - this._y;
         _loc5_.z = param1.z - this._z;
         _loc5_.normalize();
         _loc3_.x = param2.y * _loc5_.z - param2.z * _loc5_.y;
         _loc3_.y = param2.z * _loc5_.x - param2.x * _loc5_.z;
         _loc3_.z = param2.x * _loc5_.y - param2.y * _loc5_.x;
         _loc3_.normalize();
         if(_loc3_.length < 0.05)
         {
            _loc3_.x = param2.y;
            _loc3_.y = param2.x;
            _loc3_.z = 0;
            _loc3_.normalize();
         }
         _loc4_.x = _loc5_.y * _loc3_.z - _loc5_.z * _loc3_.y;
         _loc4_.y = _loc5_.z * _loc3_.x - _loc5_.x * _loc3_.z;
         _loc4_.z = _loc5_.x * _loc3_.y - _loc5_.y * _loc3_.x;
         _loc6_ = Matrix3DUtils.RAW_DATA_CONTAINER;
         _loc6_[uint(0)] = this._scaleX * _loc3_.x;
         _loc6_[uint(1)] = this._scaleX * _loc3_.y;
         _loc6_[uint(2)] = this._scaleX * _loc3_.z;
         _loc6_[uint(3)] = 0;
         _loc6_[uint(4)] = this._scaleY * _loc4_.x;
         _loc6_[uint(5)] = this._scaleY * _loc4_.y;
         _loc6_[uint(6)] = this._scaleY * _loc4_.z;
         _loc6_[uint(7)] = 0;
         _loc6_[uint(8)] = this._scaleZ * _loc5_.x;
         _loc6_[uint(9)] = this._scaleZ * _loc5_.y;
         _loc6_[uint(10)] = this._scaleZ * _loc5_.z;
         _loc6_[uint(11)] = 0;
         _loc6_[uint(12)] = this._x;
         _loc6_[uint(13)] = this._y;
         _loc6_[uint(14)] = this._z;
         _loc6_[uint(15)] = 1;
         this._transform.copyRawDataFrom(_loc6_);
         this.transform = this.transform;
         if(_loc5_.z < 0)
         {
            this.rotationY = 180 - this.rotationY;
            this.rotationX -= 180;
            this.rotationZ -= 180;
         }
      }
      
      public function dispose() : void
      {
      }
      
      public function disposeAsset() : void
      {
         this.dispose();
      }
      
      arcane function invalidateTransform() : void
      {
         this._transformDirty = true;
      }
      
      protected function updateTransform() : void
      {
         this._pos.x = this._x;
         this._pos.y = this._y;
         this._pos.z = this._z;
         this._rot.x = this._rotationX;
         this._rot.y = this._rotationY;
         this._rot.z = this._rotationZ;
         if(!this._pivotZero)
         {
            this._sca.x = 1;
            this._sca.y = 1;
            this._sca.z = 1;
            this._transform.recompose(this._transformComponents);
            this._transform.appendTranslation(this._pivotPoint.x,this._pivotPoint.y,this._pivotPoint.z);
            this._transform.prependTranslation(-this._pivotPoint.x,-this._pivotPoint.y,-this._pivotPoint.z);
            this._transform.prependScale(this._scaleX,this._scaleY,this._scaleZ);
            this._sca.x = this._scaleX;
            this._sca.y = this._scaleY;
            this._sca.z = this._scaleZ;
         }
         else
         {
            this._sca.x = this._scaleX;
            this._sca.y = this._scaleY;
            this._sca.z = this._scaleZ;
            this._transform.recompose(this._transformComponents);
         }
         this._transformDirty = false;
         this._positionDirty = false;
         this._rotationDirty = false;
         this._scaleDirty = false;
      }
      
      public function get zOffset() : int
      {
         return this._zOffset;
      }
      
      public function set zOffset(param1:int) : void
      {
         this._zOffset = param1;
      }
   }
}

