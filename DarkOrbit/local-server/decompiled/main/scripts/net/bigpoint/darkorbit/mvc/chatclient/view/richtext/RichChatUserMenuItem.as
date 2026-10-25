package net.bigpoint.darkorbit.mvc.chatclient.view.richtext
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class RichChatUserMenuItem extends Sprite
   {
      
      private static const COLOR_BORDER:uint = 39622;
      
      private static const COLOR_BORDER_OVER:uint = 52479;
      
      private static const COLOR_FILL:uint = 404278;
      
      private static const COLOR_FILL_OVER:uint = 672082;
      
      private static const COLOR_TEXT:uint = 13036276;
      
      private static const COLOR_TEXT_OVER:uint = 15327936;
      
      private static const TEXT_SIZE:int = 10;
      
      private var _label:TextField;
      
      private var _normalFormat:TextFormat;
      
      private var _overFormat:TextFormat;
      
      private var _itemWidth:Number;
      
      private var _itemHeight:Number;
      
      private var _action:String;
      
      public function RichChatUserMenuItem(param1:String, param2:String)
      {
         super();
         this._action = param1;
         this._label = new TextField();
         this._label.mouseEnabled = false;
         this._label.autoSize = TextFieldAutoSize.LEFT;
         this._normalFormat = new TextFormat("Verdana",TEXT_SIZE,COLOR_TEXT,false,false,false,null,null,TextFormatAlign.CENTER);
         this._overFormat = new TextFormat("Verdana",TEXT_SIZE,COLOR_TEXT_OVER,false,false,false,null,null,TextFormatAlign.CENTER);
         this._label.defaultTextFormat = this._normalFormat;
         this._label.text = param2;
         addChild(this._label);
         buttonMode = true;
         useHandCursor = true;
         addEventListener(MouseEvent.ROLL_OVER,this.handleRollOver);
         addEventListener(MouseEvent.ROLL_OUT,this.handleRollOut);
      }
      
      public function get action() : String
      {
         return this._action;
      }
      
      public function get labelWidth() : Number
      {
         return this._label.width;
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         this._itemWidth = param1;
         this._itemHeight = param2;
         this._label.autoSize = TextFieldAutoSize.NONE;
         this._label.width = Math.max(1,param1 - 10);
         this._label.height = param2;
         this._label.x = 5;
         this._label.y = 4;
         this._label.defaultTextFormat = this._normalFormat;
         this._label.setTextFormat(this._normalFormat);
         this.drawBackground(COLOR_FILL,COLOR_BORDER);
      }
      
      private function drawBackground(param1:uint, param2:uint) : void
      {
         graphics.clear();
         graphics.lineStyle(1,param2,1);
         graphics.beginFill(param1,0.96);
         graphics.drawRect(0.5,0.5,this._itemWidth - 1,this._itemHeight - 1);
         graphics.endFill();
      }
      
      private function handleRollOver(param1:MouseEvent) : void
      {
         this._label.defaultTextFormat = this._overFormat;
         this._label.setTextFormat(this._overFormat);
         this.drawBackground(COLOR_FILL_OVER,COLOR_BORDER_OVER);
      }
      
      private function handleRollOut(param1:MouseEvent) : void
      {
         this._label.defaultTextFormat = this._normalFormat;
         this._label.setTextFormat(this._normalFormat);
         this.drawBackground(COLOR_FILL,COLOR_BORDER);
      }
   }
}

