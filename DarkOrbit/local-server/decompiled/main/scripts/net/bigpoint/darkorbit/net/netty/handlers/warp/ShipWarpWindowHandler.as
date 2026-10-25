package net.bigpoint.darkorbit.net.netty.handlers.warp
{
   import net.bigpoint.darkorbit.com.module.ShipWarpWindowCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.warp.model.WarpWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.warp.model.vo.WarpWindowVO;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class ShipWarpWindowHandler extends BaseHandler
   {
      
      public function ShipWarpWindowHandler()
      {
         super();
      }
      
      public static function run(param1:ShipWarpWindowCommand) : void
      {
         var _loc2_:WarpWindowProxy = _facade.retrieveProxy(GuiConstants.SHIP_WARP_WINDOW) as WarpWindowProxy;
         if(!_loc2_)
         {
            _facade.registerProxy(_loc2_ = new WarpWindowProxy(GuiConstants.SHIP_WARP_WINDOW));
         }
         var _loc3_:WarpWindowVO = _loc2_.getData() as WarpWindowVO;
         _loc3_.isNearSpacestation = param1.isNearSpacestation;
         _loc3_.ships = param1.ships;
      }
   }
}

