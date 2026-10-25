package net.bigpoint.darkorbit.fui.builder.repository
{
   import flash.filters.ColorMatrixFilter;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.AntiAliasType;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class TextStyleVO
   {
      
      public static const DROP_SHADOW_FILTER:DropShadowFilter = new DropShadowFilter(1,0,0,0.9,4,4);
      
      private var _name:String;
      
      private var _align:String = "left";
      
      private var _glowFilter:GlowFilter;
      
      private var _dropShadow:DropShadowFilter;
      
      private var _textFormat:TextFormat = new TextFormat("Arial",12);
      
      private var _antiAliasType:String = "advanced";
      
      private var _autoSize:String;
      
      private var _bold:Boolean = false;
      
      private var _background:Boolean = false;
      
      private var _backgroundColor:uint = 4473924;
      
      private var _border:Boolean = false;
      
      private var _borderColor:uint = 4473924;
      
      private var _embedFonts:Boolean = true;
      
      private var _fontName:String;
      
      private var _fontSize:uint;
      
      private var _marginLeft:int = 2147483647;
      
      private var _marginRight:int = 2147483647;
      
      private var _multiline:Boolean = false;
      
      private var _selectable:Boolean = false;
      
      private var _textColor:uint = 14606079;
      
      private var _type:String = "dynamic";
      
      private var _wordWrap:Boolean = false;
      
      private var _styleSheet:StyleSheet;
      
      private var _selectionTextColor:int = -1;
      
      private var _maxChars:uint = 0;
      
      private var _underline:Boolean;
      
      public function TextStyleVO(param1:String, param2:TextFormat = null)
      {
         super();
         this._name = param1;
         if(param2)
         {
            this._textFormat = param2;
         }
      }
      
      private static function splitRGB(param1:uint) : Array
      {
         return [param1 >> 16 & 0xFF,param1 >> 8 & 0xFF,param1 & 0xFF];
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get align() : String
      {
         return this._align;
      }
      
      public function set align(param1:String) : void
      {
         this._align = param1;
      }
      
      public function get glowFilter() : GlowFilter
      {
         return this._glowFilter;
      }
      
      public function set glowFilter(param1:GlowFilter) : void
      {
         this._glowFilter = param1;
      }
      
      public function get dropShadow() : DropShadowFilter
      {
         return this._dropShadow;
      }
      
      public function set dropShadow(param1:DropShadowFilter) : void
      {
         this._dropShadow = param1;
      }
      
      public function set textFormat(param1:TextFormat) : void
      {
         this._textFormat = param1;
      }
      
      public function set antiAliasType(param1:String) : void
      {
         this._antiAliasType = param1;
      }
      
      public function get autoSize() : String
      {
         return this._autoSize;
      }
      
      public function set autoSize(param1:String) : void
      {
         this._autoSize = param1;
      }
      
      public function get bold() : Boolean
      {
         return this._bold;
      }
      
      public function set bold(param1:Boolean) : void
      {
         this._bold = param1;
      }
      
      public function set background(param1:Boolean) : void
      {
         this._background = param1;
      }
      
      public function set backgroundColor(param1:uint) : void
      {
         this._backgroundColor = param1;
      }
      
      public function set border(param1:Boolean) : void
      {
         this._border = param1;
      }
      
      public function set borderColor(param1:uint) : void
      {
         this._borderColor = param1;
      }
      
      public function set embedFonts(param1:Boolean) : void
      {
         this._embedFonts = param1;
      }
      
      public function get fontName() : String
      {
         return this._fontName;
      }
      
      public function set fontName(param1:String) : void
      {
         this._fontName = param1;
      }
      
      public function get fontSize() : uint
      {
         return this._fontSize;
      }
      
      public function set fontSize(param1:uint) : void
      {
         this._fontSize = param1;
      }
      
      public function set marginLeft(param1:int) : void
      {
         this._marginLeft = param1;
      }
      
      public function set marginRight(param1:int) : void
      {
         this._marginRight = param1;
      }
      
      public function set multiline(param1:Boolean) : void
      {
         this._multiline = param1;
      }
      
      public function get selectable() : Boolean
      {
         return this._selectable;
      }
      
      public function set selectable(param1:Boolean) : void
      {
         this._selectable = param1;
      }
      
      public function get textColor() : uint
      {
         return this._textColor;
      }
      
      public function set textColor(param1:uint) : void
      {
         this._textColor = param1;
      }
      
      public function set type(param1:String) : void
      {
         this._type = param1;
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         this._wordWrap = param1;
      }
      
      public function set styleSheet(param1:StyleSheet) : void
      {
         this._styleSheet = param1;
      }
      
      public function set selectionTextColor(param1:uint) : void
      {
         this._selectionTextColor = param1;
      }
      
      public function set maxChars(param1:uint) : void
      {
         this._maxChars = param1;
      }
      
      public function get underline() : Boolean
      {
         return this._underline;
      }
      
      public function set underline(param1:Boolean) : void
      {
         this._underline = param1;
      }
      
      public function assign(param1:TextField) : void
      {
         param1.antiAliasType = this._antiAliasType;
         param1.autoSize = this._autoSize ? this._autoSize : param1.autoSize;
         param1.background = this._background;
         param1.backgroundColor = this._backgroundColor;
         param1.border = this._border;
         param1.borderColor = this._borderColor;
         param1.embedFonts = this._embedFonts;
         param1.multiline = this._multiline;
         param1.selectable = this._selectable;
         param1.textColor = this._textColor;
         param1.type = this._type;
         param1.wordWrap = this._wordWrap;
         if(this._maxChars > 0)
         {
            param1.maxChars = this._maxChars;
         }
         if(this._fontName)
         {
            this._textFormat.font = this._fontName;
         }
         if(this._fontSize)
         {
            this._textFormat.size = this._fontSize;
         }
         if(this._marginLeft != int.MAX_VALUE)
         {
            this._textFormat.leftMargin = this._marginLeft;
         }
         if(this._marginRight != int.MAX_VALUE)
         {
            this._textFormat.rightMargin = this._marginRight;
         }
         if(this._align)
         {
            this._textFormat.align = this._align;
         }
         this._textFormat.bold = this._bold;
         this._textFormat.underline = this._underline;
         param1.defaultTextFormat = this._textFormat;
         if(this._styleSheet)
         {
            param1.styleSheet = this._styleSheet;
         }
         var _loc2_:Array = new Array();
         if(this._selectionTextColor >= 0)
         {
            _loc2_ = this._setSelectionTextColor(param1);
         }
         if(this._dropShadow)
         {
            param1.antiAliasType = AntiAliasType.ADVANCED;
            _loc2_.push(this._dropShadow);
         }
         if(this._glowFilter)
         {
            _loc2_.push(this._glowFilter);
         }
         param1.filters = _loc2_;
      }
      
      public function equals(param1:TextStyleVO) : Boolean
      {
         return !(this._align != param1._align || this._antiAliasType != param1._antiAliasType || this._autoSize != param1._autoSize || this._background != param1._background || this._backgroundColor != param1._backgroundColor || this._border != param1._border || this._borderColor != param1._borderColor || this._embedFonts != param1._embedFonts || this._fontName != param1._fontName || this._fontSize != param1._fontSize || this._marginLeft != param1._marginLeft || this._marginRight != param1._marginRight || this._maxChars != param1._maxChars || this._multiline != param1._multiline || this._name != param1._name || this._selectable != param1._selectable || this._selectionTextColor != param1._selectionTextColor || this._textColor != param1._textColor || this._type != param1._type || this._wordWrap != param1._wordWrap || this._bold != param1._bold || this._glowFilter != param1.glowFilter || this._dropShadow != param1._dropShadow);
      }
      
      private function _setSelectionTextColor(param1:TextField) : Array
      {
         var _loc2_:int = this._selectionTextColor;
         var _loc3_:int = int(param1.textColor);
         var _loc4_:int = _loc3_ & 0xFF;
         var _loc5_:int = _loc2_ & 0xFF;
         var _loc6_:int = int((_loc5_ - _loc4_) * 100 / 255);
         _loc2_ >>= 8;
         _loc3_ >>= 8;
         var _loc7_:int = _loc3_ & 0xFF;
         var _loc8_:int = _loc2_ & 0xFF;
         var _loc9_:int = int((_loc8_ - _loc7_) * 100 / 255);
         _loc2_ >>= 8;
         _loc3_ >>= 8;
         var _loc10_:int = _loc3_ & 0xFF;
         var _loc11_:int = _loc2_ & 0xFF;
         var _loc12_:int = int((_loc11_ - _loc10_) * 100 / 255);
         var _loc13_:ColorMatrixFilter = new ColorMatrixFilter();
         _loc13_.matrix = [_loc12_ * 0.01,0,0,0,_loc10_,0,_loc9_ * 0.01,0,0,_loc7_,0,0,_loc6_ * 0.01,0,_loc4_,0,0,0,1,0];
         var _loc14_:Array = [_loc13_];
         param1.filters = [_loc13_];
         param1.textColor = 0;
         if(param1.background)
         {
            param1.backgroundColor = 16777215;
         }
         return _loc14_;
      }
   }
}

