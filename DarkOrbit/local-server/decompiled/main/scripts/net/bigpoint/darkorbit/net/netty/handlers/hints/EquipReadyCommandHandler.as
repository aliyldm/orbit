package net.bigpoint.darkorbit.net.netty.handlers.hints
{
   import net.bigpoint.darkorbit.com.module.EquipReadyCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.warp.WarpWindowNotifications;
   import net.bigpoint.darkorbit.mvc.hints.HintsConstants;
   import net.bigpoint.darkorbit.mvc.hints.HintsNotifications;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class EquipReadyCommandHandler extends BaseHandler
   {
      
      public function EquipReadyCommandHandler()
      {
         super();
      }
      
      public static function run(param1:EquipReadyCommand) : void
      {
         _facade.sendNotification(HintsNotifications.INIT_HINT,param1.ready,HintsConstants.EQUIPPING_SHIPS);
         _facade.sendNotification(WarpWindowNotifications.WARP_WINDOW_MINIMIZE);
      }
   }
}

