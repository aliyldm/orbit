package net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.events.Event;
   import mx.core.SpriteAsset;
   
   public class ShipSelectorInfoButton extends AbstractShipSelectorButton
   {
      
      private var skinDisable:Class = ShipSelectorInfoButton_skinDisable;
      
      private var skinNormal:Class = ShipSelectorInfoButton_skinNormal;
      
      private var skinOver:Class = ShipSelectorInfoButton_skinOver;
      
      private var skinActive:Class = ShipSelectorInfoButton_skinActive;
      
      private var _isContentVisible:Boolean;
      
      public function ShipSelectorInfoButton()
      {
         super();
      }
      
      override protected function _drawMouseStateNormal() : void
      {
         if(this._isContentVisible)
         {
            _active.visible = true;
         }
         else
         {
            _active.visible = false;
         }
      }
      
      override protected function _drawMouseStateOver() : void
      {
         if(this._isContentVisible)
         {
            _active.visible = true;
            TweenMax.to(this,0.3,{"colorMatrixFilter":{
               "amount":1,
               "contrast":1.4,
               "brightness":1.2,
               "saturation":1.3
            }});
         }
         else
         {
            TweenLite.to(_over,0.3,{"autoAlpha":1});
            TweenLite.to(_normal,0.3,{"autoAlpha":0});
         }
      }
      
      override protected function _drawMouseStateOut() : void
      {
         if(this._isContentVisible)
         {
            _active.visible = true;
            TweenMax.to(this,0.3,{"colorMatrixFilter":{
               "amount":1,
               "contrast":1,
               "brightness":1,
               "saturation":1
            }});
         }
         else
         {
            _active.visible = false;
            TweenLite.to(_over,0.3,{"autoAlpha":0});
            TweenLite.to(_normal,0.3,{"autoAlpha":1});
         }
      }
      
      override protected function _drawMouseStateDown() : void
      {
         if(this._isContentVisible)
         {
            _active.visible = true;
         }
         else
         {
            _active.visible = false;
         }
      }
      
      public function setActiveFalse() : void
      {
         this._isContentVisible = false;
         _active.visible = false;
      }
      
      override protected function _drawMouseStateUp() : void
      {
         this._drawMouseStateNormal();
      }
      
      public function set showContent(param1:Boolean) : void
      {
         this._isContentVisible = param1;
         drawMouseState();
      }
      
      public function isContentVisible() : Boolean
      {
         return this._isContentVisible;
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
         this._isContentVisible = !this._isContentVisible;
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

