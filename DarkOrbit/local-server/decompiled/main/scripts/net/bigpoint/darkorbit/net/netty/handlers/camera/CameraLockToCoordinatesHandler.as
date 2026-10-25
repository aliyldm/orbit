package net.bigpoint.darkorbit.net.netty.handlers.camera
{
   import net.bigpoint.darkorbit.com.module.CameraLockToCoordinatesCommand;
   import net.bigpoint.darkorbit.net.UserInterfaceAssembly;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class CameraLockToCoordinatesHandler extends BaseHandler
   {
      
      public function CameraLockToCoordinatesHandler()
      {
         super();
      }
      
      public static function run(param1:CameraLockToCoordinatesCommand) : void
      {
         UserInterfaceAssembly.getInstance().moveCameraToCoordinates(param1.x,param1.y,param1.duration);
      }
   }
}

