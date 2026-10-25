package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.ShipDeselectionCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class ShipDeselectionHandler extends BaseHandler
   {
      
      public function ShipDeselectionHandler()
      {
         super();
      }
      
      public static function run(param1:ShipDeselectionCommand) : void
      {
         _main.getConnectionManager().getShipAssembly().assembleShipDeselection();
      }
   }
}

