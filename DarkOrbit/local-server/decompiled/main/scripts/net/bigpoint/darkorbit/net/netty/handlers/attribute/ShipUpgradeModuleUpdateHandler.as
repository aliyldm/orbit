package net.bigpoint.darkorbit.net.netty.handlers.attribute
{
   import net.bigpoint.darkorbit.com.module.ShipUpgradeModuleUpdateCommand;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.ShipUpgradesTrait;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class ShipUpgradeModuleUpdateHandler extends BaseHandler
   {
      
      public function ShipUpgradeModuleUpdateHandler()
      {
         super();
      }
      
      public static function run(param1:ShipUpgradeModuleUpdateCommand) : void
      {
         var _loc3_:ShipUpgradesTrait = null;
         var _loc4_:int = 0;
         var _loc2_:Ship = _main.screenManager.map.getShipManager().getShip(param1.uid);
         if(_loc2_)
         {
            _loc3_ = _loc2_.getFirstTrait(ShipUpgradesTrait) as ShipUpgradesTrait;
            _loc3_._shipUpgrades.clear();
            for each(_loc4_ in param1.moduleTypeIds)
            {
               _loc3_._shipUpgrades.addElement(_loc4_);
            }
            while(_loc3_._shipUpgrades.length < param1.max)
            {
               _loc3_._shipUpgrades.addElement(0);
            }
         }
      }
   }
}

