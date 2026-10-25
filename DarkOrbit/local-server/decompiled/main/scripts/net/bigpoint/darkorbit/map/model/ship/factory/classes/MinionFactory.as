package net.bigpoint.darkorbit.map.model.ship.factory.classes
{
   import net.bigpoint.darkorbit.map.model.ship.MotherShipTrait;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.factory.IShipFactory;
   import net.bigpoint.darkorbit.map.model.ship.factory.vos.MinionVo;
   import net.bigpoint.darkorbit.map.model.ship.minimap.ShipMiniMapIcon;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   
   public class MinionFactory implements IShipFactory
   {
      
      public function MinionFactory()
      {
         super();
      }
      
      public function createShip(param1:int, param2:ShipPattern, param3:int, param4:Object = null) : Ship
      {
         var _loc5_:Ship = null;
         var _loc6_:MinionVo = param4 as MinionVo;
         _loc5_ = new Ship(param1,param2,new ShipMiniMapIcon());
         if(_loc6_)
         {
            MotherShipTrait.dockMinion(_loc6_.motherShipID,_loc5_,_loc6_.posIndex);
         }
         return _loc5_;
      }
   }
}

