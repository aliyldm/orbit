package net.bigpoint.darkorbit.map.model.ship.factory.classes
{
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   
   public class StreunerTurretFactory extends SimpleShipFactory
   {
      
      public function StreunerTurretFactory()
      {
         super();
      }
      
      override public function createShip(param1:int, param2:ShipPattern, param3:int, param4:Object = null) : Ship
      {
         return super.createShip(param1,param2,param3,param4) as Ship;
      }
   }
}

