package net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons
{
   import com.greensock.TweenMax;
   import flash.events.Event;
   import flash.text.TextFormat;
   
   public class ShipSelectorTabbarButton extends AbstractShipSelectorButton
   {
      
      private var skinDeactive:Class = ShipSelectorTabbarButton_skinDeactive;
      
      private var skinActive:Class = ShipSelectorTabbarButton_skinActive;
      
      private var _isActive:Boolean;
      
      public function ShipSelectorTabbarButton(param1:String = null, param2:TextFormat = null)
      {
         super(param1,param2);
      }
      
      public function setActivation(param1:Boolean) : void
      {
         this._isActive = param1;
         if(this._isActive)
         {
            TweenMax.to(this._label,0.3,{"colorMatrixFilter":{
               "amount":1,
               "colorize":16763904
            }});
         }
         else
         {
            TweenMax.to(this._label,0.3,{"colorMatrixFilter":{
               "amount":0,
               "colorize":16763904
            }});
         }
      }
      
      public function isActive() : Boolean
      {
         return this._isActive;
      }
      
      override protected function handleMouseDownEvent(param1:Event) : void
      {
      }
      
      override protected function handleMouseUpEvent(param1:Event) : void
      {
      }
      
      override public function setWidth(param1:uint) : void
      {
         _disable.width = param1;
         _normal.width = param1;
         if(_label)
         {
            _label.width = param1;
         }
         if(_hitLayer)
         {
            _hitLayer.width = param1;
         }
      }
      
      override public function setHeight(param1:uint) : void
      {
         _disable.height = param1;
         _normal.height = param1;
         if(_label)
         {
            _label.height = uint(this.textFormat.size);
            _label.y = (param1 - _label.height >> 1) - 2;
         }
         if(_hitLayer)
         {
            _hitLayer.height = param1;
         }
      }
      
      override protected function createDisableState() : void
      {
         _disable = new this.skinDeactive();
         super.createDisableState();
      }
      
      override protected function createNormalState() : void
      {
         _normal = new this.skinActive();
         super.createNormalState();
      }
      
      override protected function createActiveState() : void
      {
         _active = new this.skinActive();
         super.createActiveState();
      }
      
      override protected function createOverState() : void
      {
         _over = new this.skinActive();
         super.createOverState();
      }
      
      override protected function handleMouseOutEvent(param1:Event) : void
      {
         TweenMax.to(this,0.3,{"colorMatrixFilter":{
            "amount":1,
            "contrast":1,
            "brightness":1,
            "saturation":1
         }});
      }
      
      override protected function handleMouseOverEvent(param1:Event) : void
      {
         TweenMax.to(this,0.3,{"colorMatrixFilter":{
            "amount":1,
            "contrast":1.5,
            "brightness":1.2,
            "saturation":1.3
         }});
      }
      
      override public function setText(param1:String, param2:TextFormat = null) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Number = NaN;
         if(param1)
         {
            if(param2)
            {
               textFormat = param2;
               _label.defaultTextFormat = param2;
            }
            _label.text = this.text = param1;
            _label.visible = true;
            this._label.scaleX = this._label.scaleY = 1;
            _loc3_ = _label.width;
            _loc4_ = uint(getWidth());
            if(_loc3_ > _loc4_)
            {
               _loc5_ = _loc4_ / _loc3_;
               this._label.scaleX = this._label.scaleY = _loc5_;
            }
            centerTextHorizontally();
            centerTextVertically();
         }
         else
         {
            _label.visible = false;
         }
      }
   }
}

