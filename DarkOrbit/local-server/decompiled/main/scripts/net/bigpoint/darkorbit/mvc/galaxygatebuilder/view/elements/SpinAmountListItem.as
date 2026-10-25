package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.elements
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import net.bigpoint.darkorbit.Styles;
   
   public class SpinAmountListItem extends Sprite
   {
      
      private var _value:int;
      
      private var _text:String;
      
      private var bg:Shape;
      
      private var labelTxt:TextField;
      
      public function SpinAmountListItem(param1:int, param2:String)
      {
         super();
         this._value = param1;
         this._text = param2;
         this.bg = new Shape();
         addChild(this.bg);
         this.labelTxt = new TextField();
         this.labelTxt.defaultTextFormat = Styles.spinAmountItemFmt;
         this.labelTxt.embedFonts = Styles.spinAmountItemEmbed;
         this.labelTxt.height = Styles.centeredSmallFontHeight + 6;
         this.labelTxt.width = 165;
         this.labelTxt.antiAliasType = AntiAliasType.ADVANCED;
         this.labelTxt.selectable = false;
         this.labelTxt.mouseEnabled = false;
         this.labelTxt.text = this._text;
         addChild(this.labelTxt);
         this.labelTxt.x = 10;
         this.labelTxt.y = 1;
         this.bg.graphics.beginFill(3100005);
         this.bg.graphics.drawRect(1,0,this.labelTxt.x + this.labelTxt.width - 2,this.labelTxt.y + this.labelTxt.height + this.labelTxt.y);
         this.bg.graphics.endFill();
         this.init();
      }
      
      private function init() : void
      {
         this.bg.alpha = 0;
         buttonMode = true;
         addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         this.bg.alpha = 0;
         this.labelTxt.textColor = 8421504;
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         this.bg.alpha = 1;
         this.labelTxt.textColor = 16777215;
      }
      
      public function get value() : int
      {
         return this._value;
      }
      
      public function get text() : String
      {
         return this._text;
      }
   }
}

