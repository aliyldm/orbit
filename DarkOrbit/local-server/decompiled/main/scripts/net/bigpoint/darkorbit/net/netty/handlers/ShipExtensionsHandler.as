package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.ShipExtensionsCommand;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class ShipExtensionsHandler extends BaseHandler
   {
      
      public function ShipExtensionsHandler()
      {
         super();
      }
      
      public static function run(param1:ShipExtensionsCommand) : void
      {
         var _loc2_:Ship = map.getEntityById(param1.userId) as Ship;
         if(_loc2_)
         {
            _loc2_.laserExpansionStage.value = param1.extensionStage;
         }
      }
   }
}

