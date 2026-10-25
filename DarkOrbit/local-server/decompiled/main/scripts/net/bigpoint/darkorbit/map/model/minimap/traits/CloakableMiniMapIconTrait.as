package net.bigpoint.darkorbit.map.model.minimap.traits
{
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class CloakableMiniMapIconTrait extends MiniMapIconTrait
   {
      
      public function CloakableMiniMapIconTrait(param1:String, param2:String = "minimap", param3:int = 0, param4:Number = 0)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function activateTrait() : void
      {
         super.activateTrait();
         this.ship.cloaked.changed.add(this.updateIconVisibility);
      }
      
      override public function deactivateTrait() : void
      {
         this.ship.cloaked.changed.remove(this.updateIconVisibility);
         super.deactivateTrait();
      }
      
      protected function get ship() : Ship
      {
         return owner as Ship;
      }
      
      private function updateIconVisibility() : void
      {
         toggleIconVisibility(!this.ship.cloaked.value);
      }
   }
}

