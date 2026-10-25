package net.bigpoint.darkorbit.mvc.tdm.map
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchOverviewInitRequest;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.clickIcon.ClickIconTrait;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   
   public class TDMEnterPoint extends MapEntity
   {
      
      public function TDMEnterPoint(param1:AssetCreateCommand)
      {
         super(param1.assetId,new PointLite(param1.posX,param1.posY));
         UberAssetsLib.instance.fillTraits(this,"tdm_enter",UberAssetsLib.LIB_DEFAULT,param1.showBubble ? this.handleIconClick : null);
         var _loc2_:ClickIconTrait = getFirstTrait(ClickIconTrait) as ClickIconTrait;
         if(_loc2_)
         {
            _loc2_.disabledSignal.add(this.handleIconDisabled);
         }
      }
      
      private function handleIconClick() : void
      {
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new TeamDeathMatchOverviewInitRequest());
      }
      
      private function handleIconDisabled() : void
      {
         GameFacade.getInstance().sendNotification(GuiNotifications.CLOSE_WINDOW_BY_TYPE,FlexWindowManager.TEAMDEATHMATCH_LOBBY_WINDOW);
      }
   }
}

