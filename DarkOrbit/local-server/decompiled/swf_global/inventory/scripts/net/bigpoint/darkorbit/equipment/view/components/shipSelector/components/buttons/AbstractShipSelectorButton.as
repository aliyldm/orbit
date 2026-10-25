package net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons
{
   import com.greensock.TweenLite;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import mx.core.SpriteAsset;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   
   public class AbstractShipSelectorButton extends Sprite
   {
      
      public var textFormat:TextFormat = new TextFormat();
      
      public var text:String;
      
      protected var _label:TextField;
      
      protected var _disable:SpriteAsset;
      
      protected var _normal:SpriteAsset;
      
      protected var _over:SpriteAsset;
      
      protected var _active:SpriteAsset;
      
      protected var _hitLayer:Sprite;
      
      protected var _resizedWidthCallback:Function;
      
      protected var _enabled:Boolean = true;
      
      protected const MOUSE_STATE__NORMAL:uint = 1;
      
      protected const MOUSE_STATE__OVER:uint = 2;
      
      protected const MOUSE_STATE__DOWN:uint = 4;
      
      protected const MOUSE_STATE__UP:uint = 8;
      
      protected const MOUSE_STATE__OUT:uint = 16;
      
      protected var _mouseState:uint = 1;
      
      public function AbstractShipSelectorButton(param1:String = null, param2:TextFormat = null)
      {
         super();
         if(param1)
         {
            this.text = param1;
         }
         if(param2)
         {
            this.textFormat = param2;
         }
         this.init();
      }
      
      protected function drawMouseState() : void
      {
         switch(this._mouseState)
         {
            case this.MOUSE_STATE__NORMAL:
               this._drawMouseStateNormal();
               break;
            case this.MOUSE_STATE__DOWN:
               this._drawMouseStateDown();
               break;
            case this.MOUSE_STATE__UP:
               this._drawMouseStateUp();
               break;
            case this.MOUSE_STATE__OVER:
               this._drawMouseStateOver();
               break;
            case this.MOUSE_STATE__OUT:
               this._drawMouseStateOut();
         }
      }
      
      protected function _drawMouseStateNormal() : void
      {
      }
      
      protected function _drawMouseStateOver() : void
      {
      }
      
      protected function _drawMouseStateOut() : void
      {
      }
      
      protected function _drawMouseStateUp() : void
      {
      }
      
      protected function _drawMouseStateDown() : void
      {
      }
      
      protected function init() : void
      {
         this.buttonMode = this.useHandCursor = true;
         this.createDisableState();
         this.createNormalState();
         this.createOverState();
         this.createActiveState();
         this.createLabel();
         this.createHitlayer();
         this.setDefaultSize();
         this.setEnable(true);
      }
      
      protected function setDefaultSize() : void
      {
      }
      
      protected function createDisableState() : void
      {
         if(this._disable)
         {
            this.addChild(this._disable);
         }
      }
      
      protected function createNormalState() : void
      {
         if(this._normal)
         {
            this.addChild(this._normal);
         }
      }
      
      protected function createOverState() : void
      {
         if(this._over)
         {
            this._over.visible = false;
            this.addChild(this._over);
         }
      }
      
      protected function createActiveState() : void
      {
         if(this._active)
         {
            this._active.visible = false;
            this.addChild(this._active);
         }
      }
      
      protected function createLabel() : void
      {
         this._label = new TextField();
         this.addChild(this._label);
         this.setLabelAttributes();
      }
      
      protected function createHitlayer() : void
      {
         this._hitLayer = new Sprite();
         var _loc1_:Graphics = this._hitLayer.graphics as Graphics;
         _loc1_.beginFill(16711935,0);
         _loc1_.drawRect(0,0,100,100);
         _loc1_.endFill();
         this._hitLayer.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDownEvent);
         this._hitLayer.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUpEvent);
         this._hitLayer.addEventListener("releaseOutside",this.handleMouseUpEvent);
         this._hitLayer.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutEvent);
         this._hitLayer.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverEvent);
         this.addChild(this._hitLayer);
      }
      
      protected function setLabelAttributes() : void
      {
         this._label.autoSize = TextFieldAutoSize.LEFT;
         this._label.wordWrap = false;
         this._label.multiline = false;
         this._label.embedFonts = Styles.baseEmbed;
         this._label.mouseEnabled = false;
         this._label.selectable = false;
         this._label.defaultTextFormat = this.textFormat;
         this._label.width = this._label.height = 4;
         this.setText(this.text);
      }
      
      public function setText(param1:String, param2:TextFormat = null) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(param1)
         {
            if(param2)
            {
               this.textFormat = param2;
               this._label.defaultTextFormat = param2;
            }
            this._label.text = this.text = param1;
            this._label.visible = true;
            _loc3_ = this._label.width;
            _loc4_ = uint(this.getWidth());
            if(_loc3_ > _loc4_)
            {
               this.setWidth(_loc3_);
               if(this._resizedWidthCallback != null)
               {
                  this._resizedWidthCallback(this);
               }
            }
            else
            {
               this.centerTextHorizontally();
            }
            this.centerTextVertically();
         }
         else
         {
            this._label.visible = false;
         }
      }
      
      protected function centerTextVertically(param1:int = -1) : void
      {
         if(param1 <= 0)
         {
            param1 = this.getHeight();
         }
         this._label.height = uint(this.textFormat.size + 2);
         this._label.y = param1 - this._label.height >> 1;
      }
      
      protected function centerTextHorizontally() : void
      {
         var _loc1_:Number = this.getWidth();
         this._label.x = _loc1_ - this._label.width >> 1;
      }
      
      protected function handleMouseDownEvent(param1:Event) : void
      {
         if(this._enabled)
         {
            this._active.visible = true;
         }
      }
      
      protected function handleMouseUpEvent(param1:Event) : void
      {
         if(this._enabled)
         {
            this._active.visible = false;
         }
      }
      
      protected function handleMouseOutEvent(param1:Event) : void
      {
         if(this._enabled)
         {
            TweenLite.to(this._over,0.3,{"autoAlpha":0});
            TweenLite.to(this._normal,0.3,{"autoAlpha":1});
         }
      }
      
      protected function handleMouseOverEvent(param1:Event) : void
      {
         if(this._enabled)
         {
            TweenLite.to(this._over,0.3,{"autoAlpha":1});
            TweenLite.to(this._normal,0.3,{"autoAlpha":0});
         }
      }
      
      public function setEnable(param1:Boolean) : void
      {
         this.mouseChildren = this.mouseEnabled = param1;
         this._enabled = param1;
         if(this._disable)
         {
            TweenLite.to(this._disable,0.2,{"autoAlpha":(param1 ? 0 : 1)});
         }
         if(this._normal)
         {
            TweenLite.to(this._normal,0.2,{"autoAlpha":(param1 ? 1 : 0)});
         }
         if(Boolean(this._over) && !param1)
         {
            TweenLite.to(this._over,0.2,{"autoAlpha":0});
         }
         if(this._active)
         {
            TweenLite.to(this._active,0.2,{"autoAlpha":0});
         }
      }
      
      public function setSize(param1:uint, param2:uint) : void
      {
         this.setWidth(param1);
         this.setHeight(param2);
      }
      
      public function setWidth(param1:uint) : void
      {
         if(this._normal)
         {
            this._normal.width = param1;
         }
         if(this._over)
         {
            this._over.width = param1;
         }
         if(this._active)
         {
            this._active.width = param1;
         }
         if(this._label)
         {
            this._label.width = param1;
         }
         if(this._hitLayer)
         {
            this._hitLayer.width = param1;
         }
      }
      
      public function getWidth() : int
      {
         if(this._hitLayer)
         {
            return this._hitLayer.width;
         }
         if(this._normal)
         {
            return this._normal.width;
         }
         if(this._over)
         {
            return this._over.width;
         }
         if(this._active)
         {
            return this._active.width;
         }
         return int.MAX_VALUE;
      }
      
      public function setHeight(param1:uint) : void
      {
         if(this._normal)
         {
            this._normal.height = param1;
         }
         if(this._over)
         {
            this._over.height = param1;
         }
         if(this._active)
         {
            this._active.height = param1;
         }
         if(this._label)
         {
            this.centerTextVertically(param1);
         }
         if(this._hitLayer)
         {
            this._hitLayer.height = param1;
         }
      }
      
      public function getHeight() : int
      {
         if(this._hitLayer)
         {
            return this._hitLayer.height;
         }
         if(this._normal)
         {
            return this._normal.height;
         }
         if(this._over)
         {
            return this._over.height;
         }
         if(this._active)
         {
            return this._active.height;
         }
         return int.MAX_VALUE;
      }
      
      public function set resizedWidthCallback(param1:Function) : void
      {
         this._resizedWidthCallback = param1;
      }
   }
}

