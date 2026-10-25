package com.bigpoint.utils.ui.buttons
{
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   
   public class ToggleButtonDecorator extends StatesButtonDecorator
   {
      
      protected var _checked:Boolean = false;
      
      public function ToggleButtonDecorator(param1:DisplayObjectContainer)
      {
         super(param1);
      }
      
      public function toggle() : void
      {
         this._checked = !this._checked;
         selected = this._checked;
      }
      
      override protected function clickHandler(param1:MouseEvent) : void
      {
         this.toggle();
      }
      
      public function get checked() : Boolean
      {
         return this._checked;
      }
   }
}

