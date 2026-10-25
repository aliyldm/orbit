package net.bigpoint.darkorbit.map.model.ship.factory.classes
{
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.SpaceBall;
   import net.bigpoint.darkorbit.map.model.ship.factory.IShipFactory;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   
   public class SpaceballFactory implements IShipFactory
   {
      
      public function SpaceballFactory()
      {
         super();
      }
      
      public function createShip(param1:int, param2:ShipPattern, param3:int, param4:Object = null) : Ship
      {
         return new SpaceBall(param1,param2);
      }
   }
}

