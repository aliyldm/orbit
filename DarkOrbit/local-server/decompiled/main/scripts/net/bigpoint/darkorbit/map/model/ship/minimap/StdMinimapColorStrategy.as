package net.bigpoint.darkorbit.map.model.ship.minimap
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.map.model.ship.RelationShipColorUtil;
   
   public class StdMinimapColorStrategy extends ShipMiniMapIcon
   {
      
      public function StdMinimapColorStrategy()
      {
         super();
      }
      
      override public function activateTrait() : void
      {
         super.activateTrait();
         ship.info.clanID.changed.add(this.updateColor);
         ship.info.clanDiplomacy.changed.add(this.updateColor);
         ship.info.factionID.changed.add(this.updateColor);
         Hero.radarCPUEquipped.changed.add(this.updateColor);
         Hero.premium.changed.add(this.updateColor);
         this.updateColor();
      }
      
      override public function deactivateTrait() : void
      {
         ship.info.clanID.changed.remove(this.updateColor);
         ship.info.clanDiplomacy.changed.remove(this.updateColor);
         ship.info.factionID.changed.remove(this.updateColor);
         Hero.radarCPUEquipped.changed.remove(this.updateColor);
         Hero.premium.changed.remove(this.updateColor);
         super.deactivateTrait();
      }
      
      public function updateColor() : void
      {
         color = RelationShipColorUtil.getColorRelatedToHero(ship);
      }
   }
}

