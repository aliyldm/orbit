package away3d.events
{
   import away3d.core.base.ISubGeometry;
   import flash.events.Event;
   
   public class GeometryEvent extends Event
   {
      
      public static const SUB_GEOMETRY_ADDED:String = "SubGeometryAdded";
      
      public static const SUB_GEOMETRY_REMOVED:String = "SubGeometryRemoved";
      
      public static const BOUNDS_INVALID:String = "BoundsInvalid";
      
      private var _subGeometry:ISubGeometry;
      
      public function GeometryEvent(param1:String, param2:ISubGeometry = null)
      {
         super(param1,false,false);
         this._subGeometry = param2;
      }
      
      public function get subGeometry() : ISubGeometry
      {
         return this._subGeometry;
      }
      
      override public function clone() : Event
      {
         return new GeometryEvent(type,this._subGeometry);
      }
   }
}

