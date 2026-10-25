package net.bigpoint.darkorbit.net.netty.handlers.battlestations
{
   import net.bigpoint.darkorbit.com.module.StationModuleModule;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.BattleStationProxy;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.ModuleStatusVO;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class StationModuleModuleHandler extends BaseHandler
   {
      
      public function StationModuleModuleHandler()
      {
         super();
      }
      
      public static function run(param1:StationModuleModule) : void
      {
         var _loc2_:BattleStationProxy = _facade.retrieveProxy(BattleStationProxy.NAME) as BattleStationProxy;
         var _loc3_:ModuleStatusVO = new ModuleStatusVO(param1.asteroidId,param1.slotId,param1.currentHitpoints,param1.maxHitpoints,param1.currentShield,param1.maxShield,param1.emergencyRepairSecondsLeft,param1.emergencyRepairSecondsTotal,param1.installationSecondsLeft);
         _loc2_.updateInstalledModulesStats(_loc3_);
      }
   }
}

