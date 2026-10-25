package net.bigpoint.darkorbit.mvc.sectorControl.map
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.com.module.SectorControlMatchOverviewRequest;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.clickIcon.ClickIconTrait;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.proxy.SectorControlProxy;
   
   public class SectorControlEnterPoint extends MapEntity
   {
      
      public function SectorControlEnterPoint(param1:AssetCreateCommand)
      {
         super(param1.assetId,new PointLite(param1.posX,param1.posY));
         UberAssetsLib.instance.fillTraits(this,"sectorControlEnter",UberAssetsLib.LIB_DEFAULT,param1.showBubble ? this.handleIconClick : null);
         var _loc2_:ClickIconTrait = getFirstTrait(ClickIconTrait) as ClickIconTrait;
         if(_loc2_)
         {
            _loc2_.disabledSignal.add(this.handleIconDisabled);
         }
      }
      
      private function handleIconClick() : void
      {
         var _loc1_:SectorControlProxy = GameFacade.getInstance().retrieveProxy(SectorControlProxy.NAME) as SectorControlProxy;
         _loc1_.openLobbyWindowOnNextResponse = true;
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new SectorControlMatchOverviewRequest());
      }
      
      private function handleIconDisabled() : void
      {
         GameFacade.getInstance().sendNotification(GuiNotifications.CLOSE_WINDOW_BY_TYPE,FlexWindowManager.SECTORCONTROL_LOBBY_WINDOW);
      }
   }
}

