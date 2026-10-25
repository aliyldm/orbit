package away3d.lights.shadowmaps
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   
   use namespace arcane;
   
   public class NearDirectionalShadowMapper extends DirectionalShadowMapper
   {
      
      private var _coverageRatio:Number;
      
      public function NearDirectionalShadowMapper(param1:Number = 0.5)
      {
         super();
         this.coverageRatio = param1;
      }
      
      public function get coverageRatio() : Number
      {
         return this._coverageRatio;
      }
      
      public function set coverageRatio(param1:Number) : void
      {
         if(param1 > 1)
         {
            param1 = 1;
         }
         else if(param1 < 0)
         {
            param1 = 0;
         }
         this._coverageRatio = param1;
      }
      
      override protected function updateDepthProjection(param1:Camera3D) : void
      {
         var _loc4_:Number = NaN;
         var _loc2_:Vector.<Number> = param1.lens.frustumCorners;
         var _loc3_:int = 0;
         while(_loc3_ < 12)
         {
            _loc4_ = _loc2_[_loc3_];
            _localFrustum[_loc3_] = _loc4_;
            _localFrustum[uint(_loc3_ + 12)] = _loc4_ + (_loc2_[uint(_loc3_ + 12)] - _loc4_) * this._coverageRatio;
            _loc3_++;
         }
         updateProjectionFromFrustumCorners(param1,_localFrustum,_matrix);
         _overallDepthLens.matrix = _matrix;
      }
   }
}

