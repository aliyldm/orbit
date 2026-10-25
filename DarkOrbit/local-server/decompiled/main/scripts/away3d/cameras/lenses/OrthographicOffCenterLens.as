package away3d.cameras.lenses
{
   import away3d.core.math.Matrix3DUtils;
   import flash.geom.Vector3D;
   
   public class OrthographicOffCenterLens extends LensBase
   {
      
      private var _minX:Number;
      
      private var _maxX:Number;
      
      private var _minY:Number;
      
      private var _maxY:Number;
      
      public function OrthographicOffCenterLens(param1:Number, param2:Number, param3:Number, param4:Number)
      {
         super();
         this._minX = param1;
         this._maxX = param2;
         this._minY = param3;
         this._maxY = param4;
      }
      
      public function get minX() : Number
      {
         return this._minX;
      }
      
      public function set minX(param1:Number) : void
      {
         this._minX = param1;
         invalidateMatrix();
      }
      
      public function get maxX() : Number
      {
         return this._maxX;
      }
      
      public function set maxX(param1:Number) : void
      {
         this._maxX = param1;
         invalidateMatrix();
      }
      
      public function get minY() : Number
      {
         return this._minY;
      }
      
      public function set minY(param1:Number) : void
      {
         this._minY = param1;
         invalidateMatrix();
      }
      
      public function get maxY() : Number
      {
         return this._maxY;
      }
      
      public function set maxY(param1:Number) : void
      {
         this._maxY = param1;
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
         Matrix3DUtils.transformVector(unprojectionMatrix,param4,param4);
         param4.z = param3;
         return param4;
      }
      
      override public function clone() : LensBase
      {
         var _loc1_:OrthographicOffCenterLens = new OrthographicOffCenterLens(this._minX,this._maxX,this._minY,this._maxY);
         _loc1_._near = _near;
         _loc1_._far = _far;
         _loc1_._aspectRatio = _aspectRatio;
         return _loc1_;
      }
      
      override protected function updateMatrix() : void
      {
         var _loc1_:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
         var _loc2_:Number = 1 / (this._maxX - this._minX);
         var _loc3_:Number = 1 / (this._maxY - this._minY);
         var _loc4_:Number = 1 / (_far - _near);
         _loc1_[0] = 2 * _loc2_;
         _loc1_[5] = 2 * _loc3_;
         _loc1_[10] = _loc4_;
         _loc1_[12] = -(this._maxX + this._minX) * _loc2_;
         _loc1_[13] = -(this._maxY + this._minY) * _loc3_;
         _loc1_[14] = -_near * _loc4_;
         _loc1_[15] = 1;
         _loc1_[1] = _loc1_[2] = _loc1_[3] = _loc1_[4] = _loc1_[6] = _loc1_[7] = _loc1_[8] = _loc1_[9] = _loc1_[11] = 0;
         _matrix.copyRawDataFrom(_loc1_);
         _frustumCorners[0] = _frustumCorners[9] = _frustumCorners[12] = _frustumCorners[21] = this._minX;
         _frustumCorners[3] = _frustumCorners[6] = _frustumCorners[15] = _frustumCorners[18] = this._maxX;
         _frustumCorners[1] = _frustumCorners[4] = _frustumCorners[13] = _frustumCorners[16] = this._minY;
         _frustumCorners[7] = _frustumCorners[10] = _frustumCorners[19] = _frustumCorners[22] = this._maxY;
         _frustumCorners[2] = _frustumCorners[5] = _frustumCorners[8] = _frustumCorners[11] = _near;
         _frustumCorners[14] = _frustumCorners[17] = _frustumCorners[20] = _frustumCorners[23] = _far;
         _matrixInvalid = false;
      }
   }
}

