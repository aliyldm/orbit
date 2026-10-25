package net.bigpoint.darkorbit.map.model.ship.factory.classes
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.map.model.minimap.traits.AbstractMiniMapTrait;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.factory.IShipFactory;
   import net.bigpoint.darkorbit.map.model.ship.factory.MinimapStrategyFactory;
   import net.bigpoint.darkorbit.map.model.ship.minimap.HeroMiniMapTrait;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   
   public class SimpleShipFactory implements IShipFactory
   {
      
      public function SimpleShipFactory()
      {
         super();
      }
      
      public function createShip(param1:int, param2:ShipPattern, param3:int, param4:Object = null) : Ship
      {
         var _loc5_:AbstractMiniMapTrait = null;
         if(param1 == Hero.userID)
         {
            _loc5_ = new HeroMiniMapTrait();
         }
         else
         {
            _loc5_ = MinimapStrategyFactory.instance.build(param3);
         }
         return new Ship(param1,param2 as ShipPattern,_loc5_);
      }
   }
}

