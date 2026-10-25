package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.ShipCreateCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class ShipCreateHandler extends BaseHandler
   {
      
      public function ShipCreateHandler()
      {
         super();
      }
      
      public static function run(param1:ShipCreateCommand) : void
      {
         _main.getConnectionManager().getShipAssembly().assembleShipCreation(param1);
      }
   }
}

