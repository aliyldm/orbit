package net.bigpoint.darkorbit.net.netty.handlers.battlestations
{
   import net.bigpoint.darkorbit.com.module.AsteroidProgressCommand;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.BattleStationProxy;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AsteroidProgressCommandHandler extends BaseHandler
   {
      
      public function AsteroidProgressCommandHandler()
      {
         super();
      }
      
      public static function run(param1:AsteroidProgressCommand) : void
      {
         var _loc2_:BattleStationProxy = _facade.retrieveProxy(BattleStationProxy.NAME) as BattleStationProxy;
         _loc2_.initAsteroidInstallProgress(param1);
      }
   }
}

