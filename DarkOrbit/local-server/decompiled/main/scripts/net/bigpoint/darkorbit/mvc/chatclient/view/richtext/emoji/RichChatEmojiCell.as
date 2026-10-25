package net.bigpoint.darkorbit.mvc.chatclient.view.richtext.emoji
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   internal class RichChatEmojiCell extends Sprite
   {
      
      private static const CELL_SIZE:Number = 28;
      
      private static const ICON_SIZE:Number = 22;
      
      public var emojiId:String;
      
      public function RichChatEmojiCell(param1:String)
      {
         super();
         this.emojiId = param1;
         buttonMode = true;
         mouseChildren = false;
         this.drawBackground(404278);
         var _loc2_:Bitmap = RichChatEmojiRegistry.createBitmap(param1,ICON_SIZE,ICON_SIZE);
         if(_loc2_)
         {
            _loc2_.x = (CELL_SIZE - ICON_SIZE) * 0.5;
            _loc2_.y = (CELL_SIZE - ICON_SIZE) * 0.5;
            addChild(_loc2_);
         }
         addEventListener(MouseEvent.ROLL_OVER,this.handleRollOver);
         addEventListener(MouseEvent.ROLL_OUT,this.handleRollOut);
      }
      
      private function drawBackground(param1:uint) : void
      {
         graphics.clear();
         graphics.beginFill(param1,0.9);
         graphics.lineStyle(1,745592,0.7);
         graphics.drawRect(0,0,CELL_SIZE - 2,CELL_SIZE - 2);
         graphics.endFill();
      }
      
      private function handleRollOver(param1:MouseEvent) : void
      {
         this.drawBackground(674656);
      }
      
      private function handleRollOut(param1:MouseEvent) : void
      {
         this.drawBackground(404278);
      }
   }
}

