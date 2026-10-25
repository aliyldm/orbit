package net.bigpoint.darkorbit.mvc.common.view.components
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class NotificationCountBadge extends Sprite
   {
      
      private static const HEIGHT:Number = 16;
      
      private static const DOT_SIZE:Number = 8;
      
      private static const MIN_WIDTH:Number = 16;
      
      private static const HORIZONTAL_PADDING:Number = 4;
      
      private static const MAX_DISPLAY_COUNT:int = 99;
      
      private var _count:int;
      
      private var _showCount:Boolean = true;
      
      private var _textField:TextField = new TextField();
      
      public function NotificationCountBadge()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
         this._textField.defaultTextFormat = new TextFormat("Arial",9,16777215,true,null,null,null,null,TextFormatAlign.CENTER);
         this._textField.height = HEIGHT;
         this._textField.selectable = false;
         this._textField.mouseEnabled = false;
         addChild(this._textField);
         this.count = 0;
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function set count(param1:int) : void
      {
         this._count = Math.max(0,param1);
         this.redraw();
      }
      
      public function get showCount() : Boolean
      {
         return this._showCount;
      }
      
      public function set showCount(param1:Boolean) : void
      {
         if(this._showCount == param1)
         {
            return;
         }
         this._showCount = param1;
         this.redraw();
      }
      
      private function redraw() : void
      {
         visible = this._count > 0;
         this._textField.visible = visible && this._showCount;
         if(!visible)
         {
            return;
         }
         var _loc1_:Number = this._showCount ? HEIGHT : DOT_SIZE;
         var _loc2_:Number = this._showCount ? MIN_WIDTH : DOT_SIZE;
         if(this._showCount)
         {
            this._textField.text = this._count > MAX_DISPLAY_COUNT ? MAX_DISPLAY_COUNT + "+" : String(this._count);
            _loc2_ = Math.max(MIN_WIDTH,Math.ceil(this._textField.textWidth) + HORIZONTAL_PADDING * 2);
            this._textField.width = _loc2_;
            this._textField.y = Math.round((HEIGHT - this._textField.textHeight) * 0.5) - 2;
         }
         else
         {
            this._textField.text = "";
            this._textField.width = 0;
         }
         graphics.clear();
         graphics.beginFill(14096672);
         graphics.drawRoundRect(0,0,_loc2_,_loc1_,_loc1_,_loc1_);
         graphics.endFill();
      }
   }
}

