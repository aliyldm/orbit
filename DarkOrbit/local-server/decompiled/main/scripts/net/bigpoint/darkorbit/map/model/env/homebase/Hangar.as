package net.bigpoint.darkorbit.map.model.env.homebase
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.com.module.AssetTypeModule;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionShipListRequest;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   
   public class Hangar extends MapEntity
   {
      
      private static const ASSET_TYPE_2_PATTERN_ID:Object = {};
      
      ASSET_TYPE_2_PATTERN_ID[AssetTypeModule.ASSETTYPE_HANGAR_HOME] = "hangar_home";
      ASSET_TYPE_2_PATTERN_ID[AssetTypeModule.ASSETTYPE_EXPEDITION_HOME] = "expedition_home";
      ASSET_TYPE_2_PATTERN_ID[AssetTypeModule.ASSETTYPE_HANGAR_OUTPOST] = "hangar_outpost";
      
      public function Hangar(param1:AssetCreateCommand)
      {
         super(param1.assetId,new PointLite(param1.posX,param1.posY));
         UberAssetsLib.instance.fillTraits(this,ASSET_TYPE_2_PATTERN_ID[param1.type.typeValue] + "_" + param1.factionId,UberAssetsLib.LIB_DEFAULT,param1.showBubble ? this.handleIconClick : null);
      }
      
      private function handleIconClick() : void
      {
         if(ScreenManager.getInstance().map.mapID == 473)
         {
            GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ExpeditionShipListRequest());
            return;
         }
         JavascriptProxy.referToURL(JavascriptProxy.INTERNAL_DOCK,"seo_tittle_hangar",JavascriptProxy.INTERNAL_DOCK_TEMPLATE__EQUIPMENT);
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_BUBBLE_CLICKED_HANGAR);
      }
   }
}

