package net.bigpoint.darkorbit.mvc.chatclient.view.richtext.emoji
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class RichChatEmojiPanel extends Sprite
   {
      
      private static const COLUMN_COUNT:int = 6;
      
      private static const CELL_SIZE:Number = 28;
      
      private static const ICON_SIZE:Number = 22;
      
      private static const PADDING:Number = 7;
      
      public function RichChatEmojiPanel()
      {
         super();
         mouseEnabled = true;
         mouseChildren = true;
         this.build();
      }
      
      private function build() : void
      {
         var _loc6_:RichChatEmojiCell = null;
         var _loc1_:Vector.<RichChatEmojiVO> = RichChatEmojiRegistry.emojis;
         var _loc2_:int = Math.max(1,Math.ceil(_loc1_.length / COLUMN_COUNT));
         var _loc3_:Number = PADDING * 2 + COLUMN_COUNT * CELL_SIZE;
         var _loc4_:Number = PADDING * 2 + _loc2_ * CELL_SIZE;
         graphics.beginFill(202784,0.96);
         graphics.lineStyle(1,43478,1);
         graphics.drawRect(0,0,_loc3_,_loc4_);
         graphics.endFill();
         var _loc5_:int = 0;
         while(_loc5_ < _loc1_.length)
         {
            _loc6_ = new RichChatEmojiCell(_loc1_[_loc5_].id);
            _loc6_.x = PADDING + _loc5_ % COLUMN_COUNT * CELL_SIZE;
            _loc6_.y = PADDING + int(_loc5_ / COLUMN_COUNT) * CELL_SIZE;
            _loc6_.addEventListener(MouseEvent.CLICK,this.handleCellClicked);
            addChild(_loc6_);
            _loc5_++;
         }
      }
      
      private function handleCellClicked(param1:MouseEvent) : void
      {
         var _loc2_:RichChatEmojiCell = param1.currentTarget as RichChatEmojiCell;
         if(_loc2_)
         {
            dispatchEvent(new RichChatEmojiEvent(RichChatEmojiEvent.SELECTED,_loc2_.emojiId));
         }
      }
   }
}

