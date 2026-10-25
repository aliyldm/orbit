package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.BoosterFoundOnMapCommand;
   import net.bigpoint.darkorbit.net.MapEventsAssembly;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class BoosterFoundOnMapHandler extends BaseHandler
   {
      
      public function BoosterFoundOnMapHandler()
      {
         super();
      }
      
      public static function run(param1:BoosterFoundOnMapCommand) : void
      {
         MapEventsAssembly.getInstance().assembleBoosterFound(["","","",param1.lootId,param1.hours]);
      }
   }
}

