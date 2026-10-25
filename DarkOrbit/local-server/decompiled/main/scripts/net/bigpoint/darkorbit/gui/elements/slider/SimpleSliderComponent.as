package net.bigpoint.darkorbit.gui.elements.slider
{
   import fl.controls.Slider;
   import fl.controls.SliderDirection;
   import fl.events.SliderEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   
   public class SimpleSliderComponent extends SimpleElement
   {
      
      public static const SLIDER_GAP:int = 20;
      
      public static const SLIDER_WIDTH:int = 350;
      
      private var _typeID:int;
      
      private var _labelKey:String;
      
      private var _slider:Slider;
      
      private var _currentValueTxt:TextField;
      
      public function SimpleSliderComponent(param1:int, param2:String, param3:Function)
      {
         super(SimpleElement.TYPE_SIMPLESLIDER);
         this._typeID = param1;
         this._labelKey = param2;
         this.init();
         this._slider.addEventListener(SliderEvent.CHANGE,param3);
         this._slider.addEventListener(SliderEvent.THUMB_DRAG,param3);
      }
      
      private function init() : void
      {
         var _loc1_:TextField = new TextField();
         _loc1_.selectable = false;
         _loc1_.defaultTextFormat = Styles.strongStdFmt;
         _loc1_.textColor = 16777215;
         _loc1_.text = BPLocale.getItem(this._labelKey);
         _loc1_.border = false;
         _loc1_.embedFonts = Styles.strongStdEmbed;
         _loc1_.autoSize = TextFieldAutoSize.LEFT;
         _loc1_.antiAliasType = AntiAliasType.ADVANCED;
         _loc1_.height = Styles.strongStdFontHeight + 6;
         _loc1_.y = 0;
         addChild(_loc1_);
         this._currentValueTxt = new TextField();
         this._currentValueTxt.selectable = false;
         this._currentValueTxt.defaultTextFormat = Styles.strongStdFmt;
         this._currentValueTxt.textColor = 15327936;
         this._currentValueTxt.border = false;
         this._currentValueTxt.embedFonts = Styles.strongStdEmbed;
         this._currentValueTxt.autoSize = TextFieldAutoSize.LEFT;
         this._currentValueTxt.antiAliasType = AntiAliasType.ADVANCED;
         this._currentValueTxt.height = Styles.strongStdFontHeight + 6;
         this._currentValueTxt.x = _loc1_.width + 10;
         this._currentValueTxt.y = 0;
         addChild(this._currentValueTxt);
         this._slider = new Slider();
         this._slider.direction = SliderDirection.HORIZONTAL;
         this._slider.move(SLIDER_GAP,_loc1_.height + 20);
         this._slider.setSize(SLIDER_WIDTH,10);
         this._slider.maximum = 100;
         this._slider.minimum = 0;
         this._slider.snapInterval = 1;
         this._slider.name = this._typeID.toString();
         addChild(this._slider);
      }
      
      public function setSliderValue(param1:int) : void
      {
         this._slider.value = param1;
      }
   }
}

