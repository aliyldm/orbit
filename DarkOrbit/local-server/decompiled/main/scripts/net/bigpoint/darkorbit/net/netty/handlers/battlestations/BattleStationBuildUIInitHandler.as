package net.bigpoint.darkorbit.net.netty.handlers.battlestations
{
   import net.bigpoint.darkorbit.com.module.BattleStationBuildingUiInitializationCommand;
   import net.bigpoint.darkorbit.mvc.battleStation.BattleStationViewNotifications;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.BattleStationProxy;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.MinMaxIncrementVO;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class BattleStationBuildUIInitHandler extends BaseHandler
   {
      
      public function BattleStationBuildUIInitHandler()
      {
         super();
      }
      
      public static function run(param1:BattleStationBuildingUiInitializationCommand) : void
      {
         var _loc2_:BattleStationProxy = _facade.retrieveProxy(BattleStationProxy.NAME) as BattleStationProxy;
         _loc2_.connMan = _main.getConnectionManager();
         _loc2_.initPlayerModulesModel(param1.availableModules);
         _loc2_.initBuildingUIModelForAsteroid(param1.mapAssetId,param1.battleStationId,param1.battleStationName,param1.progress);
         _loc2_.buildMinMaxIncrement = new MinMaxIncrementVO(param1.buildTimeInMinutesMin,param1.buildTimeInMinutesMax,param1.buildTimeInMinutesIncrement);
         _facade.sendNotification(BattleStationViewNotifications.OPEN_BUILDING_UI_BUBBLE,param1.mapAssetId);
      }
   }
}

