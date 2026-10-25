package net.bigpoint.darkorbit.map.model.ship.factory.classes
{
   import net.bigpoint.darkorbit.map.model.minimap.traits.AbstractMiniMapTrait;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   
   public class NoMiniMapIconFactory extends SimpleShipFactory
   {
      
      public function NoMiniMapIconFactory()
      {
         super();
      }
      
      override public function createShip(param1:int, param2:ShipPattern, param3:int, param4:Object = null) : Ship
      {
         var _loc5_:Ship = super.createShip(param1,param2,param3,param4) as Ship;
         _loc5_.removeTraitByType(AbstractMiniMapTrait);
         return _loc5_;
      }
   }
}

