package net.bigpoint.darkorbit.mvc.wargame.map
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.com.module.WarGameExitRequest;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class WarGameExitPoint extends MapEntity
   {
      
      public function WarGameExitPoint(param1:AssetCreateCommand)
      {
         super(param1.assetId,new PointLite(param1.posX,param1.posY));
         UberAssetsLib.instance.fillTraits(this,"wargame_exit_" + Settings.mapID % 2,UberAssetsLib.LIB_DEFAULT,param1.showBubble ? this.openLeaveMatchDialog : null);
      }
      
      private function openLeaveMatchDialog() : void
      {
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new WarGameExitRequest());
      }
   }
}

