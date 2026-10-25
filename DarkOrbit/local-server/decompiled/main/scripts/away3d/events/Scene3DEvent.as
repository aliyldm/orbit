package away3d.events
{
   import away3d.containers.ObjectContainer3D;
   import flash.events.Event;
   
   public class Scene3DEvent extends Event
   {
      
      public static const ADDED_TO_SCENE:String = "addedToScene";
      
      public static const REMOVED_FROM_SCENE:String = "removedFromScene";
      
      public static const PARTITION_CHANGED:String = "partitionChanged";
      
      public var objectContainer3D:ObjectContainer3D;
      
      public function Scene3DEvent(param1:String, param2:ObjectContainer3D)
      {
         this.objectContainer3D = param2;
         super(param1);
      }
      
      override public function get target() : Object
      {
         return this.objectContainer3D;
      }
      
      override public function clone() : Event
      {
         return new Scene3DEvent(type,this.objectContainer3D);
      }
   }
}

