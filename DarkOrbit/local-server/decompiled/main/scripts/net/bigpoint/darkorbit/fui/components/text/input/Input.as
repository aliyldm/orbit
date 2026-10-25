package net.bigpoint.darkorbit.fui.components.text.input
{
   import flash.events.Event;
   import flash.events.FocusEvent;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.skins.ISkin;
   import net.bigpoint.darkorbit.fui.components.text.input.validators.IInputValidator;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.text.label.LabelSkin;
   
   public class Input extends Label
   {
      
      private var _inputValidator:IInputValidator;
      
      private var _inputValidationActicity:Boolean = false;
      
      public function Input()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         invalidate(InvalidationType.TEXT);
      }
      
      override protected function drawText() : void
      {
         var _loc1_:InputSkin = null;
         if(_skin)
         {
            _loc1_ = _skin as InputSkin;
            _loc1_.useHTML = _useHTML;
            _loc1_.textStyleName = _textStyleName;
            _loc1_.text = _text;
            _loc1_.textField.addEventListener(Event.CHANGE,this.handleTextChanged);
            this._setValidationTarget();
            this.validateInput();
         }
      }
      
      override public function set skin(param1:ISkin) : void
      {
         super.skin = param1;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      override protected function addEventListeners() : void
      {
         super.addEventListeners();
         this.addEventListener(Event.CHANGE,this.handleTextChanged);
         this.addEventListener(FocusEvent.FOCUS_IN,this.handleFocusInEvent);
         this.addEventListener(FocusEvent.FOCUS_OUT,this.handleFocusOutEvent);
      }
      
      override protected function removeEventListeners() : void
      {
         this.removeEventListener(FocusEvent.FOCUS_IN,this.handleFocusInEvent);
         this.removeEventListener(FocusEvent.FOCUS_OUT,this.handleFocusInEvent);
         this.removeEventListener(Event.CHANGE,this.handleTextChanged);
         super.removeEventListeners();
      }
      
      protected function handleTextChanged(param1:Event) : void
      {
         _text = (_skin as InputSkin).textField.text;
         this.validateInput();
      }
      
      protected function handleFocusInEvent(param1:FocusEvent) : void
      {
         UISystem.getInstance().focusManager.setComponentFocus(this);
         if(tooltipTemplateID)
         {
            UISystem.getInstance().tooltipManager.attemptToRemoveTooltip();
         }
         this._inputValidationActicity = true;
         this.validateInput();
      }
      
      protected function handleFocusOutEvent(param1:FocusEvent) : void
      {
         this._activateInputValidState();
         this._inputValidationActicity = false;
      }
      
      override public function setFocus() : void
      {
         var _loc2_:String = null;
         var _loc1_:InputSkin = _skin as InputSkin;
         if(_loc1_)
         {
            _loc2_ = _loc1_.textField.text;
            if(_loc2_ != null && _loc1_.textField.stage != null)
            {
               _loc1_.textField.setSelection(_loc2_.length,_loc2_.length);
               _loc1_.textField.stage.focus = _loc1_.textField;
            }
         }
      }
      
      override public function unfocus() : void
      {
      }
      
      public function validateInput() : Boolean
      {
         if(!this._inputValidationActicity)
         {
            return true;
         }
         var _loc1_:Boolean = false;
         if(this._inputValidator)
         {
            _loc1_ = this._inputValidator.isValid();
            if(_loc1_)
            {
               this._activateInputValidState();
            }
            else
            {
               this._activateInputInvalidState();
            }
         }
         return _loc1_;
      }
      
      public function set validator(param1:IInputValidator) : void
      {
         if(this._inputValidator)
         {
            this._inputValidator.dispose();
         }
         this._inputValidator = param1;
         this._setValidationTarget();
      }
      
      public function get validator() : IInputValidator
      {
         return this._inputValidator;
      }
      
      protected function _setValidationTarget() : void
      {
         if(Boolean(_skin) && Boolean(this._inputValidator))
         {
            this._inputValidator.source = (_skin as InputSkin).textField;
         }
      }
      
      protected function _activateInputValidState() : void
      {
         if(!_skin)
         {
         }
         dispatchEvent(new InputEvent(InputEvent.INPUT_IS_VALID));
      }
      
      protected function _activateInputInvalidState() : void
      {
         if(!_skin)
         {
         }
         dispatchEvent(new InputEvent(InputEvent.INPUT_IS_INVALID));
      }
      
      public function selectText() : void
      {
         var _loc1_:LabelSkin = null;
         if(_skin)
         {
            _loc1_ = _skin as LabelSkin;
            _loc1_.textField.setSelection(0,_loc1_.textField.text.length);
         }
      }
   }
}

