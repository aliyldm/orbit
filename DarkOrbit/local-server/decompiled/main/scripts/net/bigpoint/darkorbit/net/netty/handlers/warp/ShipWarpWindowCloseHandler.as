package net.bigpoint.darkorbit.net.netty.handlers.warp
{
   import net.bigpoint.darkorbit.com.module.ShipWarpWindowCloseCommand;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.common.model.GuiProxy;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureWindowVO;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class ShipWarpWindowCloseHandler extends BaseHandler
   {
      
      public function ShipWarpWindowCloseHandler()
      {
         super();
      }
      
      public static function run(param1:ShipWarpWindowCloseCommand) : void
      {
         var _loc2_:GameFacade = GameFacade.getInstance();
         var _loc3_:GuiProxy = _loc2_.retrieveProxy(GuiProxy.NAME) as GuiProxy;
         var _loc4_:FeatureWindowVO = _loc3_.getFeatureWindowById(GuiConstants.SHIP_WARP_WINDOW);
         _loc4_.maximized = false;
         _loc2_.sendNotification(FeaturesMenuNotifications.UPDATE_BTNS_SELECTIONS);
      }
   }
}

