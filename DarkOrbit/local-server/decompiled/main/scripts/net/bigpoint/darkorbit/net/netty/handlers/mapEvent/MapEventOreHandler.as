package net.bigpoint.darkorbit.net.netty.handlers.mapEvent
{
   import net.bigpoint.darkorbit.com.module.MapEventOreCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class MapEventOreHandler extends BaseHandler
   {
      
      public function MapEventOreHandler()
      {
         super();
      }
      
      public static function run(param1:MapEventOreCommand) : void
      {
         var _loc2_:int = param1.oreType.typeValue;
         _main.getConnectionManager().getMapEventsAssembly().assembleOreCollectedByHero(_loc2_);
      }
   }
}

