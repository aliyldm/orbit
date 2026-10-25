package net.bigpoint.darkorbit.net.netty.handlers.battlestations
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.BattleStationNoClanUiInitializationCommand;
   import net.bigpoint.darkorbit.mvc.battleStation.BattleStationViewNotifications;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class BattleStationNoClanUiInitializationHandler extends BaseHandler
   {
      
      public function BattleStationNoClanUiInitializationHandler()
      {
         super();
      }
      
      public static function run(param1:BattleStationNoClanUiInitializationCommand) : void
      {
         Hero.clanTag = "";
         BaseHandler._facade.sendNotification(BattleStationViewNotifications.OPEN_BUILDING_UI_BUBBLE,param1.mapAssetId);
      }
   }
}

