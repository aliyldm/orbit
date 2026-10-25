package net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons
{
   import mx.core.SpriteAsset;
   
   public class ShipSelectorGridTopButton extends AbstractShipSelectorButton
   {
      
      private var skinDisable:Class = ShipSelectorGridTopButton_skinDisable;
      
      private var skinNormal:Class = ShipSelectorGridTopButton_skinNormal;
      
      private var skinOver:Class = ShipSelectorGridTopButton_skinOver;
      
      private var skinActive:Class = ShipSelectorGridTopButton_skinActive;
      
      public function ShipSelectorGridTopButton()
      {
         super();
      }
      
      override protected function setDefaultSize() : void
      {
         if(_hitLayer)
         {
            _hitLayer.width = 34;
            _hitLayer.height = 17;
         }
      }
      
      override protected function createDisableState() : void
      {
         _disable = new SpriteAsset();
         _disable.addChild(new this.skinDisable());
         super.createDisableState();
      }
      
      override protected function createNormalState() : void
      {
         _normal = new SpriteAsset();
         _normal.addChild(new this.skinNormal());
         super.createNormalState();
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
   }
}

