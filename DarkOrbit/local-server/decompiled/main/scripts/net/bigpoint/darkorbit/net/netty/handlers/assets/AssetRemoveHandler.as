package net.bigpoint.darkorbit.net.netty.handlers.assets
{
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.AssetRemoveCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AssetRemoveHandler extends BaseHandler
   {
      
      public function AssetRemoveHandler()
      {
         super();
      }
      
      public static function run(param1:IModule) : void
      {
         var _loc2_:AssetRemoveCommand = param1 as AssetRemoveCommand;
         map.getShipManager().removeShip(_loc2_.uid,true);
      }
   }
}

