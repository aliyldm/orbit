package net.bigpoint.darkorbit.net.netty.handlers.battlestations
{
   import net.bigpoint.darkorbit.com.module.BattleStationErrorCommand;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.BattleStationProxy;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class EquipModuleBattleStationErrorHandler extends BaseHandler
   {
      
      public function EquipModuleBattleStationErrorHandler()
      {
         super();
      }
      
      public static function run(param1:BattleStationErrorCommand) : void
      {
         var _loc2_:BattleStationProxy = _facade.retrieveProxy(BattleStationProxy.NAME) as BattleStationProxy;
         _loc2_.handleEquipModuleError(param1.type);
      }
   }
}

