package net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons
{
   import mx.core.SpriteAsset;
   
   public class ShipSelectorGridDownButton extends AbstractShipSelectorButton
   {
      
      private var skinDisable:Class = ShipSelectorGridDownButton_skinDisable;
      
      private var skinNormal:Class = ShipSelectorGridDownButton_skinNormal;
      
      private var skinOver:Class = ShipSelectorGridDownButton_skinOver;
      
      private var skinActive:Class = ShipSelectorGridDownButton_skinActive;
      
      public function ShipSelectorGridDownButton()
      {
         super();
      }
      
      override protected function setDefaultSize() : void
      {
         if(_hitLayer)
         {
            _hitLayer.width = 104;
            _hitLayer.height = 17;
         }
      }
      
      override protected function createDisableState() : void
      {
         _disable = new SpriteAsset();
         _disable.addChild(new this.skinDisable());
         super.createDisableState();
      }
      
      override protected function createActiveState() : void
      {
         _active = new SpriteAsset();
         _active.addChild(new this.skinActive());
         super.createActiveState();
      }
      
      override protected function createOverState() : void
      {
         _over = new SpriteAsset();
         _over.addChild(new this.skinOver());
         super.createOverState();
      }
      
      override protected function createNormalState() : void
      {
         _normal = new SpriteAsset();
         _normal.addChild(new this.skinNormal());
         super.createNormalState();
      }
   }
}

