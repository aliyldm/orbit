package net.bigpoint.darkorbit.gui.elements
{
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.Styles;
   
   public class TextFieldElement extends SimpleElement
   {
      
      private var _textField:TextField;
      
      private var _tfWidth:int;
      
      private var _tfHeight:int;
      
      private var text:String;
      
      private var align:String;
      
      private var format:TextFormat;
      
      private var border:Boolean;
      
      public function TextFieldElement(param1:int, param2:int, param3:TextFormat, param4:String = null, param5:String = "center", param6:Boolean = false)
      {
         super(SimpleElement.TYPE_TEXT);
         this._tfWidth = param1;
         this._tfHeight = param2;
         this.format = param3;
         this.text = param4;
         this.align = param5;
         this.border = param6;
         this.init();
      }
      
      public function init() : void
      {
         this.format.align = this.align;
         this._textField = new TextField();
         this._textField.defaultTextFormat = this.format;
         this._textField.embedFonts = Styles.simpleEmbed;
         this._textField.wordWrap = true;
         this._textField.antiAliasType = AntiAliasType.ADVANCED;
         this.setTextWidth();
         this.setTextHeight();
         this._textField.border = this.border;
         this._textField.selectable = false;
         if(this.text != null)
         {
            this._textField.text = this.text;
         }
         this.addChild(this._textField);
      }
      
      private function setTextHeight() : void
      {
         this._textField.height = this._tfHeight;
      }
      
      private function setTextWidth() : void
      {
         this._textField.width = this._tfWidth;
      }
      
      public function updateText(param1:String) : void
      {
         this._textField.text = param1;
      }
      
      public function get textField() : TextField
      {
         return this._textField;
      }
      
      public function set tfHeight(param1:int) : void
      {
         if(param1 != this._tfHeight)
         {
            this._tfHeight = param1;
            this.setTextHeight();
         }
      }
      
      public function set tfWidth(param1:int) : void
      {
         if(param1 != this._tfWidth)
         {
            this._tfWidth = param1;
            this.setTextWidth();
         }
      }
   }
}

