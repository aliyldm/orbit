package away3d.cameras.lenses
{
   import away3d.core.math.Matrix3DUtils;
   import flash.geom.Vector3D;
   
   public class OrthographicLens extends LensBase
   {
      
      private var _projectionHeight:Number;
      
      private var _xMax:Number;
      
      private var _yMax:Number;
      
      public function OrthographicLens(param1:Number = 500)
      {
         super();
         this._projectionHeight = param1;
      }
      
      public function get projectionHeight() : Number
      {
         return this._projectionHeight;
      }
      
      public function set projectionHeight(param1:Number) : void
      {
         if(param1 == this._projectionHeight)
         {
            return;
         }
         this._projectionHeight = param1;
         invalidateMatrix();
      }
      
      override public function unproject(param1:Number, param2:Number, param3:Number, param4:Vector3D = null) : Vector3D
      {
         if(!param4)
         {
            param4 = new Vector3D();
         }
         var _loc5_:Vector3D = Matrix3DUtils.CALCULATION_VECTOR3D;
         matrix.copyColumnTo(3,_loc5_);
         param4.x = param1 + _loc5_.x;
         param4.y = param1 + _loc5_.y;
         param4.z = param3;
         param4.w = 1;
         Matrix3DUtils.transformVector(unprojectionMatrix,param4,param4);
         param4.z = param3;
         return param4;
      }
      
      override public function clone() : LensBase
      {
         var _loc1_:OrthographicLens = new OrthographicLens();
         _loc1_._near = _near;
         _loc1_._far = _far;
         _loc1_._aspectRatio = _aspectRatio;
         _loc1_.projectionHeight = this._projectionHeight;
         return _loc1_;
      }
      
      override protected function updateMatrix() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc1_:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
         this._yMax = this._projectionHeight * 0.5;
         this._xMax = this._yMax * _aspectRatio;
         if(_scissorRect.x == 0 && _scissorRect.y == 0 && _scissorRect.width == _viewPort.width && _scissorRect.height == _viewPort.height)
         {
            _loc2_ = -this._xMax;
            _loc3_ = this._xMax;
            _loc4_ = -this._yMax;
            _loc5_ = this._yMax;
            _loc1_[uint(0)] = 2 / (this._projectionHeight * _aspectRatio);
            _loc1_[uint(5)] = 2 / this._projectionHeight;
            _loc1_[uint(10)] = 1 / (_far - _near);
            _loc1_[uint(14)] = _near / (_near - _far);
            _loc1_[uint(1)] = _loc1_[uint(2)] = _loc1_[uint(3)] = _loc1_[uint(4)] = _loc1_[uint(6)] = _loc1_[uint(7)] = _loc1_[uint(8)] = _loc1_[uint(9)] = _loc1_[uint(11)] = _loc1_[uint(12)] = _loc1_[uint(13)] = 0;
            _loc1_[uint(15)] = 1;
         }
         else
         {
            _loc6_ = this._xMax * (_viewPort.width / _scissorRect.width);
            _loc7_ = this._yMax * (_viewPort.height / _scissorRect.height);
            _loc8_ = this._xMax * (_scissorRect.x * 2 - _viewPort.width) / _scissorRect.width + this._xMax;
            _loc9_ = -this._yMax * (_scissorRect.y * 2 - _viewPort.height) / _scissorRect.height - this._yMax;
            _loc2_ = _loc8_ - _loc6_;
            _loc3_ = _loc8_ + _loc6_;
            _loc4_ = _loc9_ - _loc7_;
            _loc5_ = _loc9_ + _loc7_;
            _loc1_[uint(0)] = 2 * 1 / (_loc3_ - _loc2_);
            _loc1_[uint(5)] = -2 * 1 / (_loc4_ - _loc5_);
            _loc1_[uint(10)] = 1 / (_far - _near);
            _loc1_[uint(12)] = (_loc3_ + _loc2_) / (_loc3_ - _loc2_);
            _loc1_[uint(13)] = (_loc5_ + _loc4_) / (_loc5_ - _loc4_);
            _loc1_[uint(14)] = _near / (near - far);
            _loc1_[uint(1)] = _loc1_[uint(2)] = _loc1_[uint(3)] = _loc1_[uint(4)] = _loc1_[uint(6)] = _loc1_[uint(7)] = _loc1_[uint(8)] = _loc1_[uint(9)] = _loc1_[uint(11)] = 0;
            _loc1_[uint(15)] = 1;
         }
         _frustumCorners[0] = _frustumCorners[9] = _frustumCorners[12] = _frustumCorners[21] = _loc2_;
         _frustumCorners[3] = _frustumCorners[6] = _frustumCorners[15] = _frustumCorners[18] = _loc3_;
         _frustumCorners[1] = _frustumCorners[4] = _frustumCorners[13] = _frustumCorners[16] = _loc4_;
         _frustumCorners[7] = _frustumCorners[10] = _frustumCorners[19] = _frustumCorners[22] = _loc5_;
         _frustumCorners[2] = _frustumCorners[5] = _frustumCorners[8] = _frustumCorners[11] = _near;
         _frustumCorners[14] = _frustumCorners[17] = _frustumCorners[20] = _frustumCorners[23] = _far;
         _matrix.copyRawDataFrom(_loc1_);
         _matrixInvalid = false;
      }
   }
}

