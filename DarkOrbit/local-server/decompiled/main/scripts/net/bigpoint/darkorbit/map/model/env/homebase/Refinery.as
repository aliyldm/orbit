package net.bigpoint.darkorbit.map.model.env.homebase
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.com.module.AssetTypeModule;
   import net.bigpoint.darkorbit.com.module.TradeRequest;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.ConnectionProxy;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class Refinery extends MapEntity
   {
      
      private static const ASSET_TYPE_2_PATTERN_ID:Object = {};
      
      ASSET_TYPE_2_PATTERN_ID[AssetTypeModule.ASSETTYPE_ORE_TRADE_HOME] = "refinery_home";
      ASSET_TYPE_2_PATTERN_ID[AssetTypeModule.ASSETTYPE_ORE_TRADE_OUTPOST] = "refinery_outpost";
      ASSET_TYPE_2_PATTERN_ID[AssetTypeModule.ASSETTYPE_ORE_TRADE_INVISIBLE] = "refinery_invisible";
      
      public function Refinery(param1:AssetCreateCommand)
      {
         super(param1.assetId,new PointLite(param1.posX,param1.posY));
         UberAssetsLib.instance.fillTraits(this,ASSET_TYPE_2_PATTERN_ID[param1.type.typeValue] + "_" + param1.factionId,UberAssetsLib.LIB_DEFAULT,param1.showBubble ? this.handleIconClick : null);
      }
      
      private function handleIconClick() : void
      {
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_BUBBLE_CLICKED_REFINERY);
         var _loc1_:ConnectionProxy = GameFacade.getInstance().retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy;
         _loc1_.sendNettyRequest(new TradeRequest());
      }
   }
}

