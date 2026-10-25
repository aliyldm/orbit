package net.bigpoint.darkorbit.map.model.ship.minimap
{
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class CompanyColorStrategy extends ShipMiniMapIcon
   {
      
      public function CompanyColorStrategy()
      {
         super();
      }
      
      override public function activateTrait() : void
      {
         super.activateTrait();
         color = InGameCatalog.instance.factions_colours[ship.info.factionID.value];
      }
   }
}

