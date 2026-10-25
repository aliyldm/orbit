package net.bigpoint.darkorbit.net.netty.handlers
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.SpaceStationCommand;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.env.Station;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class SpaceStationHandler extends BaseHandler
   {
      
      public function SpaceStationHandler()
      {
         super();
      }
      
      public static function run(param1:SpaceStationCommand) : void
      {
         map.addEntity(new Station(param1.id || Map.NEXT_FREE_ID,new PointLite(param1.posX,param1.posY),param1.type));
      }
   }
}

