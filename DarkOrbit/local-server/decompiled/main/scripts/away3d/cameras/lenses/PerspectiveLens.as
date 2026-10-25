package away3d.cameras.lenses
{
   import away3d.core.math.*;
   import flash.geom.*;
   
   public class PerspectiveLens extends LensBase
   {
      
      private var _fieldOfView:Number;
      
      private var _focalLength:Number;
      
      private var _focalLengthInv:Number;
      
      private var _yMax:Number;
      
      private var _xMax:Number;
      
      private var _coordinateSystem:uint;
      
      public function PerspectiveLens(param1:Number = 60, param2:uint = 0)
      {
         super();
         this.fieldOfView = param1;
         this.coordinateSystem = param2;
      }
      
      public function get fieldOfView() : Number
      {
         return this._fieldOfView;
      }
      
      public function set fieldOfView(param1:Number) : void
      {
         if(param1 == this._fieldOfView)
         {
            return;
         }
         this._fieldOfView = param1;
         this._focalLengthInv = Math.tan(this._fieldOfView * Math.PI / 360);
         this._focalLength = 1 / this._focalLengthInv;
         invalidateMatrix();
      }
      
      public function get focalLength() : Number
      {
         return this._focalLength;
      }
      
      public function set focalLength(param1:Number) : void
      {
         if(param1 == this._focalLength)
         {
            return;
         }
         this._focalLength = param1;
         this._focalLengthInv = 1 / this._focalLength;
         this._fieldOfView = Math.atan(this._focalLengthInv) * 360 / Math.PI;
         invalidateMatrix();
      }
      
      override public function unproject(param1:Number, param2:Number, param3:Number, param4:Vector3D = null) : Vector3D
      {
         if(!param4)
         {
            param4 = new Vector3D();
         }
         param4.x = param1;
         param4.y = -param2;
         param4.z = param3;
         param4.w = 1;
         param4.x *= param3;
         param4.y *= param3;
         Matrix3DUtils.transformVector(unprojectionMatrix,param4,param4);
         param4.z = param3;
         return param4;
      }
      
      override public function clone() : LensBase
      {
         var _loc1_:PerspectiveLens = new PerspectiveLens(this._fieldOfView);
         _loc1_._near = _near;
         _loc1_._far = _far;
         _loc1_._aspectRatio = _aspectRatio;
         _loc1_._coordinateSystem = this._coordinateSystem;
         return _loc1_;
      }
      
      public function get coordinateSystem() : uint
      {
         return this._coordinateSystem;
      }
      
      public function set coordinateSystem(param1:uint) : void
      {
         if(param1 == this._coordinateSystem)
         {
            return;
         }
         this._coordinateSystem = param1;
         invalidateMatrix();
      }
      
      override protected function updateMatrix() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc1_:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
         this._yMax = _near * this._focalLengthInv;
         this._xMax = this._yMax * _aspectRatio;
         if(_scissorRect.x == 0 && _scissorRect.y == 0 && _scissorRect.width == _viewPort.width && _scissorRect.height == _viewPort.height)
         {
            _loc2_ = -this._xMax;
            _loc3_ = this._xMax;
            _loc4_ = -this._yMax;
            _loc5_ = this._yMax;
            _loc1_[uint(0)] = _near / this._xMax;
            _loc1_[uint(5)] = _near / this._yMax;
            _loc1_[uint(10)] = _far / (_far - _near);
            _loc1_[uint(11)] = 1;
            _loc1_[uint(1)] = _loc1_[uint(2)] = _loc1_[uint(3)] = _loc1_[uint(4)] = _loc1_[uint(6)] = _loc1_[uint(7)] = _loc1_[uint(8)] = _loc1_[uint(9)] = _loc1_[uint(12)] = _loc1_[uint(13)] = _loc1_[uint(15)] = 0;
            _loc1_[uint(14)] = -_near * _loc1_[uint(10)];
         }
         else
         {
            _loc8_ = this._xMax * (_viewPort.width / _scissorRect.width);
            _loc9_ = this._yMax * (_viewPort.height / _scissorRect.height);
            _loc10_ = this._xMax * (_scissorRect.x * 2 - _viewPort.width) / _scissorRect.width + this._xMax;
            _loc11_ = -this._yMax * (_scissorRect.y * 2 - _viewPort.height) / _scissorRect.height - this._yMax;
            _loc2_ = _loc10_ - _loc8_;
            _loc3_ = _loc10_ + _loc8_;
            _loc4_ = _loc11_ - _loc9_;
            _loc5_ = _loc11_ + _loc9_;
            _loc1_[uint(0)] = 2 * _near / (_loc3_ - _loc2_);
            _loc1_[uint(5)] = 2 * _near / (_loc5_ - _loc4_);
            _loc1_[uint(8)] = (_loc3_ + _loc2_) / (_loc3_ - _loc2_);
            _loc1_[uint(9)] = (_loc5_ + _loc4_) / (_loc5_ - _loc4_);
            _loc1_[uint(10)] = (_far + _near) / (_far - _near);
            _loc1_[uint(11)] = 1;
            _loc1_[uint(1)] = _loc1_[uint(2)] = _loc1_[uint(3)] = _loc1_[uint(4)] = _loc1_[uint(6)] = _loc1_[uint(7)] = _loc1_[uint(12)] = _loc1_[uint(13)] = _loc1_[uint(15)] = 0;
            _loc1_[uint(14)] = -2 * _far * _near / (_far - _near);
         }
         if(this._coordinateSystem == CoordinateSystem.RIGHT_HANDED)
         {
            _loc1_[uint(5)] = -_loc1_[uint(5)];
         }
         _matrix.copyRawDataFrom(_loc1_);
         var _loc6_:Number = _far * this._focalLengthInv;
         var _loc7_:Number = _loc6_ * _aspectRatio;
         _frustumCorners[0] = _frustumCorners[9] = _loc2_;
         _frustumCorners[3] = _frustumCorners[6] = _loc3_;
         _frustumCorners[1] = _frustumCorners[4] = _loc4_;
         _frustumCorners[7] = _frustumCorners[10] = _loc5_;
         _frustumCorners[12] = _frustumCorners[21] = -_loc7_;
         _frustumCorners[15] = _frustumCorners[18] = _loc7_;
         _frustumCorners[13] = _frustumCorners[16] = -_loc6_;
         _frustumCorners[19] = _frustumCorners[22] = _loc6_;
         _frustumCorners[2] = _frustumCorners[5] = _frustumCorners[8] = _frustumCorners[11] = _near;
         _frustumCorners[14] = _frustumCorners[17] = _frustumCorners[20] = _frustumCorners[23] = _far;
         _matrixInvalid = false;
      }
   }
}

