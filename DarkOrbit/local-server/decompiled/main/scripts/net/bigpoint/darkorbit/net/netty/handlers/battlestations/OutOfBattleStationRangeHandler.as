package net.bigpoint.darkorbit.net.netty.handlers.battlestations
{
   import net.bigpoint.darkorbit.com.module.OutOfBattleStationRangeCommand;
   import net.bigpoint.darkorbit.mvc.battleStation.BattleStationViewNotifications;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.BattleStationProxy;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class OutOfBattleStationRangeHandler extends BaseHandler
   {
      
      public function OutOfBattleStationRangeHandler()
      {
         super();
      }
      
      public static function run(param1:OutOfBattleStationRangeCommand) : void
      {
         var _loc2_:BattleStationProxy = _facade.retrieveProxy(BattleStationProxy.NAME) as BattleStationProxy;
         _loc2_.closeBattleStationWindows();
         BaseHandler._facade.sendNotification(BattleStationViewNotifications.CLOSE_ALL_UI_BUBBLES_OF_ID,param1.battleStationId);
      }
   }
}

