package away3d.cameras.lenses
{
   import away3d.arcane;
   
   use namespace arcane;
   
   public class FreeMatrixLens extends LensBase
   {
      
      public function FreeMatrixLens()
      {
         super();
         _matrix.copyFrom(new PerspectiveLens().matrix);
      }
      
      override public function set near(param1:Number) : void
      {
         _near = param1;
      }
      
      override public function set far(param1:Number) : void
      {
         _far = param1;
      }
      
      override arcane function set aspectRatio(param1:Number) : void
      {
         _aspectRatio = param1;
      }
      
      override public function clone() : LensBase
      {
         var _loc1_:FreeMatrixLens = null;
         _loc1_ = new FreeMatrixLens();
         _loc1_._matrix.copyFrom(_matrix);
         _loc1_._near = _near;
         _loc1_._far = _far;
         _loc1_._aspectRatio = _aspectRatio;
         _loc1_.invalidateMatrix();
         return _loc1_;
      }
      
      override protected function updateMatrix() : void
      {
         _matrixInvalid = false;
      }
   }
}

