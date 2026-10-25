package net.bigpoint.darkorbit.net.netty.handlers.battlestations
{
   import net.bigpoint.darkorbit.com.module.BattleStationStatusCommand;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.BattleStationProxy;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class BattleStationStatusCommandHandler extends BaseHandler
   {
      
      public function BattleStationStatusCommandHandler()
      {
         super();
      }
      
      public static function run(param1:BattleStationStatusCommand) : void
      {
         var _loc2_:BattleStationProxy = _facade.retrieveProxy(BattleStationProxy.NAME) as BattleStationProxy;
         _loc2_.connMan = _main.getConnectionManager();
         _loc2_.initManagementUIModelForBattleStation(param1,param1.battleStationName,false);
      }
   }
}

