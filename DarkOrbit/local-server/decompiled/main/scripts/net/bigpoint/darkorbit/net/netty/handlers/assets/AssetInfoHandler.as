package net.bigpoint.darkorbit.net.netty.handlers.assets
{
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.AssetInfoCommand;
   import net.bigpoint.darkorbit.com.module.AssetTypeModule;
   import net.bigpoint.darkorbit.mvc.battleStation.BattleStationViewNotifications;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.BattleStationNotification;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.MapAssetNotification;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AssetInfoHandler extends BaseHandler
   {
      
      public function AssetInfoHandler()
      {
         super();
      }
      
      public static function run(param1:IModule) : void
      {
         var _loc2_:AssetInfoCommand = param1 as AssetInfoCommand;
         switch(_loc2_.type.typeValue)
         {
            case AssetTypeModule.ASSETTYPE_ASTEROID:
               _facade.forwardNotification(BattleStationNotification.BATTLE_STATION_ASSET_CLICKED,_loc2_.assetId);
               break;
            case AssetTypeModule.ASSETTYPE_BATTLESTATION:
               _facade.forwardNotification(BattleStationViewNotifications.UPDATE_BATTLESTATION_VIEW,_loc2_);
               break;
            case AssetTypeModule.ASSETTYPE_SATELLITE:
               _facade.forwardNotification(BattleStationViewNotifications.UPDATE_BATTLESTATION_MODULE_VIEW,_loc2_);
               break;
            case AssetTypeModule.ASSETTYPE_BILLBOARD_ASTEROID:
         }
         _facade.forwardNotification(MapAssetNotification.MAP_ASSET_UPDATE_HP,[_loc2_.assetId,_loc2_.hitpoints,_loc2_.maxHitpoints]);
         if(_loc2_.shielded)
         {
            _facade.forwardNotification(MapAssetNotification.MAP_ASSET_UPDATE_SHIELD,[_loc2_.assetId,_loc2_.shieldEnergy,_loc2_.maxShieldEnergy]);
         }
      }
   }
}

