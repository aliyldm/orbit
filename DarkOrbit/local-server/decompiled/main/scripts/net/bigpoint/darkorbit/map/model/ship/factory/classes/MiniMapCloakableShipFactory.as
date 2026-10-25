package net.bigpoint.darkorbit.map.model.ship.factory.classes
{
   import net.bigpoint.darkorbit.map.model.minimap.traits.CloakableMiniMapIconTrait;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.factory.IShipFactory;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   
   public class MiniMapCloakableShipFactory implements IShipFactory
   {
      
      public function MiniMapCloakableShipFactory()
      {
         super();
      }
      
      public function createShip(param1:int, param2:ShipPattern, param3:int, param4:Object = null) : Ship
      {
         return new Ship(param1,param2,new CloakableMiniMapIconTrait(param2.minimapIcon));
      }
   }
}

