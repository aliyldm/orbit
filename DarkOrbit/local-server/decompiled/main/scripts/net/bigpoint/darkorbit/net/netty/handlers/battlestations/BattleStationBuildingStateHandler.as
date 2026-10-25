package net.bigpoint.darkorbit.net.netty.handlers.battlestations
{
   import net.bigpoint.darkorbit.com.module.BattleStationBuildingStateCommand;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.BattleStationProxy;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class BattleStationBuildingStateHandler extends BaseHandler
   {
      
      public function BattleStationBuildingStateHandler()
      {
         super();
      }
      
      public static function run(param1:BattleStationBuildingStateCommand) : void
      {
         var _loc2_:BattleStationProxy = _facade.retrieveProxy(BattleStationProxy.NAME) as BattleStationProxy;
         _loc2_.connMan = _main.getConnectionManager();
         _loc2_.setBattleStationToBuildState(param1);
      }
   }
}

