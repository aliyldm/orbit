package net.bigpoint.darkorbit.net.netty.handlers.camera
{
   import net.bigpoint.darkorbit.com.module.CameraLockToHeroCommand;
   import net.bigpoint.darkorbit.net.UserInterfaceAssembly;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class CameraLockToHeroHandler extends BaseHandler
   {
      
      public function CameraLockToHeroHandler()
      {
         super();
      }
      
      public static function run(param1:CameraLockToHeroCommand) : void
      {
         UserInterfaceAssembly.getInstance().moveCameraToHero();
      }
   }
}

