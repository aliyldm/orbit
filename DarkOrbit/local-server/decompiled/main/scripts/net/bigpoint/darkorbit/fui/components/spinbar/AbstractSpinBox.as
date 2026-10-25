package net.bigpoint.darkorbit.fui.components.spinbar
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.skins.SkinLayerNames;
   import net.bigpoint.darkorbit.fui.components.text.input.Input;
   import net.bigpoint.darkorbit.fui.components.text.input.InputEvent;
   import net.bigpoint.darkorbit.fui.components.text.input.validators.RegularExpressionInputValidator;
   import net.bigpoint.darkorbit.fui.system.utils.displayobject.DisplayObjectMarker;
   
   public class AbstractSpinBox extends Container
   {
      
      public static const SUFFIX_PERCENTAGE:String = "%";
      
      protected static const DEFAULT_REGEXP:RegExp = /^[0-9]*$/i;
      
      protected static const DEFAULT_TEMPLATE_NAME:String = "commonui.spinbox.horizontal.arrows";
      
      protected var _regexp:RegExp = DEFAULT_REGEXP;
      
      protected var _value:Number = 1;
      
      protected var _minimum:Number = 1;
      
      protected var _maximum:Number = 10;
      
      protected var _singleStep:Number = 1;
      
      protected var _suffix:String = "";
      
      protected var _decreaseButton:Button;
      
      protected var _increaseButton:Button;
      
      protected var _valueInput:Input;
      
      private var _inputEnabled:Boolean = true;
      
      protected var _templateName:String;
      
      public function AbstractSpinBox()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.templateName = DEFAULT_TEMPLATE_NAME;
      }
      
      override protected function draw() : void
      {
         if(isInvalidate(InvalidationType.TEMPLATE))
         {
            this.buildSubcomponents();
            validate(InvalidationType.TEMPLATE);
         }
         super.draw();
      }
      
      override protected function drawSkin() : void
      {
         super.drawSkin();
         this._updateLabel();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._decreaseButton)
         {
            this._decreaseButton.removeEventListener(MouseEvent.CLICK,this.handleDecreaseButtonClicked);
         }
         if(this._increaseButton)
         {
            this._increaseButton.removeEventListener(MouseEvent.CLICK,this.handleIncreaseButtonClicked);
         }
         if(this._valueInput)
         {
            this._valueInput.removeEventListener(MouseEvent.CLICK,this.hadleValueInputClick);
            this._valueInput.removeEventListener(InputEvent.INPUT_IS_VALID,this.handleInputIsValid);
            this._valueInput.removeEventListener(InputEvent.INPUT_IS_INVALID,this.handleInputIsInvalid);
         }
         this._decreaseButton = null;
         this._increaseButton = null;
         this._valueInput = null;
      }
      
      private function hadleValueInputClick(param1:MouseEvent) : void
      {
         this._valueInput.selectText();
      }
      
      protected function buildSubcomponents() : void
      {
         this.removeAllCoreponents();
         UISystem.getInstance().buildByTemplate(this._templateName,this);
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._decreaseButton = this.getChildByName("decreaseButton") as Button;
         if(this._decreaseButton)
         {
            this.initDecreaseButton();
         }
         this._increaseButton = this.getChildByName("increaseButton") as Button;
         if(this._increaseButton)
         {
            this.initIncreaseButton();
         }
         this._valueInput = this.getChildByName("valueInput") as Input;
         if(this._valueInput)
         {
            this.initValueInput();
         }
         this.minimum = this._minimum;
         this.maximum = this._maximum;
         this.value = this._minimum;
         this._updateLabel();
      }
      
      protected function initDecreaseButton() : void
      {
         this.updateButton();
         this._decreaseButton.addEventListener(MouseEvent.CLICK,this.handleDecreaseButtonClicked);
      }
      
      protected function initIncreaseButton() : void
      {
         this.updateButton();
         this._increaseButton.addEventListener(MouseEvent.CLICK,this.handleIncreaseButtonClicked);
      }
      
      protected function initValueInput() : void
      {
         this._valueInput.validator = new RegularExpressionInputValidator(DEFAULT_REGEXP,0,100);
         this._valueInput.addEventListener(InputEvent.INPUT_IS_VALID,this.handleInputIsValid);
         this._valueInput.addEventListener(InputEvent.INPUT_IS_INVALID,this.handleInputIsValid);
         this._valueInput.addEventListener(MouseEvent.CLICK,this.hadleValueInputClick);
         this._valueInput.restrict = "0-9";
         this.handleValueInputEnabledChanged();
      }
      
      private function handleValueInputEnabledChanged() : void
      {
         if(this._valueInput)
         {
            this._valueInput.mouseEnabled = this._valueInput.mouseChildren = this._inputEnabled;
         }
      }
      
      public function set templateName(param1:String) : void
      {
         if(this._templateName != param1)
         {
            this._templateName = param1;
            invalidate(InvalidationType.TEMPLATE);
         }
      }
      
      public function set minimum(param1:Number) : void
      {
         if(this._minimum != param1)
         {
            this._minimum = param1;
            this.clampValues();
            this._updateLabel();
            this.updateButton();
         }
      }
      
      private function clampValues() : void
      {
         this._value = Math.min(Math.max(this._value,this._minimum),this._maximum);
      }
      
      public function get minimum() : Number
      {
         return this._minimum;
      }
      
      public function set maximum(param1:Number) : void
      {
         if(this._maximum != param1)
         {
            this._maximum = param1;
            this.clampValues();
            this._updateLabel();
            this.updateButton();
         }
      }
      
      protected function getDigetCount(param1:Number) : Number
      {
         return param1.toString().length;
      }
      
      public function get maximum() : Number
      {
         return this._maximum;
      }
      
      public function setRange(param1:Number, param2:Number) : void
      {
         if(param1 < param2)
         {
            this.minimum = param1;
            this.maximum = param2;
            this._updateLabel();
            this.updateButton();
         }
      }
      
      public function set singleStep(param1:Number) : void
      {
         this._singleStep = param1;
      }
      
      public function get singleStep() : Number
      {
         return this._singleStep;
      }
      
      public function increaseOneStep() : void
      {
         var _loc1_:Number = this._value + this._singleStep;
         if(_loc1_ <= this._maximum)
         {
            this.value = _loc1_;
         }
      }
      
      public function decreaseOneStep() : void
      {
         var _loc1_:Number = this._value - this._singleStep;
         if(_loc1_ >= this._minimum)
         {
            this.value = _loc1_;
         }
      }
      
      public function set suffix(param1:String) : void
      {
         this._suffix = param1;
      }
      
      public function get suffix() : String
      {
         return this._suffix;
      }
      
      public function set value(param1:Number) : void
      {
         if(param1 != this._value)
         {
            this._value = param1;
            this.clampValues();
            this._updateLabel();
            this.updateButton();
            this._dispatchValueChangedEvent();
         }
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      protected function _updateLabel() : void
      {
         var _loc1_:String = this._value.toString();
         if(this._suffix)
         {
            if(this._suffix.length > 0)
            {
               _loc1_ += this._suffix;
            }
         }
         if(this._valueInput)
         {
            this._valueInput.text = _loc1_;
         }
      }
      
      protected function _dispatchValueChangedEvent() : void
      {
         var _loc1_:SpinBoxEvent = new SpinBoxEvent(SpinBoxEvent.VALUE_CHANGED);
         _loc1_.value = this._value;
         dispatchEvent(_loc1_);
      }
      
      protected function handleDecreaseButtonClicked(param1:Event) : void
      {
         this.decreaseOneStep();
      }
      
      protected function handleIncreaseButtonClicked(param1:Event) : void
      {
         this.increaseOneStep();
      }
      
      protected function handleInputIsValid(param1:Event) : void
      {
         var _loc2_:DisplayObject = this._valueInput.skin.getSkinLayer(SkinLayerNames.NORMAL);
         DisplayObjectMarker.markRed(false,_loc2_);
         this.value = Number(this._valueInput.getDisplayedText());
      }
      
      protected function handleInputIsInvalid(param1:Event) : void
      {
         var _loc2_:DisplayObject = this._valueInput.skin.getSkinLayer(SkinLayerNames.NORMAL);
         DisplayObjectMarker.markRed(true,_loc2_);
      }
      
      public function get inputEnabled() : Boolean
      {
         return this._inputEnabled;
      }
      
      public function set inputEnabled(param1:Boolean) : void
      {
         this._inputEnabled = param1;
         this.handleValueInputEnabledChanged();
      }
      
      private function updateButton() : void
      {
         if(this._decreaseButton == null || this._increaseButton == null)
         {
            return;
         }
         this._decreaseButton.enabled = isEnabled() && this._value > this._minimum;
         this._increaseButton.enabled = isEnabled() && this._value < this._maximum;
      }
   }
}

