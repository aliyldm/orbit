package net.bigpoint.darkorbit.map.model.ship.factory
{
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   
   public interface IShipFactory
   {
      
      function createShip(param1:int, param2:ShipPattern, param3:int, param4:Object = null) : Ship;
   }
}

