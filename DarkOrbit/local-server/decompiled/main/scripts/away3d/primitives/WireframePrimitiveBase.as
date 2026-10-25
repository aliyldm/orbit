package away3d.primitives
{
   import away3d.arcane;
   import away3d.bounds.BoundingVolumeBase;
   import away3d.entities.SegmentSet;
   import away3d.errors.AbstractMethodError;
   import away3d.primitives.data.Segment;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class WireframePrimitiveBase extends SegmentSet
   {
      
      private var _geomDirty:Boolean = true;
      
      private var _color:uint;
      
      private var _thickness:Number;
      
      public function WireframePrimitiveBase(param1:uint = 16777215, param2:Number = 1)
      {
         super();
         if(param2 <= 0)
         {
            param2 = 1;
         }
         this._color = param1;
         this._thickness = param2;
         mouseEnabled = mouseChildren = false;
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set color(param1:uint) : void
      {
         var _loc2_:Object = null;
         this._color = param1;
         for each(_loc2_ in _segments)
         {
            _loc2_.segment.startColor = _loc2_.segment.endColor = param1;
         }
      }
      
      public function get thickness() : Number
      {
         return this._thickness;
      }
      
      public function set thickness(param1:Number) : void
      {
         var _loc2_:Object = null;
         this._thickness = param1;
         for each(_loc2_ in _segments)
         {
            _loc2_.segment.thickness = _loc2_.segment.thickness = param1;
         }
      }
      
      override public function removeAllSegments() : void
      {
         super.removeAllSegments();
      }
      
      override public function get bounds() : BoundingVolumeBase
      {
         if(this._geomDirty)
         {
            this.updateGeometry();
         }
         return super.bounds;
      }
      
      protected function buildGeometry() : void
      {
         throw new AbstractMethodError();
      }
      
      protected function invalidateGeometry() : void
      {
         this._geomDirty = true;
         invalidateBounds();
      }
      
      private function updateGeometry() : void
      {
         this.buildGeometry();
         this._geomDirty = false;
      }
      
      protected function updateOrAddSegment(param1:uint, param2:Vector3D, param3:Vector3D) : void
      {
         var _loc4_:Segment = null;
         var _loc5_:Vector3D = null;
         var _loc6_:Vector3D = null;
         _loc4_ = getSegment(param1);
         if(_loc4_ != null)
         {
            _loc5_ = _loc4_.start;
            _loc6_ = _loc4_.end;
            _loc5_.x = param2.x;
            _loc5_.y = param2.y;
            _loc5_.z = param2.z;
            _loc6_.x = param3.x;
            _loc6_.y = param3.y;
            _loc6_.z = param3.z;
            _loc4_.updateSegment(_loc5_,_loc6_,null,this._color,this._color,this._thickness);
         }
         else
         {
            addSegment(new away3d.primitives.LineSegment(param2.clone(),param3.clone(),this._color,this._color,this._thickness));
         }
      }
      
      override protected function updateMouseChildren() : void
      {
         _ancestorsAllowMouseEnabled = false;
      }
   }
}

