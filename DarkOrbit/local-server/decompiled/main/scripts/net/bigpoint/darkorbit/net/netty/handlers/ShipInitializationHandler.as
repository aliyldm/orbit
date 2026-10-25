package net.bigpoint.darkorbit.net.netty.handlers
{
   import flash.utils.getTimer;
   import net.bigpoint.darkorbit.com.module.ShipInitializationCommand;
   import net.bigpoint.darkorbit.com.module.VisualModifierCommand;
   import net.bigpoint.darkorbit.gui.windows.components.Killscreen;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   import net.bigpoint.eventstream.EventStreamClient;
   
   public class ShipInitializationHandler extends BaseHandler
   {
      
      public function ShipInitializationHandler()
      {
         super();
      }
      
      public static function run(param1:ShipInitializationCommand) : void
      {
         var _loc7_:VisualModifierCommand = null;
         var _loc2_:uint = uint(getTimer());
         var _loc3_:Killscreen = Killscreen.getInstance();
         if(_loc3_.visibleStatus)
         {
            _loc3_.removeRepairWindow();
            _main.screenManager.mapView.restoreUserZoom(0);
         }
         var _loc4_:uint = uint(getTimer());
         _main.getConnectionManager().getShipAssembly().assembleHeroInit(param1);
         _facade.sendNotification(GuiNotifications.WARP_CONTROLS_UPDATE);
         var _loc5_:uint = uint(getTimer());
         if(param1.modifier != null)
         {
            for each(_loc7_ in param1.modifier)
            {
               VisualModifierHandler.run(_loc7_);
            }
         }
         var _loc6_:uint = uint(getTimer());
         if(_loc6_ - _loc2_ > 7000)
         {
            EventStreamClient.track("flash_debug_connection_issue",{
               "killscreenTime":_loc4_ - _loc2_,
               "heroInit":_loc5_ - _loc4_,
               "visualModifier":_loc6_ - _loc5_,
               "total":_loc6_ - _loc2_,
               "focus":ScreenManager.getInstance().hasFocus,
               "visualModifierLength":param1.modifier.length
            });
         }
      }
   }
}

