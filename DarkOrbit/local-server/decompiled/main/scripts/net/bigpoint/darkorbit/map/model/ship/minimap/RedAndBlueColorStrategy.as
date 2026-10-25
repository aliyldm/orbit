package net.bigpoint.darkorbit.map.model.ship.minimap
{
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class RedAndBlueColorStrategy extends ShipMiniMapIcon
   {
      
      public function RedAndBlueColorStrategy()
      {
         super();
      }
      
      override public function activateTrait() : void
      {
         super.activateTrait();
         color = Ship(owner).isNPC ? uint(4294901760) : uint(4278229503);
      }
   }
}

