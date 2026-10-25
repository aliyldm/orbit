package net.bigpoint.darkorbit.fui.components.text.label
{
   import flash.display.DisplayObject;
   import flash.events.TextEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.builder.repository.TextStyleRepository;
   import net.bigpoint.darkorbit.fui.builder.repository.TextStyleVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.skins.ISkin;
   import net.bigpoint.darkorbit.fui.components.text.IText;
   
   public class Label extends Coreponent implements IText
   {
      
      protected var _text:String;
      
      protected var _textStyleName:String;
      
      protected var _useHTML:Boolean;
      
      protected var _containsLink:Boolean = false;
      
      protected var _autoSizeTextContentHeight:Boolean = false;
      
      protected var _autoSizeTextContentWidth:Boolean = false;
      
      public function Label()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.skin = new LabelSkin();
      }
      
      override protected function draw() : void
      {
         if(isInvalidate(InvalidationType.TEXT))
         {
            this.drawText();
         }
         super.draw();
         if(isInvalidate(InvalidationType.TEXT))
         {
            drawPosition();
         }
         validate(InvalidationType.TEXT);
      }
      
      protected function drawText() : void
      {
         var _loc1_:LabelSkin = null;
         if(_skin)
         {
            _loc1_ = _skin as LabelSkin;
            _loc1_.autoSizeTextContentHeight = this._autoSizeTextContentHeight;
            _loc1_.autoSizeTextContentWidth = this._autoSizeTextContentWidth;
            _loc1_.useHTML = this._useHTML;
            _loc1_.textStyleName = this._textStyleName;
            _loc1_.text = this._text;
         }
      }
      
      public function set localizedText(param1:String) : void
      {
         this.text = UISystem.localize(param1);
      }
      
      override public function set skin(param1:ISkin) : void
      {
         var _loc2_:DisplayObject = null;
         if(_skin != null)
         {
            _loc2_ = _skin as DisplayObject;
            _loc2_.removeEventListener(LabelSkinEvent.SKIN_HEIGHT_CHANGED,this.handleSkinHeightChangedEvent);
         }
         super.skin = param1;
         (skin as DisplayObject).addEventListener(LabelSkinEvent.SKIN_HEIGHT_CHANGED,this.handleSkinHeightChangedEvent);
      }
      
      protected function handleSkinHeightChangedEvent(param1:LabelSkinEvent) : void
      {
         if(this.height != param1.value)
         {
            this.height = param1.value;
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:DisplayObject = null;
         if(_skin)
         {
            _loc1_ = _skin as DisplayObject;
            _loc1_.removeEventListener(LabelSkinEvent.SKIN_HEIGHT_CHANGED,this.handleSkinHeightChangedEvent);
         }
         this.removeEventLinkListener();
         super.dispose();
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
      
      public function set registeredTextStyleName(param1:String) : void
      {
         if(this._textStyleName != param1)
         {
            this._textStyleName = param1;
            invalidate(InvalidationType.TEXT);
         }
      }
      
      public function get registeredTextStyleVO() : TextStyleVO
      {
         return TextStyleRepository.getInstance().getByName(this._textStyleName);
      }
      
      public function getDisplayedText() : String
      {
         return (_skin as LabelSkin).textField.text;
      }
      
      public function set useHTML(param1:Boolean) : void
      {
         if(this._useHTML != param1)
         {
            this._useHTML = param1;
            invalidate(InvalidationType.TEXT);
         }
      }
      
      public function set restrict(param1:String) : void
      {
         (_skin as LabelSkin).textField.restrict = param1;
      }
      
      override public function getCalculatedWidth() : Number
      {
         var _loc1_:LabelSkin = _skin as LabelSkin;
         if(_loc1_ == null)
         {
            return 0;
         }
         if(_loc1_.autoSizeTextContentWidth)
         {
            return (_skin as LabelSkin).width;
         }
         if(_width == 0 && !_autoSizeWidth && _skin is LabelSkin)
         {
            return (_skin as LabelSkin).width;
         }
         return super.getCalculatedWidth();
      }
      
      override public function getCalculatedHeight() : Number
      {
         var _loc1_:LabelSkin = _skin as LabelSkin;
         if(_loc1_ == null)
         {
            return 0;
         }
         if(_loc1_.autoSizeTextContentHeight)
         {
            return (_skin as LabelSkin).height;
         }
         if(_height == 0 && !_autoSizeHeight && _skin is LabelSkin)
         {
            return (_skin as LabelSkin).height;
         }
         return super.getCalculatedHeight();
      }
      
      public function set autoSizeTextHeight(param1:Boolean) : void
      {
         this._autoSizeTextContentHeight = param1;
      }
      
      public function get autoSizeTextHeight() : Boolean
      {
         return this._autoSizeTextContentHeight;
      }
      
      public function set autoSizeTextWidth(param1:Boolean) : void
      {
         this._autoSizeTextContentWidth = param1;
      }
      
      public function get autoSizeTextWidth() : Boolean
      {
         return this._autoSizeTextContentWidth;
      }
      
      public function set containsLink(param1:Boolean) : void
      {
         this._containsLink = param1;
         this.validateTextEventLinkListener(this._containsLink);
      }
      
      public function get containsLink() : Boolean
      {
         return this._containsLink;
      }
      
      private function validateTextEventLinkListener(param1:Boolean) : void
      {
      }
      
      private function addTextEventLinkListener() : void
      {
         var _loc1_:TextField = LabelSkin(skin).textField;
         if(!_loc1_.hasEventListener(TextEvent.LINK))
         {
            _loc1_.addEventListener(TextEvent.LINK,this.textLinkHandler);
         }
      }
      
      private function removeEventLinkListener() : void
      {
         var _loc1_:TextField = LabelSkin(skin).textField;
         if(_loc1_.hasEventListener(TextEvent.LINK))
         {
            _loc1_.removeEventListener(TextEvent.LINK,this.textLinkHandler);
         }
      }
      
      protected function textLinkHandler(param1:TextEvent) : void
      {
         var _loc2_:String = param1.text;
         var _loc3_:URLRequest = new URLRequest(_loc2_);
      }
   }
}

