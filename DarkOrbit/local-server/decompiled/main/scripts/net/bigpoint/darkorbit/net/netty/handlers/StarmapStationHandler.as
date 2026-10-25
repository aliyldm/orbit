package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.StarmapStationCommand;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.spaceMap.SpaceMapDataProxy;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class StarmapStationHandler extends BaseHandler
   {
      
      public function StarmapStationHandler()
      {
         super();
      }
      
      private static function get spaceMapStationIconProxy() : SpaceMapDataProxy
      {
         return GameFacade.getInstance().retrieveProxy(SpaceMapDataProxy.NAME) as SpaceMapDataProxy;
      }
      
      public static function run(param1:StarmapStationCommand) : void
      {
         spaceMapStationIconProxy.updateSpaceMapStations(param1.stations,param1.currentServerTimestamp);
      }
   }
}

