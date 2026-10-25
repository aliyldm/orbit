package net.bigpoint.darkorbit.mvc.gui.windows.warp.model
{
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.warp.WarpWindowNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.warp.model.vo.WarpWindowVO;
   
   public class WarpWindowProxy extends SimpleWindowProxy
   {
      
      public function WarpWindowProxy(param1:String)
      {
         var _loc2_:WarpWindowVO = new WarpWindowVO();
         super(param1,_loc2_);
         this.warpModel.changed.add(this.udpate);
      }
      
      private function get warpModel() : WarpWindowVO
      {
         return getData() as WarpWindowVO;
      }
      
      private function udpate() : void
      {
         sendNotification(WarpWindowNotifications.WARP_WINDOW_SHIPS_UPDATED,this.warpModel);
      }
   }
}

