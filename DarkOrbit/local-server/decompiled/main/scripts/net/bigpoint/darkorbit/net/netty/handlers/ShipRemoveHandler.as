package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.ShipRemoveCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class ShipRemoveHandler extends BaseHandler
   {
      
      public function ShipRemoveHandler()
      {
         super();
      }
      
      public static function run(param1:ShipRemoveCommand) : void
      {
         var _loc2_:int = param1.userId;
         _main.getConnectionManager().getShipAssembly().assembleShipRemoval(_loc2_);
      }
   }
}

