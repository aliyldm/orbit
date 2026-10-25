package net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons
{
   import mx.core.SpriteAsset;
   
   public class ShipSelectorGridBottomButton extends AbstractShipSelectorButton
   {
      
      private var skinDisable:Class = ShipSelectorGridBottomButton_skinDisable;
      
      private var skinNormal:Class = ShipSelectorGridBottomButton_skinNormal;
      
      private var skinOver:Class = ShipSelectorGridBottomButton_skinOver;
      
      private var skinActive:Class = ShipSelectorGridBottomButton_skinActive;
      
      public function ShipSelectorGridBottomButton()
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

