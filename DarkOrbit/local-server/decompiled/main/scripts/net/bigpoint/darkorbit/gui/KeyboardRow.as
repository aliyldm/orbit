package net.bigpoint.darkorbit.gui
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.elements.ButtonElement;
   import net.bigpoint.darkorbit.gui.elements.ButtonElementTypes;
   import net.bigpoint.darkorbit.gui.elements.TextFieldElement;
   import net.bigpoint.darkorbit.managers.keyboardManager.KeyValuePair;
   import net.bigpoint.darkorbit.managers.keyboardManager.parser.KeyMappingUpdateParser;
   
   public class KeyboardRow extends Sprite
   {
      
      private var commandLabel:TextFieldElement;
      
      private var format:TextFormat;
      
      private var keyLable:TextFieldElement;
      
      private var button:ButtonElement;
      
      private var _keyValuePair:KeyValuePair = new KeyValuePair();
      
      public function KeyboardRow(param1:String, param2:String, param3:String, param4:Function, param5:MovieClip, param6:int)
      {
         var _loc8_:Number = NaN;
         super();
         var _loc7_:String = "";
         if(param3 != "" && !isNaN(Number(param3)))
         {
            _loc8_ = Number(param3);
            _loc8_ = _loc8_ + 1;
            if(_loc8_ >= 10)
            {
               _loc8_ = 0;
            }
            _loc7_ = _loc8_.toString();
         }
         this.format = new TextFormat(Styles.plainStdFmt.font,Styles.plainStdFontHeight,param6);
         this.commandLabel = new TextFieldElement(150,20,this.format,BPLocale.getItem(param1) + " " + _loc7_);
         this.commandLabel.x = 10;
         this.keyLable = new TextFieldElement(100,20,this.format,BPLocale.getItem("keyboard_key_undefined"));
         this.keyLable.x = this.commandLabel.x + this.commandLabel.width;
         this.button = new ButtonElement(ButtonElementTypes.TYPE_ADVANCED_SETTINGS,BPLocale.getItem("btn_change"),param5);
         this.button.x = 300;
         addEventListener(MouseEvent.CLICK,param4);
         addChild(this.commandLabel);
         addChild(this.keyLable);
         addChild(this.button);
         this._keyValuePair.args = new <String>[param3];
         this._keyValuePair.name = KeyMappingUpdateParser.commandNameLookup[int(param2)];
      }
      
      override public function get name() : String
      {
         return this._keyValuePair.toString();
      }
      
      public function get keyValuePair() : KeyValuePair
      {
         return this._keyValuePair;
      }
      
      public function set keyText(param1:String) : void
      {
         this.keyLable.textField.text = param1;
      }
      
      public function get keyText() : String
      {
         return this.keyLable.textField.text;
      }
   }
}

