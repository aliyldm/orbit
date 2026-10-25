package net.bigpoint.darkorbit.mvc.chatclient.view.richtext
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class RichChatNewMessageButton extends Sprite
   {
      
      public static const BUTTON_WIDTH:Number = 88;
      
      public static const BUTTON_HEIGHT:Number = 20;
      
      private var _text:TextField = new TextField();
      
      public function RichChatNewMessageButton()
      {
         super();
         buttonMode = true;
         useHandCursor = true;
         mouseChildren = false;
         this._text.defaultTextFormat = new TextFormat("Verdana",9,15327936,true,null,null,null,null,TextFormatAlign.CENTER);
         this._text.width = BUTTON_WIDTH;
         this._text.height = BUTTON_HEIGHT;
         this._text.y = 2;
         this._text.text = BPLocale.getItemInCategory("chat","chat_new_message");
         this._text.selectable = false;
         this._text.mouseEnabled = false;
         addChild(this._text);
         addEventListener(MouseEvent.ROLL_OVER,this.handleRollOver);
         addEventListener(MouseEvent.ROLL_OUT,this.handleRollOut);
         addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
         addEventListener(MouseEvent.CLICK,this.handleClick);
         this.drawState(405824,43222);
      }
      
      private function drawState(param1:uint, param2:uint) : void
      {
         graphics.clear();
         graphics.lineStyle(1,param2,1,true);
         graphics.beginFill(param1);
         graphics.drawRoundRect(0,0,BUTTON_WIDTH,BUTTON_HEIGHT,4,4);
         graphics.endFill();
      }
      
      private function handleRollOver(param1:MouseEvent) : void
      {
         this.drawState(478048,55039);
      }
      
      private function handleRollOut(param1:MouseEvent) : void
      {
         this.drawState(405824,43222);
      }
      
      private function handleMouseDown(param1:MouseEvent) : void
      {
         this.drawState(547956,55039);
      }
      
      private function handleClick(param1:MouseEvent) : void
      {
         this.drawState(478048,55039);
      }
   }
}

