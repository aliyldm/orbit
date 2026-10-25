package net.bigpoint.darkorbit.map.model.ship.factory.classes
{
   import net.bigpoint.darkorbit.map.model.ship.MotherShipTrait;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.factory.IShipFactory;
   import net.bigpoint.darkorbit.map.model.ship.minimap.StdMinimapColorStrategy;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   
   public class MotherShipFactory implements IShipFactory
   {
      
      public function MotherShipFactory()
      {
         super();
      }
      
      public function createShip(param1:int, param2:ShipPattern, param3:int, param4:Object = null) : Ship
      {
         var _loc5_:Ship = new Ship(param1,param2,new StdMinimapColorStrategy());
         _loc5_.addTrait(new MotherShipTrait());
         return _loc5_;
      }
   }
}

