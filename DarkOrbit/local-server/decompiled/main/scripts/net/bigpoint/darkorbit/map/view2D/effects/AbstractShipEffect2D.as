package net.bigpoint.darkorbit.map.view2D.effects
{
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.ShipDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.display.ship.Ship2D;
   
   public class AbstractShipEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function AbstractShipEffect2D(param1:MapView2D, param2:MapObjectEffect, param3:Boolean = true, param4:Boolean = true, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      protected function get ship() : Ship
      {
         return effect ? (effect as MapObjectEffect).source as Ship : null;
      }
      
      protected function get shipView() : Ship2D
      {
         return mapView.entitiesLayer.getViewByTrait(this.ship.getFirstTrait(ShipDisplayTrait)) as Ship2D;
      }
   }
}

