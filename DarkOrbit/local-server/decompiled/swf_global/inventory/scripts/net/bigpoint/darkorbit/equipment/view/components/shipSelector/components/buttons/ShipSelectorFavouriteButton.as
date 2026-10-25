package net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.events.Event;
   import mx.core.SpriteAsset;
   
   public class ShipSelectorFavouriteButton extends AbstractShipSelectorButton
   {
      
      private var skinDisable:Class = ShipSelectorFavouriteButton_skinDisable;
      
      private var skinNormal:Class = ShipSelectorFavouriteButton_skinNormal;
      
      private var skinOver:Class = ShipSelectorFavouriteButton_skinOver;
      
      private var skinActive:Class = ShipSelectorFavouriteButton_skinActive;
      
      private var _isFavourite:Boolean;
      
      public function ShipSelectorFavouriteButton()
      {
         super();
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
      
      public function setFavourite(param1:Boolean) : void
      {
         this._isFavourite = param1;
         if(this._isFavourite)
         {
            _normal.visible = true;
            _normal.alpha = 1;
            _disable.visible = false;
            _disable.alpha = 0;
         }
         else
         {
            _normal.visible = false;
            _normal.alpha = 0;
            _disable.visible = true;
            _disable.alpha = 1;
         }
         _active.visible = false;
         _over.visible = false;
      }
      
      public function isFavourite() : Boolean
      {
         return this._isFavourite;
      }
      
      override protected function handleMouseDownEvent(param1:Event) : void
      {
         if(this._isFavourite)
         {
            _active.visible = true;
         }
         else
         {
            TweenMax.to(this,0.3,{"colorMatrixFilter":{
               "amount":0.8,
               "contrast":0.7,
               "brightness":0.9,
               "saturation":0.8
            }});
         }
      }
      
      override protected function handleMouseUpEvent(param1:Event) : void
      {
         if(this._isFavourite)
         {
            _active.visible = false;
         }
         else
         {
            TweenMax.to(this,0.3,{"colorMatrixFilter":{
               "amount":1,
               "contrast":1,
               "brightness":1,
               "saturation":1
            }});
         }
      }
      
      override protected function handleMouseOutEvent(param1:Event) : void
      {
         if(this._isFavourite)
         {
            TweenLite.to(_over,0.3,{"autoAlpha":0});
            TweenLite.to(_normal,0.3,{"autoAlpha":1});
         }
         else
         {
            TweenMax.to(this,0.3,{"colorMatrixFilter":{
               "amount":1,
               "contrast":1,
               "brightness":1,
               "saturation":1
            }});
         }
      }
      
      override protected function handleMouseOverEvent(param1:Event) : void
      {
         if(this._isFavourite)
         {
            TweenLite.to(_over,0.3,{"autoAlpha":1});
            TweenLite.to(_normal,0.3,{"autoAlpha":0});
         }
         else
         {
            TweenMax.to(this,0.3,{"colorMatrixFilter":{
               "amount":1.2,
               "contrast":1.2,
               "brightness":1.2,
               "saturation":1.4
            }});
         }
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

