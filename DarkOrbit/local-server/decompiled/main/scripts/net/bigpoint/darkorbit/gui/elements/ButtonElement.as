package net.bigpoint.darkorbit.gui.elements
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.Styles;
   
   public class ButtonElement extends SimpleElement
   {
      
      private var _type:int;
      
      private var label:String;
      
      public var buttonContainer:MovieClip;
      
      private var buttonMC:MovieClip;
      
      private var textField:TextField;
      
      private var format:TextFormat;
      
      private var embedFonts:Boolean;
      
      private var hitLayer:Sprite;
      
      public function ButtonElement(param1:int, param2:String, param3:MovieClip, param4:TextFormat = null)
      {
         super(SimpleElement.TYPE_SIMPLE_BUTTON);
         this._type = param1;
         this.label = param2;
         this.embedFonts = Styles.baseEmbed;
         this.buttonContainer = param3;
         this.buttonMC = param3["buttonMC"];
         if(param4 == null)
         {
            this.format = Styles.plainStdFmt;
         }
         else
         {
            this.format = param4;
         }
         this.init();
      }
      
      public function set icon(param1:DisplayObject) : void
      {
         while(this.buttonMC.icon.numChildren > 0)
         {
            this.buttonMC.icon.removeChildAt(0);
         }
         if(param1 != null)
         {
            this.buttonMC.icon.addChild(param1);
            param1.name = "icon";
         }
      }
      
      private function init() : void
      {
         this.createButtonContainer();
         this.createTextfield();
         this.createHitLayer();
      }
      
      private function createButtonContainer() : void
      {
         this.buttonContainer.buttonMode = true;
         this.buttonMC.gotoAndStop(1);
         this.addChild(this.buttonContainer);
      }
      
      private function createTextfield() : void
      {
         this.textField = new TextField();
         this.textField.antiAliasType = AntiAliasType.ADVANCED;
         this.textField.defaultTextFormat = new TextFormat(this.format.font,this.format.size,16777215);
         this.textField.embedFonts = this.embedFonts;
         this.textField.mouseEnabled = false;
         this.buttonContainer.addChild(this.textField);
         this.labelText = this.label;
      }
      
      protected function createHitLayer() : void
      {
         this.hitLayer = new Sprite();
         var _loc1_:Graphics = this.hitLayer.graphics;
         _loc1_.clear();
         _loc1_.beginFill(65280,0);
         _loc1_.drawRect(0,0,this.buttonContainer.width,this.buttonContainer.height);
         _loc1_.endFill();
         this.addChild(this.hitLayer);
         this.addButtonListeners();
      }
      
      public function set labelText(param1:String) : void
      {
         this.textField.text = param1;
         this.textField.autoSize = TextFieldAutoSize.LEFT;
         this.textField.x = 2;
         this.textField.y = 2;
         this.textField.width += 2;
         this.textField.height = int(this.format.size) + 5;
         this.buttonMC.width = this.textField.width + 5;
         this.buttonMC.height = int(this.format.size) + 9;
      }
      
      public function changeTextColour(param1:uint) : void
      {
         this.textField.textColor = param1;
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         if(this.buttonMC.currentFrame == 1)
         {
            this.buttonMC.gotoAndStop(2);
         }
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         if(this.buttonMC.currentFrame == 2)
         {
            this.buttonMC.gotoAndStop(1);
         }
      }
      
      public function setType(param1:int) : void
      {
         this._type = param1;
      }
      
      public function getType() : int
      {
         return this._type;
      }
      
      public function cleanup() : void
      {
         this.removeButtonListeners();
      }
      
      public function addButtonListeners() : void
      {
         this.hitLayer.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.hitLayer.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      public function removeButtonListeners() : void
      {
         this.hitLayer.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.hitLayer.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      public function setDisableStatus() : void
      {
         this.buttonMC.gotoAndStop(2);
      }
      
      public function setEnableStatus() : void
      {
         this.buttonMC.gotoAndStop(1);
      }
      
      public function setTextPosY(param1:int) : void
      {
         this.textField.y = param1;
      }
      
      override public function set width(param1:Number) : void
      {
         this.buttonMC.width = param1;
         this.hitLayer.width = param1;
         if(this.textField.width < param1 - 5)
         {
            this.textField.x = (param1 - this.textField.width) * 0.5;
         }
      }
      
      override public function set height(param1:Number) : void
      {
         this.buttonMC.height = param1;
         this.hitLayer.height = param1;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(param1)
         {
            this.buttonMC.gotoAndStop(3);
         }
         else
         {
            this.buttonMC.gotoAndStop(1);
         }
      }
      
      public function setButtonMode(param1:Boolean) : void
      {
         this.buttonContainer.buttonMode = param1;
      }
   }
}

