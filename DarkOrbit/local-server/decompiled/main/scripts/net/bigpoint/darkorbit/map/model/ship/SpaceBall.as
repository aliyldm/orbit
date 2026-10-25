package net.bigpoint.darkorbit.map.model.ship
{
   import net.bigpoint.darkorbit.map.model.minimap.traits.MiniMapIconTrait;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   import net.bigpoint.darkorbit.map.model.traits.HPTrait;
   
   public class SpaceBall extends Ship
   {
      
      public function SpaceBall(param1:int, param2:ShipPattern)
      {
         super(param1,param2,new MiniMapIconTrait("mapIcon_spaceball"));
         removeTraitByType(HPTrait);
      }
   }
}

