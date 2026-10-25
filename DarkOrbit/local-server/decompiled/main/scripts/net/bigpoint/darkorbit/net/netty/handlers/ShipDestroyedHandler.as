package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.ShipDestroyedCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class ShipDestroyedHandler extends BaseHandler
   {
      
      public function ShipDestroyedHandler()
      {
         super();
      }
      
      public static function run(param1:ShipDestroyedCommand) : void
      {
         var _loc2_:int = param1.destroyedUserId;
         var _loc3_:int = param1.explosionTypeId;
         _main.getConnectionManager().getShipAssembly().assembleShipDestroy(_loc2_,_loc3_);
      }
   }
}

