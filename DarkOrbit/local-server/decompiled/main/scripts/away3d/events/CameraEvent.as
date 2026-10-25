package away3d.events
{
   import away3d.cameras.Camera3D;
   import flash.events.Event;
   
   public class CameraEvent extends Event
   {
      
      public static const LENS_CHANGED:String = "lensChanged";
      
      private var _camera:Camera3D;
      
      public function CameraEvent(param1:String, param2:Camera3D, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._camera = param2;
      }
      
      public function get camera() : Camera3D
      {
         return this._camera;
      }
      
      override public function clone() : Event
      {
         return new CameraEvent(type,this._camera,bubbles,cancelable);
      }
   }
}

