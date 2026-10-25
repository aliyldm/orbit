package away3d.bounds
{
   import away3d.core.base.Geometry;
   import away3d.core.math.Plane3D;
   import away3d.core.math.PlaneClassification;
   import away3d.primitives.WireframePrimitiveBase;
   import away3d.primitives.WireframeSphere;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   
   public class NullBounds extends BoundingVolumeBase
   {
      
      private var _alwaysIn:Boolean;
      
      private var _renderable:WireframePrimitiveBase;
      
      public function NullBounds(param1:Boolean = true, param2:WireframePrimitiveBase = null)
      {
         super();
         this._alwaysIn = param1;
         this._renderable = param2;
         _max.x = _max.y = _max.z = Number.POSITIVE_INFINITY;
         _min.x = _min.y = _min.z = this._alwaysIn ? Number.NEGATIVE_INFINITY : Number.POSITIVE_INFINITY;
      }
      
      override public function clone() : BoundingVolumeBase
      {
         return new NullBounds(this._alwaysIn);
      }
      
      override protected function createBoundingRenderable() : WireframePrimitiveBase
      {
         return this._renderable || new WireframeSphere(100,16,12,16777215,0.5);
      }
      
      override public function isInFrustum(param1:Vector.<Plane3D>, param2:int) : Boolean
      {
         param1 = param1;
         param2 = param2;
         return this._alwaysIn;
      }
      
      override public function fromGeometry(param1:Geometry) : void
      {
      }
      
      override public function fromSphere(param1:Vector3D, param2:Number) : void
      {
      }
      
      override public function fromExtremes(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
      }
      
      override public function classifyToPlane(param1:Plane3D) : int
      {
         param1 = param1;
         return PlaneClassification.INTERSECT;
      }
      
      override public function transformFrom(param1:BoundingVolumeBase, param2:Matrix3D) : void
      {
         param2 = param2;
         this._alwaysIn = NullBounds(param1)._alwaysIn;
      }
   }
}

