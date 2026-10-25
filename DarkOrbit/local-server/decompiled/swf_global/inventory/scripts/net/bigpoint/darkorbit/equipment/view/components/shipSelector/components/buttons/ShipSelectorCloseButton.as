package net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons
{
   import com.greensock.TweenLite;
   import flash.events.Event;
   import mx.core.SpriteAsset;
   
   public class ShipSelectorCloseButton extends AbstractShipSelectorButton
   {
      
      private var skinDisable:Class = ShipSelectorCloseButton_skinDisable;
      
      private var skinNormal:Class = ShipSelectorCloseButton_skinNormal;
      
      private var skinOver:Class = ShipSelectorCloseButton_skinOver;
      
      private var skinActive:Class = ShipSelectorCloseButton_skinActive;
      
      public function ShipSelectorCloseButton()
      {
         super();
      }
      
      override protected function _drawMouseStateOut() : void
      {
         TweenLite.to(_over,0,{"autoAlpha":0});
         TweenLite.to(_normal,0,{"autoAlpha":1});
      }
      
      override protected function _drawMouseStateOver() : void
      {
         TweenLite.to(_over,0,{"autoAlpha":1});
         TweenLite.to(_normal,0,{"autoAlpha":0});
      }
      
      override public function setEnable(param1:Boolean) : void
      {
         if(param1)
         {
            this.mouseChildren = this.mouseEnabled = true;
            this.alpha = 1;
         }
         else
         {
            this.mouseChildren = this.mouseEnabled = false;
            this.alpha = 0.5;
         }
      }
      
      override protected function handleMouseDownEvent(param1:Event) : void
      {
         _mouseState = MOUSE_STATE__DOWN;
         drawMouseState();
      }
      
      override protected function handleMouseUpEvent(param1:Event) : void
      {
         _mouseState = MOUSE_STATE__UP;
         drawMouseState();
      }
      
      override protected function handleMouseOutEvent(param1:Event) : void
      {
         _mouseState = MOUSE_STATE__OUT;
         drawMouseState();
      }
      
      override protected function handleMouseOverEvent(param1:Event) : void
      {
         _mouseState = MOUSE_STATE__OVER;
         drawMouseState();
      }
      
      override protected function setDefaultSize() : void
      {
         if(_hitLayer)
         {
            _hitLayer.width = 18;
            _hitLayer.height = 18;
         }
      }
      
      override protected function createDisableState() : void
      {
         _disable = new SpriteAsset();
         _disable.addChild(new this.skinDisable());
         super.createActiveState();
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

