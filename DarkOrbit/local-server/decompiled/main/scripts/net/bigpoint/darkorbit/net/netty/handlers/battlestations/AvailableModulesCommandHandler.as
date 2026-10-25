package net.bigpoint.darkorbit.net.netty.handlers.battlestations
{
   import net.bigpoint.darkorbit.com.module.AvailableModulesCommand;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.BattleStationProxy;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AvailableModulesCommandHandler extends BaseHandler
   {
      
      public function AvailableModulesCommandHandler()
      {
         super();
      }
      
      public static function run(param1:AvailableModulesCommand) : void
      {
         var _loc2_:BattleStationProxy = _facade.retrieveProxy(BattleStationProxy.NAME) as BattleStationProxy;
         _loc2_.connMan = _main.getConnectionManager();
         _loc2_.updateBattleStationModuleModel(param1);
      }
   }
}

