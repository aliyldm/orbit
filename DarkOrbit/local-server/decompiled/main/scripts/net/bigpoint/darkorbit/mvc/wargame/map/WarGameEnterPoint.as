package net.bigpoint.darkorbit.mvc.wargame.map
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   
   public class WarGameEnterPoint extends MapEntity
   {
      
      public function WarGameEnterPoint(param1:AssetCreateCommand)
      {
         super(param1.assetId,new PointLite(param1.posX,param1.posY));
         UberAssetsLib.instance.fillTraits(this,"wargame_enter",UberAssetsLib.LIB_DEFAULT,param1.showBubble ? this.handleIconClick : null);
      }
      
      private function handleIconClick() : void
      {
         GameFacade.getInstance().sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,SimpleWindowCreationMap.getById(GuiConstants.WARGAME_LOBBY_WINDOW));
         GameFacade.getInstance().sendNotification(GuiNotifications.MAXIMIZE_WINDOW_BY_ID,GuiConstants.WARGAME_LOBBY_WINDOW);
      }
   }
}

