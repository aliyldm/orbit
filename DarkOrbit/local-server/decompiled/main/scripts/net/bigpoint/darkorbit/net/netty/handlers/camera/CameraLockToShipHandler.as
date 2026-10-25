package net.bigpoint.darkorbit.net.netty.handlers.camera
{
   import net.bigpoint.darkorbit.com.module.CameraLockToShipCommand;
   import net.bigpoint.darkorbit.net.UserInterfaceAssembly;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class CameraLockToShipHandler extends BaseHandler
   {
      
      public function CameraLockToShipHandler()
      {
         super();
      }
      
      public static function run(param1:CameraLockToShipCommand) : void
      {
         UserInterfaceAssembly.getInstance().moveCameraToShip(param1.lockedShipUserID,param1.zoomFactor,param1.duration);
      }
   }
}

