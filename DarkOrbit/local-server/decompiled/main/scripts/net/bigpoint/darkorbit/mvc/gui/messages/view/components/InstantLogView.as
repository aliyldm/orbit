package net.bigpoint.darkorbit.mvc.gui.messages.view.components
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.gui.messages.model.vo.InstantLogViewConfigurationVO;
   import net.bigpoint.darkorbit.mvc.gui.messages.model.vo.LogMessageProfileVO;
   
   public class InstantLogView extends Sprite
   {
      
      private static const PADDING_Y:int = 6;
      
      private var messageBuffer:Vector.<InstantMessageItem> = new Vector.<InstantMessageItem>(0);
      
      private var displayBuffer:Vector.<InstantMessageItem> = new Vector.<InstantMessageItem>(0);
      
      private var offset:int = 0;
      
      private var _itemWidth:int;
      
      private var _config:InstantLogViewConfigurationVO;
      
      private var _drawPointer:uint;
      
      public function InstantLogView(param1:InstantLogViewConfigurationVO)
      {
         super();
         this._config = param1;
         this._itemWidth = param1.width;
         addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.handleRemovedFromStage);
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         ScreenManager.getInstance().resized.add(this.updatePosition);
         this.updatePosition();
      }
      
      private function handleRemovedFromStage(param1:Event) : void
      {
         ScreenManager.getInstance().resized.remove(this.updatePosition);
      }
      
      private function updatePosition() : void
      {
         x = ScreenManager.halfScreenWidth;
         y = this._config.y;
      }
      
      public function addMessage(param1:String, param2:LogMessageProfileVO) : void
      {
         var _loc3_:InstantMessageItem = new InstantMessageItem(param1,this._itemWidth,param2);
         this.messageBuffer.push(_loc3_);
         this.messageBuffer.sort(InstantMessageItem.sort);
         this.update();
      }
      
      private function update() : void
      {
         clearTimeout(this._drawPointer);
         this._drawPointer = setTimeout(this.draw,10);
      }
      
      private function draw() : void
      {
         if(this.messageBuffer.length == 0)
         {
            this.layoutDisplayBuffer();
            return;
         }
         var _loc1_:int = Math.max(Math.min(this.displayBuffer.length,this._config.maxEntries - this.messageBuffer.length),0);
         while(this.displayBuffer.length > _loc1_)
         {
            this.cleanupItem(this.displayBuffer.pop());
         }
         while(this.messageBuffer.length != 0)
         {
            this.displayBuffer.unshift(this.messageBuffer.shift());
         }
         this.displayBuffer.length = Math.min(this._config.maxEntries,this.displayBuffer.length);
         this.layoutDisplayBuffer();
      }
      
      private function layoutDisplayBuffer() : void
      {
         var _loc2_:InstantMessageItem = null;
         this.offset = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this.displayBuffer.length)
         {
            _loc2_ = this.displayBuffer[_loc1_];
            _loc2_.moveTo(this.offset);
            addChild(_loc2_);
            _loc2_.addEventListener(InstantMessageItem.HANDLE_FADEOUT_COMPLETE,this.handleFadeOut);
            _loc2_.start();
            this.offset += _loc2_.height + PADDING_Y;
            _loc1_++;
         }
      }
      
      private function handleFadeOut(param1:Event) : void
      {
         var _loc2_:InstantMessageItem = param1.target as InstantMessageItem;
         this.cleanupItem(_loc2_);
         var _loc3_:Number = this.displayBuffer.indexOf(_loc2_);
         if(_loc3_ != -1)
         {
            this.displayBuffer.splice(_loc3_,1);
         }
         this.draw();
      }
      
      private function cleanupItem(param1:InstantMessageItem) : void
      {
         param1.removeEventListener(InstantMessageItem.HANDLE_FADEOUT_COMPLETE,this.handleFadeOut);
         param1.dispose();
      }
   }
}

