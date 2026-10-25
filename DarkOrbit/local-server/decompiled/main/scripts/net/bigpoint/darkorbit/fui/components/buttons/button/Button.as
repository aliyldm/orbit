package net.bigpoint.darkorbit.fui.components.buttons.button
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.skins.SkinLayerNames;
   import net.bigpoint.darkorbit.fui.components.text.IText;
   import net.bigpoint.darkorbit.fui.system.utils.selector.IMultiSelector;
   
   public class Button extends Coreponent implements IText
   {
      
      private var _clicked:Boolean = false;
      
      private var _text:String;
      
      private var _textStyleName:String;
      
      private var _textMarginX:uint = 0;
      
      private var _textMarginY:uint = 0;
      
      public function Button()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         _mouseEnabled = true;
         _mouseChildrenEnabled = false;
         this.tabEnabled = false;
         super.initialize();
      }
      
      override protected function draw() : void
      {
         super.draw();
         if(isInvalidate(InvalidationType.TEXT))
         {
            this.drawText();
         }
         validate(InvalidationType.TEXT);
      }
      
      protected function drawText() : void
      {
         var _loc1_:IButtonSkin = null;
         if(_skin)
         {
            _loc1_ = _skin as IButtonSkin;
            if(this._textStyleName)
            {
               _loc1_.textStyleName = this._textStyleName;
            }
            _loc1_.textMarginX = this._textMarginX;
            _loc1_.textMarginY = this._textMarginY;
            if(this._text)
            {
               _loc1_.text = this._text;
            }
         }
      }
      
      public function set textMarginX(param1:uint) : void
      {
         if(this._textMarginX != param1)
         {
            this._textMarginX = param1;
            invalidate(InvalidationType.TEXT);
         }
      }
      
      public function set textMarginY(param1:uint) : void
      {
         if(this._textMarginY != param1)
         {
            this._textMarginY = param1;
            invalidate(InvalidationType.TEXT);
         }
      }
      
      public function set text(param1:String) : void
      {
         if(this._text != param1)
         {
            this._text = param1;
            if(this._text == null)
            {
               this._text = "";
            }
            invalidate(InvalidationType.TEXT);
         }
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set localizedText(param1:String) : void
      {
         this._text = UISystem.localize(param1);
         invalidate(InvalidationType.TEXT);
      }
      
      public function set registeredTextStyleName(param1:String) : void
      {
         this._textStyleName = param1;
         invalidate(InvalidationType.SKIN);
      }
      
      override protected function addEventListeners() : void
      {
         super.addEventListeners();
         addEventListener(MouseEvent.MOUSE_DOWN,this.handleButtonDown);
         addEventListener(MouseEvent.MOUSE_UP,this.handleButtonUp);
         addEventListener(MouseEvent.CLICK,this.handleButtonClicked);
      }
      
      override protected function removeEventListeners() : void
      {
         super.removeEventListeners();
         removeEventListener(MouseEvent.MOUSE_DOWN,this.handleButtonDown);
         removeEventListener(MouseEvent.MOUSE_UP,this.handleButtonUp);
         removeEventListener(MouseEvent.CLICK,this.handleButtonClicked);
      }
      
      override protected function handleButtonRollover(param1:MouseEvent) : void
      {
         super.handleButtonRollover(param1);
         if(!isEnabled() || this.skin == null)
         {
            return;
         }
         if(!this._clicked)
         {
            this.setSkinState(SkinLayerNames.OVER);
         }
      }
      
      override protected function handleButtonRollout(param1:MouseEvent) : void
      {
         super.handleButtonRollout(param1);
         if(!isEnabled() || this.skin == null)
         {
            return;
         }
         if(!this._clicked)
         {
            this.setSkinState(SkinLayerNames.NORMAL);
         }
      }
      
      protected function handleButtonDown(param1:MouseEvent) : void
      {
         if(!isEnabled() || this.skin == null)
         {
            return;
         }
         this._clicked = true;
         this.activateMultiSelector = false;
         stage.addEventListener(MouseEvent.MOUSE_UP,this.handleStageUp);
         this.setSkinState(SkinLayerNames.CLICKED);
      }
      
      protected function handleButtonUp(param1:MouseEvent) : void
      {
         if(!isEnabled() || this.skin == null)
         {
            return;
         }
         this._clicked = false;
         this.activateMultiSelector = true;
         this.setSkinState(SkinLayerNames.OVER);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleStageUp);
      }
      
      protected function handleButtonClicked(param1:MouseEvent) : void
      {
         if(!isEnabled() || this.skin == null)
         {
            param1.stopImmediatePropagation();
            return;
         }
      }
      
      protected function handleStageUp(param1:MouseEvent) : void
      {
         if(!isEnabled() || this.skin == null)
         {
            return;
         }
         this._clicked = false;
         this.activateMultiSelector = false;
         this.setSkinState(SkinLayerNames.NORMAL);
         (param1.target as DisplayObject).stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleStageUp);
      }
      
      protected function set activateMultiSelector(param1:Boolean) : void
      {
         var _loc2_:IMultiSelector = UISystem.getInstance().multiSelector;
         if(_loc2_)
         {
            if(param1)
            {
               _loc2_.start();
            }
            else
            {
               _loc2_.stop();
            }
         }
      }
   }
}

