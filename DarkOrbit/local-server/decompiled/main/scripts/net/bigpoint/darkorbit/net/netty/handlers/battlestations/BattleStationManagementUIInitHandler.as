package net.bigpoint.darkorbit.net.netty.handlers.battlestations
{
   import net.bigpoint.darkorbit.com.module.BattleStationManagementUiInitializationCommand;
   import net.bigpoint.darkorbit.mvc.battleStation.BattleStationViewNotifications;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.BattleStationProxy;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.MinMaxIncrementVO;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class BattleStationManagementUIInitHandler extends BaseHandler
   {
      
      public function BattleStationManagementUIInitHandler()
      {
         super();
      }
      
      public static function run(param1:BattleStationManagementUiInitializationCommand) : void
      {
         var _loc2_:BattleStationProxy = _facade.retrieveProxy(BattleStationProxy.NAME) as BattleStationProxy;
         _loc2_.connMan = _main.getConnectionManager();
         _loc2_.initPlayerModulesModel(param1.availableModules);
         _loc2_.initManagementUIModelForBattleStation(param1.state,param1.battleStationName);
         _loc2_.deflectorMinMaxIncrement = new MinMaxIncrementVO(param1.deflectorShieldMinutesMin,param1.deflectorShieldMinutesMax,param1.deflectorShieldMinutesIncrement);
         BaseHandler._facade.sendNotification(BattleStationViewNotifications.OPEN_BUILDING_UI_BUBBLE,param1.mapAssetId);
      }
   }
}

